import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  bool _hasAccepted = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _acceptAndContinue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('policy_accepted', true);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Future<void> _declineAndExit() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Xác nhận từ chối',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Bạn cần đồng ý với Chính sách bảo mật và Điều khoản sử dụng để dùng ứng dụng SAFE GUARD. Bạn có chắc muốn thoát không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Quay lại'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Exit the app
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Thoát ứng dụng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF03045E),
              Color(0xFF023E8A),
              Color(0xFF0077B6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.security_rounded,
                        color: Color(0xFF90E0EF),
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Chính sách bảo mật',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Điều khoản sử dụng & Quyền riêng tư',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF90E0EF),
                      ),
                    ),
                  ],
                ),
              ),

              // Policy content card
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                      bottom: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                      bottom: Radius.circular(16),
                    ),
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildIntroSection(),
                            const SizedBox(height: 20),
                            _buildSection(
                              icon: Icons.person_search_outlined,
                              title: '1. Thông tin chúng tôi thu thập',
                              color: const Color(0xFF0077B6),
                              content: [
                                _buildBullet(
                                  'Thông tin định danh',
                                  'Họ tên, mã số sinh viên (MSSV), địa chỉ email và số điện thoại khi bạn đăng ký tài khoản.',
                                ),
                                _buildBullet(
                                  'Dữ liệu vị trí',
                                  'Tọa độ GPS thời gian thực khi bạn kích hoạt tính năng chia sẻ vị trí hoặc SOS. Dữ liệu chỉ được thu thập khi bạn chủ động cho phép.',
                                ),
                                _buildBullet(
                                  'Thông tin thiết bị',
                                  'Mã token thông báo đẩy (FCM Token) nhằm gửi cảnh báo khẩn cấp tới thiết bị của bạn.',
                                ),
                                _buildBullet(
                                  'Lịch sử hoạt động',
                                  'Lịch sử yêu cầu SOS, nhật ký di chuyển trong khu vực an toàn (Geofence) và các hoạt động liên quan đến an toàn.',
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildSection(
                              icon: Icons.track_changes_outlined,
                              title: '2. Mục đích sử dụng dữ liệu',
                              color: const Color(0xFF023E8A),
                              content: [
                                _buildBullet(
                                  'Hỗ trợ khẩn cấp',
                                  'Cung cấp vị trí chính xác cho đội hỗ trợ khi có tín hiệu SOS, đảm bảo bạn được trợ giúp kịp thời.',
                                ),
                                _buildBullet(
                                  'Cảnh báo an toàn',
                                  'Gửi thông báo khi phát hiện bạn rời khỏi vùng an toàn (Geofence) hoặc khi có tình huống nguy hiểm trong khu vực.',
                                ),
                                _buildBullet(
                                  'Cải thiện dịch vụ',
                                  'Phân tích tổng hợp (ẩn danh) nhằm nâng cao chất lượng và độ chính xác của hệ thống cảnh báo.',
                                ),
                                _buildBullet(
                                  'Liên lạc hỗ trợ',
                                  'Gửi thông báo hệ thống, cập nhật chính sách và thông tin liên quan đến tài khoản của bạn.',
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildSection(
                              icon: Icons.shield_outlined,
                              title: '3. Bảo mật và lưu trữ dữ liệu',
                              color: const Color(0xFF0096C7),
                              content: [
                                _buildBullet(
                                  'Mã hóa truyền tải',
                                  'Mọi dữ liệu giữa ứng dụng và máy chủ đều được mã hóa bằng giao thức HTTPS/TLS.',
                                ),
                                _buildBullet(
                                  'Lưu trữ an toàn',
                                  'Dữ liệu cá nhân được lưu trữ trên máy chủ bảo mật. Mật khẩu được mã hóa bằng thuật toán băm một chiều (bcrypt).',
                                ),
                                _buildBullet(
                                  'Thời hạn lưu trữ',
                                  'Dữ liệu vị trí được lưu trong 90 ngày. Dữ liệu tài khoản được lưu đến khi bạn yêu cầu xóa.',
                                ),
                                _buildBullet(
                                  'Giới hạn truy cập',
                                  'Chỉ nhân viên có thẩm quyền và hệ thống tự động mới được phép truy cập dữ liệu của bạn.',
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildSection(
                              icon: Icons.share_location_outlined,
                              title: '4. Chia sẻ thông tin với bên thứ ba',
                              color: const Color(0xFF0077B6),
                              content: [
                                _buildBullet(
                                  'Không bán dữ liệu',
                                  'Chúng tôi tuyệt đối không bán, cho thuê hay trao đổi thông tin cá nhân của bạn với bất kỳ bên thứ ba nào vì mục đích thương mại.',
                                ),
                                _buildBullet(
                                  'Nhà cung cấp dịch vụ',
                                  'Chúng tôi sử dụng Firebase (Google) để gửi thông báo đẩy. Các nhà cung cấp này tuân thủ các tiêu chuẩn bảo mật nghiêm ngặt.',
                                ),
                                _buildBullet(
                                  'Yêu cầu pháp lý',
                                  'Dữ liệu chỉ được cung cấp cho cơ quan có thẩm quyền khi có yêu cầu hợp pháp hoặc trong trường hợp khẩn cấp đe dọa tính mạng.',
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildSection(
                              icon: Icons.manage_accounts_outlined,
                              title: '5. Quyền của người dùng',
                              color: const Color(0xFF023E8A),
                              content: [
                                _buildBullet(
                                  'Quyền truy cập',
                                  'Bạn có quyền xem toàn bộ thông tin cá nhân mà chúng tôi đang lưu trữ về bạn.',
                                ),
                                _buildBullet(
                                  'Quyền chỉnh sửa',
                                  'Bạn có thể cập nhật hoặc sửa đổi thông tin cá nhân trong phần Cài đặt tài khoản.',
                                ),
                                _buildBullet(
                                  'Quyền xóa dữ liệu',
                                  'Bạn có thể yêu cầu xóa tài khoản và toàn bộ dữ liệu liên quan bất cứ lúc nào thông qua bộ phận hỗ trợ.',
                                ),
                                _buildBullet(
                                  'Quyền rút lại đồng ý',
                                  'Bạn có thể tắt quyền truy cập vị trí hoặc thông báo đẩy bất kỳ lúc nào trong phần Cài đặt thiết bị.',
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildSection(
                              icon: Icons.gavel_outlined,
                              title: '6. Điều khoản sử dụng',
                              color: const Color(0xFF0096C7),
                              content: [
                                _buildBullet(
                                  'Đối tượng sử dụng',
                                  'Ứng dụng SAFE GUARD được phát triển dành riêng cho sinh viên, giảng viên và cán bộ của Trường Đại học FPT.',
                                ),
                                _buildBullet(
                                  'Sử dụng đúng mục đích',
                                  'Nghiêm cấm sử dụng tính năng SOS hoặc báo cáo sự cố giả mạo. Hành vi này có thể dẫn đến khóa tài khoản và xử lý theo quy định nhà trường.',
                                ),
                                _buildBullet(
                                  'Tính chính xác của thông tin',
                                  'Bạn chịu trách nhiệm đảm bảo thông tin đăng ký là trung thực và chính xác. Tài khoản sử dụng thông tin giả mạo sẽ bị xóa.',
                                ),
                                _buildBullet(
                                  'Thay đổi điều khoản',
                                  'Chúng tôi có thể cập nhật Chính sách bảo mật này theo thời gian. Bạn sẽ được thông báo khi có thay đổi quan trọng.',
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildContactSection(),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom actions
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Checkbox
                    GestureDetector(
                      onTap: () => setState(() => _hasAccepted = !_hasAccepted),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: _hasAccepted
                              ? Colors.white.withOpacity(0.15)
                              : Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _hasAccepted
                                ? const Color(0xFF90E0EF)
                                : Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: _hasAccepted
                                    ? const Color(0xFF00B4D8)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: _hasAccepted
                                      ? const Color(0xFF00B4D8)
                                      : Colors.white.withOpacity(0.5),
                                  width: 2,
                                ),
                              ),
                              child: _hasAccepted
                                  ? const Icon(Icons.check,
                                      color: Colors.white, size: 16)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Tôi đã đọc và đồng ý với Chính sách bảo mật và Điều khoản sử dụng của SAFE GUARD',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Agree button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _hasAccepted ? _acceptAndContinue : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B4D8),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              Colors.white.withOpacity(0.2),
                          disabledForegroundColor:
                              Colors.white.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: _hasAccepted ? 4 : 0,
                        ),
                        child: const Text(
                          'Đồng ý & Tiếp tục',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Decline button
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: TextButton(
                        onPressed: _declineAndExit,
                        child: Text(
                          'Từ chối',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF03045E).withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF0077B6).withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: Color(0xFF0077B6), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Vui lòng đọc kỹ Chính sách bảo mật và Điều khoản sử dụng trước khi sử dụng ứng dụng SAFE GUARD. Bằng cách nhấn "Đồng ý & Tiếp tục", bạn xác nhận đã đọc, hiểu và chấp nhận tất cả các điều khoản dưới đây.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Color color,
    required List<Widget> content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...content,
      ],
    );
  }

  Widget _buildBullet(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF0077B6),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF023E8A),
                    ),
                  ),
                  TextSpan(
                    text: description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF023E8A).withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF023E8A).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.contact_support_outlined,
                  color: Color(0xFF023E8A), size: 20),
              SizedBox(width: 8),
              Text(
                'Liên hệ & Hỗ trợ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023E8A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Nếu bạn có bất kỳ câu hỏi nào về Chính sách bảo mật hoặc cách chúng tôi xử lý dữ liệu của bạn, vui lòng liên hệ qua Ban Quản lý An ninh Trường Đại học FPT.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.phone_outlined, color: Color(0xFF023E8A), size: 16),
              SizedBox(width: 8),
              Text(
                '0355 137 755',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF023E8A),
                ),
              ),
              SizedBox(width: 6),
              Text(
                '(Mr. Hiển)',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Phiên bản chính sách: 1.0 — Cập nhật tháng 3/2026',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
