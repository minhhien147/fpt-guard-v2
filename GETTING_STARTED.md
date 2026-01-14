# 🚀 Hướng Dẫn Chạy Ứng Dụng FPT Guard 2.0

> Hướng dẫn chi tiết từng bước để chạy ứng dụng FPT Guard 2.0 trên máy của bạn

---

## ⚡ Quick Start (5 phút)

Nếu bạn đã có Flutter và Python, chạy nhanh:

```bash
# 1. Clone project
git clone https://github.com/your-username/fpt-guard-v2.git
cd fpt-guard-v2

# 2. Tạo file .env (thay your-email và your-app-password)
echo "SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password
API_BASE_URL=http://localhost:5000" > .env

# 3. Chạy Backend (Terminal 1)
cd backend-python
python -m venv venv
source venv/bin/activate  # Windows: .\venv\Scripts\Activate.ps1
pip install -r requirements.txt
python app.py

# 4. Chạy App (Terminal 2 - mở terminal mới)
cd ..
flutter pub get
flutter gen-l10n
flutter run
```

**Nếu gặp lỗi**, đọc hướng dẫn chi tiết bên dưới. ⬇️

---

## 📑 Mục lục

1. [Yêu cầu hệ thống](#-yêu-cầu-hệ-thống)
2. [Cài đặt Flutter](#-cài-đặt-flutter)
3. [Cài đặt Python Backend](#-cài-đặt-python-backend)
4. [Cấu hình ứng dụng](#-cấu-hình-ứng-dụng)
5. [Chạy Backend Server](#-chạy-backend-server)
6. [Chạy Mobile App](#-chạy-mobile-app)
7. **[📱 Hướng dẫn chi tiết Android Emulator](ANDROID_EMULATOR_GUIDE.md)** ⭐
8. [Giải quyết lỗi thường gặp](#-giải-quyết-lỗi-thường-gặp)
9. [Video hướng dẫn](#-video-hướng-dẫn)

---

## 📋 Yêu cầu hệ thống

### Cho Mobile App (Flutter)

- **Hệ điều hành**: Windows 10/11, macOS 10.14+, hoặc Linux
- **RAM**: Tối thiểu 8GB (khuyên dùng 16GB)
- **Dung lượng**: ~5GB trống
- **Internet**: Để tải packages

### Cho Backend Server (Python)

- **Python**: Version 3.13 trở lên
- **RAM**: Tối thiểu 2GB
- **Dung lượng**: ~500MB trống

### Cho thiết bị test

- **Android**: Version 5.0 (Lollipop) trở lên
- **iOS**: Version 12.0 trở lên
- Hoặc **Android Emulator / iOS Simulator**

---

## 🛠️ Cài đặt Flutter

### Windows

#### Bước 1: Tải Flutter SDK

```powershell
# 1. Tải Flutter SDK từ trang chính thức
# Truy cập: https://docs.flutter.dev/get-started/install/windows

# 2. Giải nén vào thư mục (ví dụ: C:\src\flutter)
```

#### Bước 2: Thêm Flutter vào PATH

```powershell
# 1. Mở "Edit the system environment variables"
# 2. Click "Environment Variables"
# 3. Trong "User variables", chọn "Path" và click "Edit"
# 4. Click "New" và thêm: C:\src\flutter\bin
# 5. Click "OK" để lưu
```

#### Bước 3: Cài đặt Android Studio

```powershell
# 1. Tải và cài đặt Android Studio từ:
# https://developer.android.com/studio

# 2. Mở Android Studio
# 3. Vào Tools > SDK Manager
# 4. Cài đặt:
#    - Android SDK Platform (API 33 trở lên)
#    - Android SDK Build-Tools
#    - Android SDK Platform-Tools
#    - Android SDK Tools

# 5. Vào Tools > AVD Manager
# 6. Tạo một Virtual Device (Android emulator)
```

#### Bước 4: Kiểm tra cài đặt

```powershell
# Mở Command Prompt hoặc PowerShell
flutter doctor
```

Kết quả mong muốn:
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.x.x)
[✓] Android toolchain - develop for Android devices
[✓] Chrome - develop for the web
[✓] Android Studio (version 2023.x)
[✓] VS Code (version 1.x.x)
[✓] Connected device (x available)
```

### macOS

```bash
# 1. Cài đặt Homebrew (nếu chưa có)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Cài đặt Flutter
brew install --cask flutter

# 3. Thêm Flutter vào PATH
echo 'export PATH="$PATH:/usr/local/Caskroom/flutter/bin"' >> ~/.zshrc
source ~/.zshrc

# 4. Kiểm tra
flutter doctor
```

### Linux (Ubuntu/Debian)

```bash
# 1. Cài đặt dependencies
sudo apt update
sudo apt install -y curl git unzip xz-utils zip libglu1-mesa

# 2. Tải Flutter
cd ~
git clone https://github.com/flutter/flutter.git -b stable

# 3. Thêm Flutter vào PATH
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# 4. Kiểm tra
flutter doctor
```

---

## 🐍 Cài đặt Python Backend

### Windows

#### Bước 1: Cài đặt Python

```powershell
# 1. Tải Python 3.13+ từ: https://www.python.org/downloads/
# 2. Chạy installer
# 3. ✅ Tick "Add Python to PATH"
# 4. Click "Install Now"

# 5. Kiểm tra cài đặt
python --version
pip --version
```

#### Bước 2: Cài đặt Chrome/Chromium (cho Web Scraping)

```powershell
# Tải và cài đặt Google Chrome từ:
# https://www.google.com/chrome/
```

### macOS

```bash
# 1. Cài đặt Python qua Homebrew
brew install python@3.13

# 2. Kiểm tra
python3 --version
pip3 --version

# 3. Cài đặt Chrome
brew install --cask google-chrome
```

### Linux

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y python3.13 python3-pip
sudo apt install -y chromium-browser

# Kiểm tra
python3 --version
pip3 --version
```

---

## ⚙️ Cấu hình ứng dụng

### Bước 1: Clone Repository

```bash
# Clone project từ GitHub
git clone https://github.com/your-username/fpt-guard-v2.git
cd fpt-guard-v2
```

### Bước 2: Tạo file .env

#### Windows (PowerShell):
```powershell
# Tạo file .env trong thư mục root
New-Item -Path . -Name ".env" -ItemType "file"
notepad .env
```

#### macOS/Linux:
```bash
# Tạo file .env
touch .env
nano .env
# hoặc
code .env
```

#### Nội dung file .env:

```env
# ==================================
# EMAIL CONFIGURATION
# ==================================
# SMTP Server (Gmail)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587

# Email của bạn (để gửi SOS alerts)
SMTP_USER=your-email@gmail.com

# App Password (KHÔNG phải password thường)
# Cách lấy: https://support.google.com/accounts/answer/185833
SMTP_PASSWORD=xxxx-xxxx-xxxx-xxxx

# ==================================
# API CONFIGURATION
# ==================================
# URL của Backend Server (local development)
API_BASE_URL=http://localhost:5000

# Nếu chạy trên thiết bị thật, dùng IP máy:
# API_BASE_URL=http://192.168.1.xxx:5000
```

### Bước 3: Lấy App Password từ Gmail

1. Truy cập: https://myaccount.google.com/security
2. Bật **2-Step Verification** (nếu chưa bật)
3. Tìm **App passwords**
4. Chọn app: **Mail**
5. Chọn device: **Windows Computer** (hoặc thiết bị của bạn)
6. Click **Generate**
7. Copy password (dạng: `xxxx xxxx xxxx xxxx`)
8. Paste vào file `.env` (bỏ dấu cách)

---

## 🚀 Chạy Backend Server

### Bước 1: Di chuyển vào thư mục backend

```bash
cd backend-python
```

### Bước 2: Tạo Virtual Environment

#### Windows (PowerShell):
```powershell
# Tạo virtual environment
python -m venv venv

# Kích hoạt
.\venv\Scripts\Activate.ps1

# Nếu gặp lỗi execution policy:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### macOS/Linux:
```bash
# Tạo virtual environment
python3 -m venv venv

# Kích hoạt
source venv/bin/activate
```

### Bước 3: Cài đặt Dependencies

```bash
# Cài đặt tất cả packages
pip install -r requirements.txt

# Nếu gặp lỗi, update pip trước:
pip install --upgrade pip
pip install -r requirements.txt
```

### Bước 4: Chạy Server

```bash
# Chạy Flask server
python app.py
```

**Kết quả mong muốn:**
```
 * Serving Flask app 'app'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment.
 * Running on http://127.0.0.1:5000
Press CTRL+C to quit
 * Restarting with stat
 * Debugger is active!
```

### Bước 5: Kiểm tra Backend hoạt động

Mở trình duyệt và truy cập:
```
http://localhost:5000/api/water-levels/latest
```

Bạn sẽ thấy dữ liệu JSON trả về:
```json
{
  "success": true,
  "data": [...],
  "updated_at": "2026-01-10T08:00:00Z"
}
```

✅ **Backend đã chạy thành công!**

---

## 📱 Chạy Mobile App

### Bước 1: Mở terminal mới (để Backend vẫn chạy)

**Quan trọng**: Giữ terminal Backend đang chạy, mở terminal mới cho Flutter

### Bước 2: Di chuyển về thư mục root

```bash
# Từ backend-python, quay về root
cd ..
```

### Bước 3: Cài đặt Flutter Dependencies

```bash
# Tải tất cả packages
flutter pub get

# Tạo localization files
flutter gen-l10n
```

### Bước 4: Khởi động Emulator/Simulator

> 💡 **Cần hướng dẫn chi tiết về Android Emulator?** Xem [ANDROID_EMULATOR_GUIDE.md](ANDROID_EMULATOR_GUIDE.md)

#### Sử dụng Android Emulator:

```bash
# Liệt kê các emulator có sẵn
flutter emulators

# Khởi động emulator
flutter emulators --launch <emulator_id>

# Hoặc mở Android Studio > AVD Manager > Click ▶️ Play
```

#### Sử dụng iOS Simulator (macOS):

```bash
# Khởi động simulator
open -a Simulator
```

#### Sử dụng thiết bị thật:

**Android:**
1. Bật **Developer Options** trên điện thoại:
   - Vào Settings > About Phone
   - Tap "Build Number" 7 lần
2. Bật **USB Debugging**
3. Kết nối USB với máy tính
4. Cho phép "Allow USB debugging"

**iOS:**
1. Kết nối iPhone với Mac
2. Mở Xcode
3. Vào Window > Devices and Simulators
4. Trust thiết bị

### Bước 5: Kiểm tra thiết bị

```bash
# Liệt kê tất cả thiết bị đang kết nối
flutter devices
```

Kết quả mẫu:
```
4 connected devices:

sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64    • Android 13 (API 33)
iPhone 14 Pro Max (mobile)   • ios-simulator  • ios            • iOS 16.2
Chrome (web)                 • chrome         • web-javascript • Google Chrome 120.0
```

### Bước 6: Cập nhật API_BASE_URL (nếu dùng thiết bị thật)

Nếu chạy trên **thiết bị thật** (không phải emulator), cần sửa file `.env`:

```bash
# 1. Tìm IP máy tính của bạn

# Windows (PowerShell):
ipconfig
# Tìm IPv4 Address (ví dụ: 192.168.1.5)

# macOS/Linux:
ifconfig | grep inet
# hoặc
ip addr show
```

```env
# Sửa trong file .env
API_BASE_URL=http://192.168.1.5:5000
```

**Lưu ý**: Máy tính và điện thoại phải cùng mạng WiFi!

### Bước 7: Chạy ứng dụng

```bash
# Chạy ứng dụng (tự động chọn thiết bị nếu chỉ có 1)
flutter run

# Hoặc chọn thiết bị cụ thể
flutter run -d <device_id>

# Chạy ở release mode (nhanh hơn)
flutter run --release
```

**Quá trình build lần đầu** sẽ mất 5-10 phút. Các lần sau sẽ nhanh hơn.

### Bước 8: Hot Reload

Khi app đã chạy, bạn có thể:
- Nhấn `r` để **reload** (nhanh)
- Nhấn `R` để **restart** (xóa state)
- Nhấn `q` để **quit**

---

## ✅ Kiểm tra ứng dụng hoạt động

### 1. Màn hình Splash
- Ứng dụng mở ra với logo FPT Guard
- Tự động chuyển sang màn hình Home

### 2. Màn hình Home
- Hiển thị "Xin chào" (hoặc ngôn ngữ bạn chọn)
- Hiển thị vị trí hiện tại (sau khi cho phép GPS)
- Nút SOS màu đỏ ở giữa
- Các nút gọi nhanh: 113, 115, 114

### 3. Test chức năng GPS
1. Khi ứng dụng yêu cầu quyền Location
2. Chọn **Allow** hoặc **While using the app**
3. Vị trí hiện tại sẽ hiển thị trong vài giây

### 4. Test Backend Connection
1. Vào màn hình **Mực nước Sông Mekong**
2. Nếu thấy dữ liệu 5 trạm → ✅ Backend đã kết nối
3. Nếu báo lỗi → Kiểm tra Backend có đang chạy không

### 5. Test đa ngôn ngữ
1. Vào **Settings (Cài đặt)**
2. Nhấn vào **Language (Ngôn ngữ)**
3. Chọn **English** hoặc **日本語**
4. Giao diện tự động chuyển ngôn ngữ

---

## 🔧 Giải quyết lỗi thường gặp

### Lỗi 1: Flutter Doctor báo lỗi

```bash
flutter doctor
```

**Giải pháp:**
```bash
# Nếu thiếu Android licenses:
flutter doctor --android-licenses

# Nếu thiếu cmdline-tools:
# Vào Android Studio > SDK Manager > SDK Tools
# ✅ Tick "Android SDK Command-line Tools"
# Click Apply
```

### Lỗi 2: Không tìm thấy thiết bị

```bash
flutter devices
# No devices detected
```

**Giải pháp:**

**Android:**
```bash
# Kiểm tra ADB
adb devices

# Nếu không có, restart ADB
adb kill-server
adb start-server
```

**iOS:**
```bash
# Restart simulator
killall Simulator
open -a Simulator
```

### Lỗi 3: Lỗi build Gradle (Android)

```
FAILURE: Build failed with an exception.
```

**Giải pháp:**
```bash
# Xóa cache và rebuild
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Lỗi 4: Backend không kết nối được

```
Failed to load data: Connection refused
```

**Giải pháp:**

1. **Kiểm tra Backend đang chạy:**
   ```bash
   # Trong terminal backend
   # Phải thấy: Running on http://127.0.0.1:5000
   ```

2. **Kiểm tra URL trong .env:**
   ```env
   # Emulator:
   API_BASE_URL=http://localhost:5000
   
   # Thiết bị thật:
   API_BASE_URL=http://192.168.1.xxx:5000
   ```

3. **Test Backend bằng browser:**
   ```
   http://localhost:5000/api/water-levels/latest
   ```

4. **Kiểm tra Firewall:**
   - Windows: Allow Python trong Firewall
   - macOS: System Preferences > Security > Firewall

### Lỗi 5: Không gửi được email SOS

```
Error sending email
```

**Giải pháp:**

1. **Kiểm tra App Password:**
   - Đảm bảo dùng App Password, không phải password thường
   - Format: `xxxx xxxx xxxx xxxx` (không có dấu cách trong .env)

2. **Kiểm tra 2-Step Verification:**
   - Phải bật 2-Step Verification trên Gmail

3. **Test gửi email thủ công:**
   ```python
   # Tạo file test_email.py
   import smtenv
   from email.mime.text import MIMEText
   
   msg = MIMEText("Test")
   msg['Subject'] = 'Test Email'
   msg['From'] = 'your-email@gmail.com'
   msg['To'] = 'recipient@gmail.com'
   
   with smtplib.SMTP('smtp.gmail.com', 587) as server:
       server.starttls()
       server.login('your-email@gmail.com', 'your-app-password')
       server.send_message(msg)
   
   print("Email sent!")
   ```

### Lỗi 6: Lỗi localization

```
Error: Could not find package 'flutter_gen' in lib/l10n
```

**Giải pháp:**
```bash
# Tạo lại localization files
flutter gen-l10n

# Nếu vẫn lỗi
flutter clean
flutter pub get
flutter gen-l10n
```

### Lỗi 7: Permission denied (GPS/Camera)

**Giải pháp:**

**Android:**
```bash
# Vào Settings trên điện thoại/emulator
# Apps > FPT Guard > Permissions
# Bật tất cả permissions
```

**iOS:**
```bash
# Vào Settings > FPT Guard
# Bật Location, Camera, Photos
```

### Lỗi 8: Python packages không cài được

```bash
pip install -r requirements.txt
# ERROR: Could not install...
```

**Giải pháp:**
```bash
# Update pip
pip install --upgrade pip

# Cài từng package
pip install selenium
pip install flask
pip install pandas
# ...

# Nếu vẫn lỗi, dùng Python 3.11:
python3.11 -m venv venv
```

---

## 📱 Chạy trên thiết bị thật (Chi tiết)

### Android

#### Bước 1: Bật Developer Mode
1. Mở **Settings** trên điện thoại
2. Vào **About Phone**
3. Tìm **Build Number**
4. **Tap 7 lần** vào Build Number
5. Nhập mật khẩu (nếu có)
6. Thông báo: "You are now a developer!"

#### Bước 2: Bật USB Debugging
1. Quay lại **Settings**
2. Vào **System** > **Developer Options**
3. Bật **Developer Options** (toggle lên ON)
4. Bật **USB Debugging**
5. Bật **Install via USB** (nếu có)

#### Bước 3: Kết nối với máy tính
1. Dùng cáp USB kết nối điện thoại với máy tính
2. Trên điện thoại, chọn **File Transfer** hoặc **MTP**
3. Popup xuất hiện: "Allow USB debugging?"
4. ✅ Tick "Always allow from this computer"
5. Click **OK**

#### Bước 4: Kiểm tra kết nối
```bash
# Kiểm tra thiết bị
adb devices

# Kết quả mong đợi:
# List of devices attached
# 1234567890ABCDEF    device
```

#### Bước 5: Chạy app
```bash
flutter run -d <device_id>
```

### iOS (chỉ macOS)

#### Bước 1: Cài đặt Xcode
```bash
# Cài từ App Store hoặc
xcode-select --install
```

#### Bước 2: Đăng ký Apple Developer Account
1. Mở Xcode
2. Vào **Preferences** > **Accounts**
3. Click **+** > **Apple ID**
4. Đăng nhập với Apple ID (miễn phí)

#### Bước 3: Cấu hình Signing
1. Mở project Flutter: `open ios/Runner.xcworkspace`
2. Chọn **Runner** trong project navigator
3. Chọn tab **Signing & Capabilities**
4. ✅ Tick **Automatically manage signing**
5. Chọn **Team** (Apple ID của bạn)
6. Thay đổi **Bundle Identifier** (unique):
   ```
   com.yourname.fptguardv2
   ```

#### Bước 4: Kết nối iPhone
1. Kết nối iPhone với Mac bằng cáp Lightning
2. Trên iPhone: Tin cậy máy tính này
3. Nhập passcode iPhone

#### Bước 5: Trust Developer
1. Chạy app lần đầu: `flutter run`
2. Trên iPhone: Vào **Settings** > **General** > **VPN & Device Management**
3. Chọn Apple ID của bạn
4. Click **Trust**

---

## 🎥 Video hướng dẫn

### Hướng dẫn cài đặt Flutter

- **Windows**: https://www.youtube.com/watch?v=example1
- **macOS**: https://www.youtube.com/watch?v=example2
- **Linux**: https://www.youtube.com/watch?v=example3

### Hướng dẫn chạy project

- **Phần 1 - Backend**: https://www.youtube.com/watch?v=example4
- **Phần 2 - Frontend**: https://www.youtube.com/watch?v=example5
- **Phần 3 - Testing**: https://www.youtube.com/watch?v=example6

---

## 🎯 Checklist hoàn thành

Dùng checklist này để đảm bảo bạn đã làm đủ các bước:

### Cài đặt môi trường
- [ ] Đã cài Flutter SDK và `flutter doctor` pass
- [ ] Đã cài Python 3.13+ và kiểm tra `python --version`
- [ ] Đã cài Android Studio (hoặc Xcode cho macOS)
- [ ] Đã tạo và khởi động emulator/simulator

### Cấu hình project
- [ ] Đã clone repository
- [ ] Đã tạo file `.env` với đầy đủ thông tin
- [ ] Đã lấy App Password từ Gmail
- [ ] Đã cài đặt dependencies: `flutter pub get`
- [ ] Đã tạo localization: `flutter gen-l10n`

### Backend
- [ ] Đã tạo virtual environment Python
- [ ] Đã cài đặt requirements: `pip install -r requirements.txt`
- [ ] Backend đang chạy ở `http://localhost:5000`
- [ ] Có thể truy cập API qua browser

### Mobile App
- [ ] `flutter devices` hiển thị thiết bị
- [ ] Đã chạy `flutter run` thành công
- [ ] App mở được trên thiết bị/emulator
- [ ] GPS hoạt động (hiển thị vị trí)
- [ ] Backend kết nối được (xem mực nước)
- [ ] Đa ngôn ngữ hoạt động (đổi trong Settings)

---

## 💡 Tips & Tricks

### 1. Hot Reload nhanh hơn

```dart
// Trong code, dùng const khi có thể
const Text('Hello')  // ✅ Tốt
Text('Hello')        // ❌ Chậm hơn
```

### 2. Chạy nhiều emulator cùng lúc

```bash
# Terminal 1
flutter run -d emulator-5554

# Terminal 2
flutter run -d emulator-5556
```

### 3. Debug nhanh

```bash
# Xem logs realtime
flutter logs

# Debug trong VS Code
# F5 hoặc Run > Start Debugging
```

### 4. Build APK để test

```bash
# Build APK (nhanh hơn)
flutter build apk --debug

# File APK ở: build/app/outputs/flutter-apk/app-debug.apk
# Copy sang điện thoại và cài đặt
```

### 5. Làm việc offline

```bash
# Sau khi đã tải packages
flutter pub get --offline
```

---

## 📞 Hỗ trợ

Nếu gặp vấn đề không giải quyết được:

1. **Tìm trong Issues**: [GitHub Issues](https://github.com/your-username/fpt-guard-v2/issues)
2. **Tạo Issue mới**: Mô tả chi tiết lỗi + screenshots
3. **Email**: support@fptguard.com
4. **Discord**: [FPT Guard Community](https://discord.gg/fptguard)

---

## 🎉 Chúc mừng!

Nếu đã hoàn thành tất cả các bước, bạn đã chạy thành công FPT Guard 2.0! 🎊

**Bước tiếp theo:**
- Thử tất cả tính năng
- Đọc [API Documentation](README.md#-api-documentation)
- Đóng góp code: [CONTRIBUTING.md](CONTRIBUTING.md)
- Báo lỗi: [GitHub Issues](https://github.com/your-username/fpt-guard-v2/issues)

---

<div align="center">

**Made with ❤️ by FPT University Can Tho**

[⬆ Back to top](#-hướng-dẫn-chạy-ứng-dụng-fpt-guard-20)

</div>
