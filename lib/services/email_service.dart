import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmailService {
  // Gửi email SOS
  static Future<bool> sendSOSEmail({
    required String userName,
    required String userEmail,
    required String address,
    required double latitude,
    required double longitude,
    required List<String> recipientEmails,
    String? description,
    File? imageFile,
    File? audioFile,
  }) async {
    try {
      // Lấy config từ .env
      final smtpUsername = dotenv.env['MAIL_USERNAME'] ?? '';
      final smtpPassword = dotenv.env['MAIL_PASSWORD'] ?? '';
      
      if (smtpUsername.isEmpty || smtpPassword.isEmpty) {
        print('Email configuration is missing');
        return false;
      }

      final smtpServer = gmail(smtpUsername, smtpPassword);

      final message = Message()
        ..from = Address(smtpUsername, 'SAFE GUARD')
        ..recipients.addAll(recipientEmails)
        ..subject = '🚨 CẢNH BÁO KHẨN CẤP - $userName cần giúp đỡ!'
        ..html = _buildSOSEmailBody(userName, userEmail, address, latitude, longitude, description: description, audioFile: audioFile);

      // Đính kèm ảnh nếu có
      if (imageFile != null && await imageFile.exists()) {
        message.attachments.add(
          FileAttachment(imageFile)..fileName = 'sos_image.jpg',
        );
      }

      // Đính kèm file audio nếu có (cho trường hợp khẩn cấp)
      if (audioFile != null && await audioFile.exists()) {
        message.attachments.add(
          FileAttachment(audioFile)..fileName = 'sos_audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
        );
      }

      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport.toString()}');
      return true;
    } catch (e) {
      print('Error sending SOS email: $e');
      return false;
    }
  }

  // Gửi email chia sẻ vị trí
  static Future<bool> sendLocationEmail({
    required String userName,
    required String userEmail,
    required String address,
    required double latitude,
    required double longitude,
    required String recipientEmail,
  }) async {
    try {
      final smtpUsername = dotenv.env['MAIL_USERNAME'] ?? '';
      final smtpPassword = dotenv.env['MAIL_PASSWORD'] ?? '';
      
      if (smtpUsername.isEmpty || smtpPassword.isEmpty) {
        print('Email configuration is missing');
        return false;
      }

      final smtpServer = gmail(smtpUsername, smtpPassword);

      final message = Message()
        ..from = Address(smtpUsername, 'SAFE GUARD')
        ..recipients.add(recipientEmail)
        ..subject = '📍 Chia sẻ vị trí từ $userName - SAFE GUARD'
        ..html = _buildLocationEmailBody(userName, userEmail, address, latitude, longitude);

      final sendReport = await send(message, smtpServer);
      print('Location email sent: ${sendReport.toString()}');
      return true;
    } catch (e) {
      print('Error sending location email: $e');
      return false;
    }
  }

  // HTML body cho email SOS
  static String _buildSOSEmailBody(
    String userName,
    String userEmail,
    String address,
    double latitude,
    double longitude, {
    String? description,
    File? audioFile,
  }) {
    final now = DateTime.now();
    final time = '${now.hour}:${now.minute}:${now.second} - ${now.day}/${now.month}/${now.year}';
    
    return '''
    <html>
      <head>
        <style>
          body { font-family: Arial, sans-serif; background-color: #f5f5f5; }
          .container { max-width: 600px; margin: 0 auto; background-color: white; padding: 20px; border-radius: 10px; }
          .header { background-color: #F44336; color: white; padding: 20px; border-radius: 5px; text-align: center; }
          .content { padding: 20px; }
          .info-box { background-color: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 15px 0; }
          .map-link { background-color: #4CAF50; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block; }
          .footer { color: #999; font-size: 12px; text-align: center; margin-top: 20px; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>🚨 CẢNH BÁO KHẨN CẤP</h1>
            <p style="margin: 0;">$userName cần giúp đỡ ngay!</p>
          </div>
          
          <div class="content">
            <h2 style="color: #333;">Thông tin cảnh báo:</h2>
            
            <div class="info-box">
              <p><strong>Người cần trợ giúp:</strong> $userName</p>
              <p><strong>Email liên hệ:</strong> $userEmail</p>
              <p><strong>Thời gian:</strong> $time</p>
            </div>
            
            <h3 style="color: #F44336;">📍 Vị trí hiện tại:</h3>
            <div class="info-box">
              <p><strong>Địa chỉ:</strong> $address</p>
              <p><strong>Tọa độ:</strong> $latitude, $longitude</p>
              <p>
                <a href="https://www.google.com/maps?q=$latitude,$longitude" class="map-link" target="_blank">
                  📍 Mở Google Maps
                </a>
              </p>
            </div>
            
            ${description != null && description.isNotEmpty ? '''
            <h3 style="color: #333;">📝 Mô tả tình huống:</h3>
            <div class="info-box" style="background-color: #f0f8ff;">
              <p style="white-space: pre-wrap;">${description.replaceAll('\n', '<br>')}</p>
            </div>
            ''' : ''}
            
            ${description != null && description.isNotEmpty ? '''
            <p style="color: #666; font-size: 14px; margin-top: 10px;">
              <strong>📷 Ảnh đính kèm:</strong> Xem file đính kèm trong email
            </p>
            ''' : ''}
            
            ${audioFile != null ? '''
            <div class="info-box" style="background-color: #fff3cd; border-left-color: #ff9800;">
              <p style="margin: 0; color: #e65100;">
                <strong>🎤 File âm thanh đính kèm:</strong> Đã ghi âm 5 giây từ thiết bị của $userName
              </p>
              <p style="margin: 5px 0 0 0; font-size: 12px; color: #666;">
                Mở file audio đính kèm để nghe âm thanh từ hiện trường
              </p>
            </div>
            ''' : ''}
            
            <h3 style="color: #333;">📞 Hành động cần thực hiện:</h3>
            <ul>
              <li>Hãy liên hệ ngay với $userName để xác nhận tình trạng</li>
              <li>Nếu cần, hãy gọi cảnh sát (113) hoặc cơ quan y tế (115)</li>
              <li>Sử dụng bản đồ để xác định vị trí chính xác</li>
            </ul>
            
            <div class="footer">
              <p>Email này được gửi tự động từ hệ thống SAFE GUARD</p>
              <p>Đừng trả lời email này.</p>
            </div>
          </div>
        </div>
      </body>
    </html>
    ''';
  }

  // HTML body cho email chia sẻ vị trí
  static String _buildLocationEmailBody(
    String userName,
    String userEmail,
    String address,
    double latitude,
    double longitude,
  ) {
    final now = DateTime.now();
    final time = '${now.hour}:${now.minute}:${now.second} - ${now.day}/${now.month}/${now.year}';
    
    return '''
    <html>
      <head>
        <style>
          body { font-family: Arial, sans-serif; background-color: #f5f5f5; }
          .container { max-width: 600px; margin: 0 auto; background-color: white; padding: 20px; border-radius: 10px; }
          .header { background-color: #FF9500; color: white; padding: 20px; border-radius: 5px; text-align: center; }
          .content { padding: 20px; }
          .info-box { background-color: #f0f8ff; border-left: 4px solid #FF9500; padding: 15px; margin: 15px 0; }
          .map-link { background-color: #4CAF50; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block; margin-top: 10px; }
          .footer { color: #999; font-size: 12px; text-align: center; margin-top: 20px; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>📍 Chia sẻ vị trí</h1>
            <p style="margin: 0;">$userName đã chia sẻ vị trí của họ</p>
          </div>
          
          <div class="content">
            <div class="info-box">
              <p><strong>Người chia sẻ:</strong> $userName</p>
              <p><strong>Email:</strong> $userEmail</p>
              <p><strong>Thời gian:</strong> $time</p>
            </div>
            
            <h3 style="color: #333;">📍 Vị trí:</h3>
            <div class="info-box">
              <p><strong>Địa chỉ:</strong> $address</p>
              <p><strong>Tọa độ:</strong> $latitude, $longitude</p>
              <p>
                <a href="https://www.google.com/maps?q=$latitude,$longitude" class="map-link" target="_blank">
                  🗺️ Mở Google Maps
                </a>
              </p>
            </div>
            
            <div class="footer">
              <p>Email này được gửi tự động từ hệ thống SAFE GUARD</p>
            </div>
          </div>
        </div>
      </body>
    </html>
    ''';
  }
}

