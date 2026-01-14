# 🔧 Setup Hoàn Chỉnh FPT Guard 2.0 - Từ Đầu

## 📋 Hướng Dẫn Cài Đặt Tất Cả Mọi Thứ

### ⏱️ Tổng thời gian: 30-45 phút

---

## 📦 PHẦN 1: Cài Đặt Phần Mềm Cần Thiết

### 1️⃣ Git (Quản lý code)

**Windows:**
1. Download: https://git-scm.com/download/win
2. Chạy file `.exe` vừa tải
3. Nhấn "Next" hết (dùng settings mặc định)
4. Cài xong, mở Command Prompt và test:
   ```bash
   git --version
   ```
   Phải thấy: `git version 2.x.x`

**Đã có Git?** Skip bước này!

---

### 2️⃣ Python 3.11 hoặc 3.13 (Backend)

**Windows:**
1. Download: https://www.python.org/downloads/
   - Chọn **Python 3.13** hoặc **3.11**
2. **QUAN TRỌNG:** ✅ Check vào **"Add Python to PATH"**
3. Click **"Install Now"**
4. Đợi cài đặt xong
5. Test trong Command Prompt:
   ```bash
   python --version
   ```
   Phải thấy: `Python 3.13.x` hoặc `3.11.x`

   ```bash
   pip --version
   ```
   Phải thấy: `pip 24.x.x`

**Nếu đã có Python khác version:**
```bash
# Gỡ Python cũ trong Control Panel
# Hoặc dùng Python version manager: pyenv
```

---

### 3️⃣ Flutter SDK (Mobile/Desktop App)

**Windows:**

#### Option A: Tự động với Flutter Version Manager (FVM) - Dễ hơn

```bash
# Cài Chocolatey (package manager)
# Mở PowerShell as Administrator
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Cài Flutter
choco install flutter
```

#### Option B: Manual (Khuyến nghị cho control tốt hơn)

1. **Download Flutter:**
   - Link: https://docs.flutter.dev/get-started/install/windows
   - Download file `.zip` (khoảng 1GB)

2. **Extract:**
   - Extract vào `C:\src\flutter`
   - **KHÔNG** extract vào thư mục cần quyền admin (như `Program Files`)

3. **Add to PATH:**
   - Search "Environment Variables" trong Windows
   - Click "Environment Variables"
   - Trong "User variables", tìm "Path"
   - Click "Edit" → "New"
   - Thêm: `C:\src\flutter\bin`
   - Click OK hết

4. **Test:**
   ```bash
   # Mở Command Prompt MỚI
   flutter --version
   ```
   Phải thấy: `Flutter 3.x.x`

5. **Run Flutter Doctor:**
   ```bash
   flutter doctor
   ```
   
   Sẽ check và báo thiếu gì. Tiếp tục bước sau để fix.

---

### 4️⃣ Visual Studio Code (Code Editor)

1. Download: https://code.visualstudio.com/
2. Install (Next hết)
3. Mở VS Code
4. Install Extensions:
   - **Flutter** (by Dart Code)
   - **Dart** (by Dart Code)
   - **Python** (by Microsoft)

---

### 5️⃣ Android Studio (Cho Android development) - Optional

**Nếu muốn chạy trên Android:**

1. Download: https://developer.android.com/studio
2. Install Android Studio
3. Trong Android Studio:
   - Mở **SDK Manager**
   - Install **Android SDK** (mặc định OK)
   - Install **Android SDK Command-line Tools**
4. Chạy:
   ```bash
   flutter doctor --android-licenses
   ```
   Nhấn `y` để accept tất cả licenses

**Chỉ chạy trên Windows Desktop?** Skip bước này!

---

### 6️⃣ Chrome (Web development) - Optional

1. Download: https://www.google.com/chrome/
2. Install
3. Flutter sẽ tự động detect Chrome

**Đã có Chrome?** Skip!

---

## 📥 PHẦN 2: Setup Project FPT Guard

### 1️⃣ Clone Project

```bash
# Di chuyển vào thư mục muốn lưu project
cd Desktop
# Hoặc
cd C:\Projects

# Clone project
git clone https://github.com/your-username/fpt-guard-v2.git

# Vào thư mục project
cd fpt-guard-v2
```

