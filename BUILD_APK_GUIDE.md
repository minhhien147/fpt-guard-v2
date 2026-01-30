# Hướng dẫn Build APK cho SAFE GUARD

## 📋 Các vấn đề đã sửa

1. ✅ **Crash do thiếu file .env** - Đã thêm xử lý lỗi khi file .env không tồn tại
2. ✅ **Network Security Config** - Cho phép kết nối HTTP (cần cho một số backend)
3. ✅ **Proguard Rules** - Bảo vệ code khỏi bị obfuscate sai

## 🚀 Cách Build APK

### Bước 1: Tạo file .env (Tùy chọn)

Tạo file `.env` trong thư mục gốc project với nội dung:

```
API_BASE_URL=https://fpt-guard-backend.railway.app
APP_NAME=SAFE GUARD
APP_VERSION=2.0.0
```

**Lưu ý:** Nếu không tạo file `.env`, app sẽ tự động dùng URL mặc định: `https://fpt-guard-backend.railway.app`

### Bước 2: Clean project

```bash
flutter clean
```

### Bước 3: Get dependencies

```bash
flutter pub get
```

### Bước 4: Build APK

**Option 1: Build Release APK (Khuyên dùng)**
```bash
flutter build apk --release
```

**Option 2: Build APK cho từng CPU architecture (APK nhẹ hơn)**
```bash
flutter build apk --split-per-abi --release
```

**Option 3: Build Debug APK (Chỉ để test)**
```bash
flutter build apk --debug
```

### Bước 5: Tìm file APK

File APK sẽ được tạo tại:
- Release: `build/app/outputs/flutter-apk/app-release.apk`
- Split ABI: `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk` và các file khác
- Debug: `build/app/outputs/flutter-apk/app-debug.apk`

## 📱 Cài đặt trên điện thoại

1. Kết nối điện thoại qua USB hoặc gửi file APK qua Bluetooth/Email
2. Bật "Cài đặt từ nguồn không xác định" trong Settings
3. Mở file APK và cài đặt

## 🔍 Kiểm tra lỗi

Nếu app vẫn crash, kiểm tra log bằng cách:

1. Kết nối điện thoại qua USB
2. Bật USB Debugging
3. Chạy lệnh:
```bash
flutter logs
# hoặc
adb logcat
```

## ⚙️ Cấu hình Backend

### Backend Production (Railway)
```
API_BASE_URL=https://web-production-dd806.up.railway.app
```

### Backend Local
- **Android Emulator:** `http://10.0.2.2:5000`
- **Thiết bị thật:** `http://192.168.1.XXX:5000` (thay XXX bằng IP máy tính của bạn)

## 🐛 Các lỗi thường gặp

### Lỗi: "Cleartext HTTP traffic not permitted"
✅ **Đã sửa** - Đã thêm network security config

### Lỗi: App crash ngay khi mở
✅ **Đã sửa** - Đã xử lý trường hợp file .env không tồn tại

### Lỗi: "MissingPluginException"
**Giải pháp:** Clean và rebuild
```bash
flutter clean
flutter pub get
flutter build apk --release
```

### Lỗi: Location/Camera không hoạt động
**Giải pháp:** Cấp quyền trong Settings của điện thoại

## 📝 Ghi chú

- Minimum SDK: 21 (Android 5.0)
- Target SDK: 36 (Android 14)
- Compile SDK: 36

## 🔐 Signing Config

Hiện tại đang dùng `signingConfig debug`. Để release app lên Google Play Store, bạn cần tạo keystore riêng:

```bash
keytool -genkey -v -keystore ~/fpt-guard-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias fpt-guard
```

Sau đó cập nhật `android/app/build.gradle` với signing config của bạn.
