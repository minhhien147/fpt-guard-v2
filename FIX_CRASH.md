# ✅ ĐÃ SỬA LỖI CRASH KHI CÀI APK

## 🐛 Vấn đề đã sửa

1. **Crash do thiếu file .env** ❌ → ✅ Fixed
   - App cố load file `.env` nhưng file không tồn tại
   - Đã thêm xử lý lỗi: nếu không có `.env`, sẽ dùng config mặc định

2. **Network Security** ❌ → ✅ Fixed
   - Android chặn HTTP traffic
   - Đã thêm `network_security_config.xml`

3. **Proguard Rules** ❌ → ✅ Fixed
   - Code bị obfuscate sai khi build release
   - Đã thêm `proguard-rules.pro`

4. **Hard-coded API URLs** ❌ → ✅ Fixed
   - Các service dùng URL cố định
   - Đã sửa để dùng từ file `.env`

## 🚀 Cách Build APK Ngay

### Cách 1: Dùng Script (Đơn giản nhất)

**Windows PowerShell:**
```powershell
.\build-apk.ps1
```

**Linux/Mac:**
```bash
chmod +x build-apk.sh
./build-apk.sh
```

### Cách 2: Build thủ công

```bash
# 1. Clean project
flutter clean

# 2. Get dependencies
flutter pub get

# 3. Build APK
flutter build apk --release
```

File APK sẽ ở: `build\app\outputs\flutter-apk\app-release.apk`

## 📝 Tạo file .env (Tùy chọn)

**Nếu không tạo file `.env`**: App sẽ tự động dùng URL mặc định
**Nếu muốn tùy chỉnh**: Tạo file `.env` trong thư mục gốc:

```env
# Production (Railway)
API_BASE_URL=https://web-production-dd806.up.railway.app

# Hoặc Local Development
# API_BASE_URL=http://10.0.2.2:5000  # Cho Android Emulator
# API_BASE_URL=http://192.168.1.100:5000  # Cho thiết bị thật
```

## 🎯 Kiểm tra

Sau khi build xong:

1. ✅ Cài APK lên điện thoại
2. ✅ Mở app - Nên thấy màn hình Splash
3. ✅ Đăng nhập/Đăng ký hoạt động bình thường

## 🔍 Nếu vẫn crash

Kết nối điện thoại qua USB và xem log:

```bash
flutter logs
```

Hoặc:

```bash
adb logcat | grep -i flutter
```

## 📚 Tài liệu khác

- **BUILD_APK_GUIDE.md** - Hướng dẫn chi tiết về build APK
- **build-apk.ps1** - Script tự động build cho Windows
- **build-apk.sh** - Script tự động build cho Linux/Mac

## 🎉 Tóm tắt

**Trước:**
- ❌ App crash ngay khi mở
- ❌ Không thể kết nối API
- ❌ Lỗi network security

**Bây giờ:**
- ✅ App chạy mượt mà
- ✅ Tự động xử lý config
- ✅ Hỗ trợ cả HTTP và HTTPS
- ✅ Dễ dàng thay đổi backend URL

---

**Cập nhật:** 15/01/2026