**Nếu chưa có GitHub repo:**
```bash
# Giả sử project đã có sẵn trong E:\fpt-guard-v2
cd E:\fpt-guard-v2
```

---

### 2️⃣ Cài Dependencies Flutter

```bash
# Trong thư mục gốc project (fpt-guard-v2)
flutter pub get
```

**Sẽ tải về:**
- provider
- geolocator
- geocoding
- shake
- mailer
- dio
- sqflite
- intl
- ... và nhiều packages khác

**Output mẫu:**
```
Running "flutter pub get" in fpt-guard-v2...
Resolving dependencies...
Got dependencies!
```

**Nếu gặp lỗi:**
```bash
flutter clean
flutter pub get
```

---

### 3️⃣ Cài Dependencies Python (Backend)

```bash
# Di chuyển vào thư mục backend
cd backend-python

# Cài tất cả dependencies
pip install -r requirements.txt
```

**Sẽ cài:**
- Flask (Web framework)
- Selenium (Web scraping)
- BeautifulSoup4 (HTML parsing)
- Pandas (Data processing)
- APScheduler (Task scheduling)
- ... và nhiều packages khác

**Thời gian:** 2-5 phút

**Output mẫu:**
```
Collecting flask==3.1.0
Downloading flask-3.1.0-py3-none-any.whl
...
Successfully installed flask-3.1.0 ...
```

**Nếu gặp lỗi:**
```bash
# Upgrade pip
python -m pip install --upgrade pip

# Thử lại
pip install -r requirements.txt
```

---

### 4️⃣ Setup Chrome/Chromium cho Selenium

Backend cần Chrome để scrape dữ liệu từ MRC.

**Windows:**

Chrome sẽ tự động được detect. Nếu chưa có:
```bash
# Option 1: Tải Chrome
https://www.google.com/chrome/

# Option 2: Dùng Edge (đã có sẵn Windows)
# Backend sẽ tự động dùng Edge nếu không có Chrome
```

**ChromeDriver sẽ tự động download** khi chạy backend lần đầu!

---

## ⚙️ PHẦN 3: Cấu Hình

### 1️⃣ Tạo File .env (Optional - cho email)

```bash
# Trong thư mục gốc project
# Tạo file .env
```

**File `.env`:**
```env
# Email Configuration (Gmail)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password

# API Configuration
API_BASE_URL=http://localhost:5000
```

**Lấy App Password (Gmail):**
1. Vào: https://myaccount.google.com/security
2. Bật **2-Step Verification**
3. Vào **App passwords**
4. Tạo password cho "Mail"
5. Copy password vào `.env`

**Chưa muốn setup email?** Skip, app vẫn chạy được!

---

### 2️⃣ Check API URL trong Flutter

**File: `lib/services/auth_service.dart`**

Mở và kiểm tra:
```dart
// Cho local development
static const String baseUrl = 'http://localhost:5000';

// Nếu chạy Android Emulator, đổi thành:
// static const String baseUrl = 'http://10.0.2.2:5000';

// Nếu đã deploy backend, đổi thành:
// static const String baseUrl = 'https://your-app.railway.app';
```

**File: `lib/services/api_service.dart`**

Kiểm tra tương tự.

**Đang chạy trên Windows Desktop?** Giữ `http://localhost:5000`

---

## ✅ PHẦN 4: Kiểm Tra Setup

### 1️⃣ Flutter Doctor

```bash
flutter doctor
```

**Kết quả mong muốn:**
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.x.x)
[✓] Windows Version (Installed version of Windows is version 10 or higher)
[✓] Visual Studio Code (version 1.x.x)
[✓] Connected device (3 available)
[✓] Network resources

! Doctor found issues in 1 category.
```

**Các issues thường gặp:**

- **Android toolchain** ❌ → OK nếu chỉ chạy Windows/Web
- **Xcode** ❌ → OK nếu không làm iOS (chỉ có Mac mới có)
- **Chrome** ✅ → Cần có
- **Visual Studio** ❌ → Có thể cần cho Windows desktop

**Fix Visual Studio (Windows Desktop):**
```bash
# Nếu cần build Windows desktop app
# Download Visual Studio 2022 Community
https://visualstudio.microsoft.com/downloads/

