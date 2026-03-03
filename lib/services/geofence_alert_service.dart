import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'auth_service.dart';
import 'database_service.dart';
import 'geofence_service.dart';

/// Xử lý cảnh báo khi user ra khỏi khu vực an toàn:
///   1. Hiện dialog trong app
///   2. Gửi email cảnh báo tới tất cả liên hệ có email
///   3. Tạo SOS report lên backend (Pro)
///
/// Có cooldown 10 phút để tránh spam khi user đi lại gần biên.
class GeofenceAlertService {
  static final GeofenceAlertService _i = GeofenceAlertService._();
  factory GeofenceAlertService() => _i;
  GeofenceAlertService._();

  DateTime? _lastAlertAt;
  static const _cooldown = Duration(minutes: 10);

  bool get _isOnCooldown =>
      _lastAlertAt != null &&
      DateTime.now().difference(_lastAlertAt!) < _cooldown;

  /// Gọi từ [GeofenceService.onBreach].
  /// [navigatorCtx] = navigatorKey.currentContext
  Future<void> handle({
    required BuildContext? navigatorCtx,
    required double lat,
    required double lng,
    required double distanceM,
  }) async {
    if (_isOnCooldown) {
      debugPrint('GeofenceAlert: còn cooldown, bỏ qua');
      return;
    }
    _lastAlertAt = DateTime.now();

    // Load config trước – dùng context sau (mounted check implicit via navigatorKey)
    final cfg      = await GeofenceService.load();
    final zoneName = cfg?['name'] as String? ?? 'Khu vực an toàn';

    // 1 – Dialog trong app (chỉ dùng context sau khi chắc chắn còn valid)
    if (navigatorCtx != null && navigatorCtx.mounted) {
      _showDialog(navigatorCtx, zoneName, distanceM);
    }

    // 2 – Gửi email + SOS (không chờ)
    _sendEmailsAndSOS(lat: lat, lng: lng, distanceM: distanceM, zoneName: zoneName);
  }

  // ── In-app dialog ─────────────────────────────────────────────────────────

  void _showDialog(BuildContext ctx, String zoneName, double distM) {
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
          SizedBox(width: 8),
          Text('Cảnh báo vị trí!'),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bạn đã ra khỏi "$zoneName".',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Khoảng cách: ${distM.toInt()} m'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: const Row(
                children: [
                  Icon(Icons.email_outlined, size: 16, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Đang gửi cảnh báo email tới danh bạ tin cậy…',
                      style: TextStyle(fontSize: 12, color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  // ── Email + SOS ───────────────────────────────────────────────────────────

  Future<void> _sendEmailsAndSOS({
    required double lat,
    required double lng,
    required double distanceM,
    required String zoneName,
  }) async {
    try {
      final auth = AuthService();
      final user = auth.currentUser;
      if (user == null) return;

      // Lấy tất cả liên hệ cá nhân có email
      final contacts = await DatabaseService.instance.getContacts();
      final emails   = contacts
          .where((c) => c.contactEmail != null && c.contactEmail!.isNotEmpty)
          .map((c) => c.contactEmail!)
          .toList();

      // Luôn thêm email của chính user để user cũng nhận
      if (user.email.isNotEmpty && !emails.contains(user.email)) {
        emails.insert(0, user.email);
      }

      if (emails.isNotEmpty) {
        await _sendGeofenceEmail(
          user: user,
          recipientEmails: emails,
          lat: lat,
          lng: lng,
          distanceM: distanceM,
          zoneName: zoneName,
        );
      }

      // Tạo SOS report
      if (auth.isLoggedIn) {
        await auth.createSOSReport(
          latitude: lat,
          longitude: lng,
          message: 'Cảnh báo Geofence: Ra khỏi "$zoneName" – cách ${distanceM.toInt()} m',
        );
      }
    } catch (e) {
      debugPrint('GeofenceAlertService._sendEmailsAndSOS error: $e');
    }
  }

  Future<void> _sendGeofenceEmail({
    required dynamic user,
    required List<String> recipientEmails,
    required double lat,
    required double lng,
    required double distanceM,
    required String zoneName,
  }) async {
    try {
      final smtpUsername = dotenv.env['MAIL_USERNAME'] ?? '';
      final smtpPassword = dotenv.env['MAIL_PASSWORD'] ?? '';
      if (smtpUsername.isEmpty || smtpPassword.isEmpty) return;

      final now  = DateTime.now();
      final time = '${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')} '
                   '${now.day}/${now.month}/${now.year}';
      final mapsUrl = 'https://www.google.com/maps?q=$lat,$lng';

      final html = '''
<html><head><style>
  body{font-family:Arial,sans-serif;background:#f5f5f5;}
  .wrap{max-width:600px;margin:0 auto;background:#fff;border-radius:10px;overflow:hidden;}
  .hdr{background:#FF6B00;color:#fff;padding:20px;text-align:center;}
  .hdr h1{margin:0;font-size:22px;}
  .hdr p{margin:4px 0 0;opacity:.9;font-size:14px;}
  .body{padding:20px;}
  .box{background:#fff3cd;border-left:4px solid #FF6B00;padding:14px;margin:14px 0;border-radius:4px;}
  .mapbtn{display:inline-block;background:#4CAF50;color:#fff;padding:10px 20px;
          border-radius:6px;text-decoration:none;font-weight:bold;margin-top:8px;}
  .footer{color:#999;font-size:11px;text-align:center;padding:12px;}
</style></head><body>
<div class="wrap">
  <div class="hdr">
    <h1>⚠️ CẢNH BÁO KHU VỰC AN TOÀN</h1>
    <p>${user.fullName} đã ra khỏi khu vực quy định!</p>
  </div>
  <div class="body">
    <div class="box">
      <p><strong>Người dùng:</strong> ${user.fullName}</p>
      <p><strong>Email:</strong> ${user.email}</p>
      <p><strong>Thời gian:</strong> $time</p>
    </div>
    <h3 style="color:#FF6B00;">📍 Thông tin vi phạm:</h3>
    <div class="box">
      <p><strong>Khu vực an toàn:</strong> $zoneName</p>
      <p><strong>Khoảng cách ra ngoài:</strong> ${distanceM.toInt()} m</p>
      <p><strong>Tọa độ hiện tại:</strong> ${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}</p>
      <a href="$mapsUrl" class="mapbtn" target="_blank">📍 Xem vị trí trên Google Maps</a>
    </div>
    <h3>📞 Hành động cần thực hiện:</h3>
    <ul>
      <li>Liên hệ ngay với <strong>${user.fullName}</strong> để xác nhận tình trạng</li>
      <li>Nếu không liên lạc được, hãy gọi cảnh sát <strong>113</strong> hoặc cấp cứu <strong>115</strong></li>
    </ul>
  </div>
  <div class="footer">Email tự động từ SAFE GUARD – Đừng trả lời email này.</div>
</div>
</body></html>''';

      final smtpServer = gmail(smtpUsername, smtpPassword);
      final message = Message()
        ..from = Address(smtpUsername, 'SAFE GUARD')
        ..recipients.addAll(recipientEmails)
        ..subject = '⚠️ CẢNH BÁO: ${user.fullName} ra khỏi khu vực an toàn!'
        ..html = html;

      await send(message, smtpServer);
      debugPrint('✅ Geofence alert email sent to ${recipientEmails.length} recipients');
    } catch (e) {
      debugPrint('❌ _sendGeofenceEmail error: $e');
    }
  }
}
