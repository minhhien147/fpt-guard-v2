// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'FPT Guard';

  @override
  String get hello => 'Xin chào';

  @override
  String get currentLocation => 'Vị trí hiện tại';

  @override
  String get gettingLocation => 'Đang lấy vị trí...';

  @override
  String get coordinates => 'Tọa độ';

  @override
  String get share => 'Chia sẻ';

  @override
  String get shareLocation => 'Chia sẻ vị trí';

  @override
  String get mekongWaterLevel => 'Mực nước Sông Mekong';

  @override
  String get track5Stations => 'Theo dõi 5 trạm ĐBSCL';

  @override
  String get sosButton => 'SOS Khẩn cấp';

  @override
  String get sendingSOS => 'Đang gửi SOS...';

  @override
  String get quickCall => 'Gọi nhanh';

  @override
  String get add => 'Thêm';

  @override
  String get addContact => 'Thêm liên lạc';

  @override
  String get name => 'Tên';

  @override
  String get nameHint => 'Ví dụ: Bố, Mẹ, Bạn thân...';

  @override
  String get phoneNumber => 'Số điện thoại';

  @override
  String get phoneHint => 'Ví dụ: 0901234567';

  @override
  String get cancel => 'Hủy';

  @override
  String get emergencyContacts => 'Liên hệ khẩn cấp';

  @override
  String get security => 'Bảo vệ';

  @override
  String get police => 'Công an 113';

  @override
  String get hospital => 'Cấp cứu 115';

  @override
  String get fireStation => 'Cứu hỏa 114';

  @override
  String get personalContacts => 'Danh bạ cá nhân';

  @override
  String get deleteContact => 'Xóa liên lạc';

  @override
  String deleteContactConfirm(String name) {
    return 'Bạn có chắc muốn xóa \"$name\" khỏi danh bạ?';
  }

  @override
  String get delete => 'Xóa';

  @override
  String get settings => 'Cài đặt';

  @override
  String get personalInfo => 'Thông tin cá nhân';

  @override
  String get fullName => 'Họ và tên';

  @override
  String get fullNameRequired => 'Họ và tên *';

  @override
  String get studentId => 'Mã số sinh viên';

  @override
  String get studentIdRequired => 'Mã số sinh viên *';

  @override
  String get phone => 'Số điện thoại';

  @override
  String get phoneRequired => 'Số điện thoại *';

  @override
  String get email => 'Email';

  @override
  String get emailRequired => 'Email *';

  @override
  String get emailHelper => 'Email để nhận cảnh báo khẩn cấp';

  @override
  String get saveInfo => 'Lưu thông tin';

  @override
  String get saved => 'Đã lưu thông tin';

  @override
  String get error => 'Có lỗi xảy ra';

  @override
  String get appInfo => 'Thông tin ứng dụng';

  @override
  String get version => 'Phiên bản';

  @override
  String get organization => 'Đơn vị';

  @override
  String get organizationName => 'FPT University Cần Thơ';

  @override
  String get application => 'Ứng dụng';

  @override
  String get appName => 'FPT Guard 2.0';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get selectLanguage => 'Chọn ngôn ngữ';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get validationName => 'Vui lòng nhập họ tên';

  @override
  String get validationStudentId => 'Vui lòng nhập MSSV';

  @override
  String get validationPhone => 'Vui lòng nhập số điện thoại';

  @override
  String get validationEmail => 'Vui lòng nhập email';

  @override
  String get validationEmailInvalid => 'Email không hợp lệ';

  @override
  String get updateUserInfo =>
      'Vui lòng cập nhật thông tin cá nhân trong Cài đặt';

  @override
  String get gettingLocationProgress => 'Đang lấy vị trí...';

  @override
  String get cannotGetLocation => 'Không thể lấy vị trí. Vui lòng bật GPS';

  @override
  String get pleaseAddEmergencyEmail =>
      'Vui lòng thêm email liên hệ khẩn cấp trong Danh bạ';

  @override
  String get cannotCall => 'Không thể gọi điện';

  @override
  String get noContactWithEmail => 'Không có liên hệ nào có email để chia sẻ';

  @override
  String get sendingLocation => 'Đang gửi vị trí...';

  @override
  String get locationShared => '✅ Đã chia sẻ vị trí thành công!';

  @override
  String get cannotShareLocation => '❌ Không thể chia sẻ vị trí';

  @override
  String get locationUpdated => 'Đã cập nhật vị trí';

  @override
  String get pleaseEnterAllInfo => 'Vui lòng nhập đầy đủ thông tin';

  @override
  String get contactAdded => 'Đã thêm liên lạc';

  @override
  String get cannotAddContact => 'Không thể thêm liên lạc';

  @override
  String get contactDeleted => 'Đã xóa liên lạc';

  @override
  String get cannotDeleteContact => 'Không thể xóa liên lạc';

  @override
  String get shakeDetected => 'Phát hiện rung lắc!';

  @override
  String get sendSOSNow =>
      'Gửi cảnh báo SOS khẩn cấp ngay lập tức?\n(Không cần chụp ảnh)';

  @override
  String get sendSOSButton => 'Gửi SOS Ngay';

  @override
  String get autoWarning =>
      '⚠️ CẢNH BÁO TỰ ĐỘNG: Phát hiện rung lắc khẩn cấp từ thiết bị!';

  @override
  String sosSentSuccess(int count) {
    return '✅ Đã gửi cảnh báo SOS đến $count email!';
  }

  @override
  String get sosError => '❌ Có lỗi khi gửi email';

  @override
  String get refresh => 'Làm mới';

  @override
  String get call => 'Gọi';

  @override
  String get contacts => 'Danh bạ';

  @override
  String get location => 'Vị trí';

  @override
  String get news => 'Tin tức';

  @override
  String get tide => 'Thủy triều';

  @override
  String get waterLevel => 'Mực nước';

  @override
  String get sosForm => 'Biểu mẫu SOS';

  @override
  String get home => 'Trang chủ';
}
