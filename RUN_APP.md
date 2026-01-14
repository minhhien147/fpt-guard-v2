# 🚀 Hướng Dẫn Chạy App FPT Guard 2.0

## ✅ Checklist Trước Khi Chạy

- [ ] Đã cài Flutter SDK
- [ ] Đã cài Python 3.11+
- [ ] Đã chạy `flutter pub get`
- [ ] Đã cài dependencies Python: `pip install -r backend-python/requirements.txt`

---

## 🎯 Cách 1: Chạy Đầy Đủ (Backend + Flutter App)

### Bước 1: Mở Terminal/Command Prompt #1 - Backend

```bash
# Di chuyển vào thư mục backend
cd backend-python

# Chạy backend server
python app.py
```

**✅ Thành công khi thấy:**
```
======================================================================
MEKONG RIVER WATER LEVEL MONITORING - API SERVER
======================================================================

Khởi động scheduler...
Khởi động Flask API server...
  → Host: 0.0.0.0
  → Port: 5000
  → API URL: http://localhost:5000
```

**🌐 Test Backend:**
- Mở trình duyệt: http://localhost:5000
- Admin Dashboard: http://localhost:5000/admin
  - Email: `admin@fptguard.com`
  - Password: `admin123`

---

### Bước 2: Mở Terminal/Command Prompt #2 - Flutter App

```bash
# Ở thư mục gốc project (không phải backend-python)
# Nếu đang trong backend-python, ra ngoài:
cd ..

# Chạy Flutter app
flutter run
```

**📱 Chọn thiết bị:**
```
[1]: Windows (desktop)
[2]: Chrome (web)
[3]: Edge (web)
[4]: Android Emulator (nếu đã mở)
```

Nhập số để chọn, ví dụ: `1` cho Windows Desktop

**✅ Thành công khi thấy:**
```
✓ Built build\windows\runner\Release\fpt_guard_v2.exe
Launching lib\main.dart on Windows in debug mode...
Syncing files to device Windows...
```

App sẽ tự động mở!

---

## 🎯 Cách 2: Chỉ Chạy Flutter App (Dùng Backend Online)

Nếu bạn đã deploy backend lên Railway/Render:

### Bước 1: Cập nhật API URL

**File: `lib/services/auth_service.dart`**
```dart
// Thay URL local bằng URL online
static const String baseUrl = 'https://your-app.railway.app';
```

**File: `lib/services/api_service.dart`**
```dart
static const String baseUrl = 'https://your-app.railway.app';
```

### Bước 2: Chạy App

```bash
flutter run
```

---

## 📱 Chạy Trên Các Thiết Bị Khác Nhau

### Windows Desktop

```bash
flutter run -d windows
```

### Android Emulator

```bash
# Mở Android Emulator trước
# Sau đó:
flutter run -d emulator-5554

# Hoặc để Flutter tự chọn:
flutter run
```

Xem hướng dẫn: [ANDROID_EMULATOR_GUIDE.md](ANDROID_EMULATOR_GUIDE.md)

### Web (Chrome)

```bash
flutter run -d chrome
```

### Web (Edge)

```bash
flutter run -d edge
```

---

## 🔧 Troubleshooting

### ❌ Lỗi: Port 5000 đã được sử dụng

**Windows:**
```powershell
# Tìm process đang dùng port 5000
netstat -ano | findstr :5000

# Giết process (thay <PID> bằng số PID tìm được)
taskkill /PID <PID> /F
```

**Mac/Linux:**
```bash
lsof -ti:5000 | xargs kill -9
```

---

### ❌ Lỗi: ModuleNotFoundError (Python)

```bash
cd backend-python
pip install -r requirements.txt
```

---

### ❌ Lỗi: Flutter dependencies

```bash
flutter pub get
flutter clean
flutter pub get
```

---

### ❌ Backend chạy nhưng Flutter không kết nối được

**Kiểm tra API URL:**

Nếu chạy trên:
- **Windows Desktop / Web:** `http://localhost:5000`
- **Android Emulator:** `http://10.0.2.2:5000`
- **iOS Simulator:** `http://localhost:5000`
- **Real Device:** `http://192.168.x.x:5000` (IP máy tính)

**Update trong:**
- `lib/services/auth_service.dart`
- `lib/services/api_service.dart`

---

## ✅ Test App Hoạt Động

### 1. Test Backend API

Mở trình duyệt:

```
http://localhost:5000/api/health
```

Phải thấy JSON:
```json
{
  "status": "healthy",
  "timestamp": "...",
  "scheduler_running": true
}
```

### 2. Test Admin Dashboard

```
http://localhost:5000/admin
```