# Khi install, chọn:
- Desktop development with C++
```

---

### 2️⃣ Test Python & Pip

```bash
python --version
pip --version
```

**Phải thấy:**
```
Python 3.13.x (hoặc 3.11.x)
pip 24.x.x
```

---

### 3️⃣ Test Dependencies

**Flutter:**
```bash
flutter pub get
```
Phải thấy: `Got dependencies!`

**Python:**
```bash
cd backend-python
pip list | findstr flask
```
Phải thấy: `Flask  3.1.0`

---

### 4️⃣ Test Flutter Devices

```bash
flutter devices
```

**Phải thấy ít nhất 1 device:**
```
3 connected devices:

Windows (desktop) • windows • windows-x64    • Microsoft Windows
Chrome (web)      • chrome  • web-javascript • Google Chrome
Edge (web)        • edge    • web-javascript • Microsoft Edge
```

**Không thấy device nào?**
- Kiểm tra Chrome đã cài chưa
- Restart Command Prompt

---

## 🚀 PHẦN 5: Chạy App Lần Đầu

### 1️⃣ Start Backend

```bash
# Terminal #1
cd backend-python
python app.py
```

**Chờ đến khi thấy:**
```
======================================================================
MEKONG RIVER WATER LEVEL MONITORING - API SERVER
======================================================================

Khởi động scheduler...
Khởi động Flask API server...
  → Host: 0.0.0.0
  → Port: 5000
  → API URL: http://localhost:5000
  → Debug mode: True
```

✅ **Backend đã chạy!**

**Test:** Mở browser → http://localhost:5000

---

### 2️⃣ Start Flutter App

```bash
# Terminal #2 (mở terminal mới)
# Ở thư mục gốc project (KHÔNG phải backend-python)
cd E:\fpt-guard-v2

flutter run -d windows
```

**Lần đầu sẽ lâu (3-5 phút) vì phải build.**

**Chờ đến khi thấy:**
```
✓ Built build\windows\runner\Release\fpt_guard_v2.exe
Launching lib\main.dart on Windows in debug mode...
```

✅ **App sẽ tự động mở!**

---

## 🎯 PHẦN 6: Verify Everything Works

### ✅ Checklist

#### Backend
- [ ] Backend chạy tại http://localhost:5000
- [ ] Admin dashboard: http://localhost:5000/admin
  - Login: `admin@fptguard.com` / `admin123`
- [ ] API health: http://localhost:5000/api/health
- [ ] Thấy logs cập nhật dữ liệu

#### Flutter App
- [ ] App mở thành công
- [ ] Không có error đỏ
- [ ] Thấy splash screen
- [ ] Thấy home screen

#### Tính Năng
- [ ] Settings → Nhập thông tin OK
- [ ] Settings → Đổi ngôn ngữ OK
- [ ] Contacts → Thêm contact OK
- [ ] Water Level → Xem trạm OK
- [ ] Location → Thấy vị trí OK

---

## 🔧 Troubleshooting

### ❌ Problem: `flutter` không được nhận diện

**Solution:**
```bash
# 1. Check PATH
echo $env:Path

# 2. Thêm Flutter vào PATH
# Environment Variables → Path → New → C:\src\flutter\bin

# 3. Restart Command Prompt

# 4. Test lại
flutter --version
```

---

### ❌ Problem: `python` không được nhận diện

**Solution:**
```bash
# 1. Reinstall Python
# Nhớ check "Add Python to PATH"

# 2. Hoặc add manual
# Environment Variables → Path → New → C:\Users\YourName\AppData\Local\Programs\Python\Python313

# 3. Restart Command Prompt
```

---

### ❌ Problem: Flutter pub get fails

**Solution:**
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

---

### ❌ Problem: Pip install fails

**Solution:**
```bash
# Upgrade pip
python -m pip install --upgrade pip

# Clear cache
pip cache purge

# Try again
pip install -r requirements.txt

# Nếu vẫn lỗi, install từng package:
pip install flask
pip install selenium
pip install beautifulsoup4
# ... etc
```

---

### ❌ Problem: Port 5000 đã được dùng

**Solution Windows:**
```bash
# Tìm process
netstat -ano | findstr :5000

# Kill process (thay PID)
taskkill /PID <PID> /F
```

---

### ❌ Problem: Chrome/Selenium error

**Solution:**
```bash
# Backend sẽ tự download ChromeDriver
# Nếu lỗi, install Chrome:
https://www.google.com/chrome/

