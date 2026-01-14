# 🚀 Chạy App Giả Lập - Hướng Dẫn Nhanh

## 📋 Yêu Cầu:
- ✅ Flutter SDK
- ✅ Android Studio
- ✅ Internet (để kết nối backend)

---

## ⚡ Chạy App (5 Phút):

### 1️⃣ Cài Dependencies
```bash
flutter pub get
```

### 2️⃣ Chạy Emulator
```bash
# Xem danh sách emulators
flutter emulators

# Chạy emulator (chọn 1 trong list)
flutter emulators --launch <emulator_id>

# Ví dụ:
flutter emulators --launch Medium_Phone_API_36.1
```

### 3️⃣ Chạy App
```bash
flutter run
```

**Hoặc chạy trên Windows:**
```bash
flutter run -d windows
```

---

## 🔐 Login Vào App:

### Tài Khoản Admin:
```
Email: admin@fptguard.com
Password: admin123
```

### Tài Khoản User Mẫu:
```
Email: user@example.com
Password: password123
```

---

## 🌐 Backend API:

App đang kết nối với backend trên Railway:
```
URL: https://web-production-dd806.up.railway.app
```

**✅ Đã cấu hình sẵn!** Backend URL đã được set trong code.

---

## 🎯 Admin Dashboard (Web):

Truy cập:
```
https://web-production-dd806.up.railway.app/admin
```

Login:
```
Email: admin@fptguard.com
Password: admin123
```

**→ Quản lý users, xem dữ liệu, monitoring!**

---

## ❓ Troubleshooting:

### Lỗi: Không Kết Nối Backend
- ✅ Check URL trong `auth_service.dart` và `api_service.dart`
- ✅ Check Railway backend đang chạy
- ✅ Check internet connection

### Lỗi: Emulator Không Chạy
```bash
# Mở Android Studio → AVD Manager → Start emulator
```

### Lỗi: Flutter Command Not Found
```bash
# Cài Flutter SDK: https://flutter.dev/docs/get-started/install
```

---

## 🎉 Xong!

**App đang chạy trên emulator!**

**Backend chạy 24/7 trên Railway!**

**Tất cả tự động update dữ liệu mỗi giờ!**

---

**📱 Enjoy your FPT Guard 2.0 App!** 🌊