Login:
- Email: `admin@fptguard.com`
- Password: `admin123`

### 3. Test Flutter App

**Trong app, kiểm tra:**

#### Trang Settings
- [ ] Nhập thông tin cá nhân
- [ ] Thay đổi ngôn ngữ
- [ ] Lưu thông tin

#### Trang Contacts
- [ ] Thêm liên hệ khẩn cấp
- [ ] Xóa/sửa liên hệ

#### Trang Water Level
- [ ] Xem danh sách 5 trạm
- [ ] Click vào trạm xem chi tiết
- [ ] Xem biểu đồ

#### Trang Location
- [ ] Xem vị trí hiện tại
- [ ] Chia sẻ vị trí (test email)

#### SOS (Cẩn thận!)
- [ ] Test nút SOS (sẽ gửi email thật!)
- [ ] Hoặc test trong code without gửi email

---

## 🎮 Hot Reload & Hot Restart

Khi đang chạy Flutter app:

- **`r`** - Hot reload (nhanh, giữ state)
- **`R`** - Hot restart (restart app)
- **`q`** - Quit
- **`h`** - Help

---

## 📊 Xem Logs

### Backend Logs

Backend sẽ in logs trực tiếp trong terminal:

```
2026-01-14 10:00:00 - INFO - Scheduler started
2026-01-14 10:00:05 - INFO - Data updated successfully
```

**File logs:**
- `backend-python/logs/api.log`
- `backend-python/logs/scheduler.log`

### Flutter Logs

Flutter sẽ in logs trong terminal khi chạy `flutter run`:

```
I/flutter ( 1234): User logged in: admin@fptguard.com
I/flutter ( 1234): Water level updated: Cần Thơ - 2.45m
```

---

## 🚀 Quick Commands

### Backend

```bash
# Start backend
cd backend-python
python app.py

# Stop backend
Ctrl + C
```

### Flutter

```bash
# Run app (auto-select device)
flutter run

# Run on specific device
flutter run -d windows
flutter run -d chrome
flutter run -d <device-id>

# List devices
flutter devices

# Clean build
flutter clean
flutter pub get

# Stop app
# Press 'q' in terminal hoặc Ctrl + C
```

---

## 🔄 Development Workflow

### Workflow Thông Thường

1. **Sáng:** Start backend
   ```bash
   cd backend-python && python app.py
   ```

2. **Develop:** Run Flutter app
   ```bash
   flutter run
   ```

3. **Code:** Edit code, save → Hot reload tự động (`r`)

4. **Test:** Test features trong app

5. **Tối:** Stop tất cả (Ctrl + C)

### Workflow Với Backend Online

1. **Deploy backend lên Railway** (1 lần)

2. **Update API URL** trong Flutter code (1 lần)

3. **Chỉ chạy Flutter app:**
   ```bash
   flutter run
   ```

4. **Backend chạy 24/7**, không cần start local!

---

## 🎯 Next Steps

### Sau Khi App Chạy OK:

1. **Test tất cả features:**
   - [ ] Registration/Login
   - [ ] Settings
   - [ ] Contacts
   - [ ] Water levels
   - [ ] Location sharing
   - [ ] SOS (cẩn thận!)

2. **Deploy backend:**
   - Đọc: [backend-python/DEPLOYMENT_QUICKSTART.md](backend-python/DEPLOYMENT_QUICKSTART.md)
   - Hoặc: [backend-python/DEPLOYMENT_GUIDE.md](backend-python/DEPLOYMENT_GUIDE.md)

3. **Build app:**
   ```bash
   # Android
   flutter build apk --release
   
   # Windows
   flutter build windows --release
   ```

4. **Share với bạn bè để test!**

---

## 📞 Cần Trợ Giúp?

### Documents

- [GETTING_STARTED.md](GETTING_STARTED.md) - Hướng dẫn chạy app chi tiết
- [ANDROID_EMULATOR_GUIDE.md](ANDROID_EMULATOR_GUIDE.md) - Hướng dẫn Android Emulator
- [backend-python/GETTING_STARTED_BACKEND.md](backend-python/GETTING_STARTED_BACKEND.md) - Backend guide

### Common Issues

Xem phần Troubleshooting ở trên

---

## ✅ Checklist Hoàn Thành

- [ ] Backend chạy thành công
- [ ] Flutter app chạy thành công
- [ ] Kết nối backend-frontend OK
- [ ] Test được settings
- [ ] Test được water levels
- [ ] Test được location
- [ ] Test được contacts
- [ ] App chạy mượt, không crash

---

**🎉 Chúc bạn code vui vẻ!**

**Made with ❤️ by FPT Guard Development Team**