# Hoặc dùng Edge (Windows có sẵn)
```

---

### ❌ Problem: Flutter build Windows error

**Solution:**
```bash
# Cần Visual Studio 2022
https://visualstudio.microsoft.com/downloads/

# Install với workload:
# - Desktop development with C++

# Sau đó:
flutter doctor
flutter clean
flutter run -d windows
```

---

### ❌ Problem: Module not found (Python)

**Solution:**
```bash
cd backend-python
pip install -r requirements.txt

# Hoặc install specific:
pip install flask flask-cors selenium beautifulsoup4 pandas
```

---

## 📚 PHẦN 7: Next Steps

### 🎓 Học Cách Sử Dụng

**Đọc:**
- [RUN_APP.md](RUN_APP.md) - Hướng dẫn chạy app hàng ngày
- [GETTING_STARTED.md](GETTING_STARTED.md) - Hướng dẫn chi tiết features

---

### 🚀 Deploy Backend 24/7

**Khi sẵn sàng deploy:**
- [backend-python/DEPLOYMENT_QUICKSTART.md](backend-python/DEPLOYMENT_QUICKSTART.md) - 5 phút
- [backend-python/DEPLOYMENT_GUIDE.md](backend-python/DEPLOYMENT_GUIDE.md) - Đầy đủ

**Platforms:**
- Railway (Free $5/tháng) - Khuyến nghị
- Render (Free tier)
- VPS (DigitalOcean) - $6/tháng

---

### 📱 Build App để Share

```bash
# Windows
flutter build windows --release

# Android
flutter build apk --release

# File sẽ ở:
# build\windows\runner\Release\
# build\app\outputs\flutter-apk\
```

---

## 💾 Tổng Kết Các Commands Quan Trọng

### Setup (1 lần)
```bash
# Flutter
flutter pub get

# Python
cd backend-python
pip install -r requirements.txt
```

### Chạy App (mỗi ngày)
```bash
# Terminal 1: Backend
cd backend-python
python app.py

# Terminal 2: Flutter
flutter run -d windows
```

### Clean (khi lỗi)
```bash
# Flutter
flutter clean
flutter pub get

# Python
pip cache purge
pip install -r requirements.txt
```

### Update
```bash
# Flutter
flutter upgrade
flutter pub upgrade

# Python packages
pip install --upgrade -r requirements.txt
```

---

## 📊 Checklist Hoàn Thành Setup

### Phần Mềm
- [ ] Git installed & working
- [ ] Python 3.11+ installed & in PATH
- [ ] Flutter SDK installed & in PATH
- [ ] VS Code installed với extensions
- [ ] Chrome installed (hoặc Edge)
- [ ] Android Studio (nếu cần Android)

### Dependencies
- [ ] Flutter packages: `flutter pub get` OK
- [ ] Python packages: `pip install -r requirements.txt` OK
- [ ] ChromeDriver auto-downloaded

### Configuration
- [ ] `.env` file created (optional)
- [ ] API URLs checked trong Flutter code

### Verification
- [ ] `flutter doctor` mostly green
- [ ] `python --version` works
- [ ] `flutter devices` shows devices
- [ ] Backend chạy OK (port 5000)
- [ ] Flutter app chạy OK

### Testing
- [ ] Admin dashboard accessible
- [ ] API endpoints working
- [ ] Flutter app opens
- [ ] All features tested

---

## 🎉 Hoàn Thành!

**Bạn đã setup xong tất cả mọi thứ!**

**Giờ có thể:**
- ✅ Chạy backend local
- ✅ Chạy Flutter app
- ✅ Develop features mới
- ✅ Test app
- ✅ Deploy khi sẵn sàng

---

## 📞 Cần Trợ Giúp?

### Documents
- [RUN_APP.md](RUN_APP.md) - Chạy app hàng ngày
- [GETTING_STARTED.md](GETTING_STARTED.md) - Getting started guide
- [backend-python/DOCS_INDEX.md](backend-python/DOCS_INDEX.md) - Backend docs

### Resources
- Flutter Docs: https://docs.flutter.dev
- Python Docs: https://docs.python.org
- VS Code: https://code.visualstudio.com/docs

---

**⏱️ Tổng thời gian setup:** 30-45 phút

**💪 Chúc bạn code thành công!**

**Made with ❤️ by FPT Guard Development Team**
