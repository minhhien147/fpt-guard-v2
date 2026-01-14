# FPT Guard 2.0 🛡️

<div align="center">

![FPT Guard Logo](assets/images/app_icon.jpg)

**Ứng dụng Bảo vệ Sinh viên FPT University Cần Thơ**

*An toàn mọi lúc, mọi nơi*

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Python](https://img.shields.io/badge/Python-3.13-3776AB?logo=python)](https://python.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[🚀 Hướng dẫn chạy App](GETTING_STARTED.md) | [📱 Android Emulator](ANDROID_EMULATOR_GUIDE.md) | [English](#english) | [日本語](#japanese)

</div>

---

## 📋 Mục lục

- **[🚀 Hướng dẫn chạy App chi tiết](GETTING_STARTED.md)** ⭐
- [Giới thiệu](#-giới-thiệu)
- [Tính năng chính](#-tính-năng-chính)
- [Kiến trúc hệ thống](#-kiến-trúc-hệ-thống)
- [Công nghệ sử dụng](#-công-nghệ-sử-dụng)
- [Cài đặt](#-cài-đặt)
- [Sử dụng](#-sử-dụng)
- [Đa ngôn ngữ](#-đa-ngôn-ngữ)
- [API Documentation](#-api-documentation)
- [Cấu trúc thư mục](#-cấu-trúc-thư-mục)
- [Đóng góp](#-đóng-góp)
- [License](#-license)

---

## 🌟 Giới thiệu

**FPT Guard 2.0** là ứng dụng mobile được phát triển để đảm bảo an toàn cho sinh viên FPT University Cần Thơ, đặc biệt trong các tình huống khẩn cấp và thiên tai. Ứng dụng tích hợp nhiều tính năng thông minh như:

- 🚨 **Cảnh báo SOS khẩn cấp** với phát hiện rung lắc tự động
- 🌊 **Giám sát mực nước sông Mekong** theo thời gian thực
- 📍 **Chia sẻ vị trí** với người thân và bạn bè
- 📞 **Gọi nhanh** đến các đầu mối khẩn cấp
- 🌐 **Đa ngôn ngữ**: Tiếng Việt, English, 日本語

---

## ✨ Tính năng chính

### 1. 🚨 Hệ thống SOS khẩn cấp

- **Nút SOS nổi bật**: Gửi cảnh báo khẩn cấp ngay lập tức
- **Phát hiện rung lắc**: Tự động gửi SOS khi phát hiện rung lắc mạnh (shake detection)
- **Gửi email tự động**: Thông báo đến email khẩn cấp đã đăng ký kèm vị trí GPS
- **Đính kèm hình ảnh**: Có thể chụp ảnh hiện trường (tùy chọn)
- **Lưu lịch sử**: Theo dõi tất cả các lần gửi SOS

### 2. 🌊 Giám sát mực nước sông Mekong

- **5 trạm đo ĐBSCL**: Tân Châu, Châu Đốc, Cần Thơ, Vĩnh Long, Mỹ Thuận
- **Cập nhật tự động**: Dữ liệu được cập nhật định kỳ từ MRC (Mekong River Commission)
- **Biểu đồ trực quan**: Xem xu hướng mực nước theo thời gian
- **Cảnh báo nguy hiểm**: Màu sắc thể hiện mức độ an toàn (xanh/vàng/đỏ)
- **Dữ liệu lịch sử**: Tra cứu mực nước các ngày trước

### 3. 📍 Quản lý vị trí

- **Theo dõi GPS**: Hiển thị vị trí hiện tại trên bản đồ
- **Địa chỉ chi tiết**: Chuyển đổi tọa độ sang địa chỉ đường phố
- **Chia sẻ vị trí**: Gửi vị trí qua email cho người thân
- **Cập nhật liên tục**: Tracking vị trí theo thời gian thực

### 4. 📞 Danh bạ khẩn cấp

- **Số khẩn cấp hệ thống**:
  - 🚔 Công an 113
  - 🚑 Cấp cứu 115
  - 🚒 Cứu hỏa 114
  - 🛡️ Bảo vệ trường
- **Danh bạ cá nhân**: Thêm liên hệ người thân, bạn bè
- **Gọi nhanh**: Chạm để gọi điện ngay lập tức
- **Quản lý email**: Lưu email để gửi cảnh báo

### 5. 🌐 Đa ngôn ngữ

- **3 ngôn ngữ**: Tiếng Việt, English, 日本語 (Japanese)
- **Chuyển đổi dễ dàng**: Thay đổi ngôn ngữ trong Settings
- **Lưu tự động**: Ghi nhớ ngôn ngữ đã chọn
- **Dịch toàn diện**: Tất cả giao diện và thông báo

### 6. 🎯 Tính năng khác

- **Thông tin thủy triều**: Xem triều lên/triều xuống
- **Tin tức cảnh báo**: Cập nhật tin thiên tai
- **Quản lý thông tin cá nhân**: Profile sinh viên
- **Giao diện đẹp mắt**: Material Design 3, Dark Mode support

### 7. 👨‍💼 Admin Dashboard (Web)

> 🌐 **Truy cập:** `https://your-backend-domain.com/admin`

- **Quản lý người dùng**: 
  - Xem danh sách tất cả users
  - Tìm kiếm theo tên, email, MSSV
  - Xem chi tiết và lịch sử hoạt động
  - Khóa/mở khóa tài khoản
  - Thay đổi quyền (User/Admin)

- **Quản lý SOS**:
  - Xem tất cả báo cáo khẩn cấp
  - Vị trí GPS trên Google Maps
  - Cập nhật trạng thái (Pending/Resolved/Cancelled)
  - Thông tin người báo cáo

- **Thống kê & Analytics**:
  - Tổng số người dùng, users hoạt động
  - Top 10 users hoạt động nhiều nhất
  - Thống kê theo loại hoạt động
  - Dashboard trực quan với biểu đồ

- **Auto-Update**:
  - Backend tự động cập nhật dữ liệu mực nước mỗi giờ
  - Chạy 24/7 không gián đoạn
  - Monitoring và health check

**Xem hướng dẫn deploy:** [Backend Deployment Guide](backend-python/DEPLOYMENT_GUIDE.md)

---

## 🏗️ Kiến trúc hệ thống

```
┌─────────────────────────────────────────────────────────────┐
│                    MOBILE APPLICATION                        │
│                     (Flutter/Dart)                           │
│  ┌────────────┐  ┌────────────┐  ┌──────────────┐          │
│  │   Screens  │  │  Providers │  │   Services   │          │
│  │            │  │            │  │              │          │
│  │ • Home     │  │ • User     │  │ • Location   │          │
│  │ • SOS      │  │ • Location │  │ • Email      │          │
│  │ • Settings │  │ • Contacts │  │ • Database   │          │
│  │ • Water    │  │ • Water    │  │ • API        │          │
│  └────────────┘  └────────────┘  └──────────────┘          │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ REST API
                         │
┌────────────────────────▼────────────────────────────────────┐
│                   BACKEND SERVER                             │
│                   (Python/Flask)                             │
│  ┌────────────┐  ┌────────────┐  ┌──────────────┐          │
│  │    API     │  │  Scraper   │  │  Scheduler   │          │
│  │            │  │            │  │              │          │
│  │ • REST     │  │ • Selenium │  │ • APScheduler│          │
│  │ • CORS     │  │ • MRC Data │  │ • Auto Update│          │
│  │ • JSON     │  │ • Parser   │  │ • 6h interval│          │
│  └────────────┘  └────────────┘  └──────────────┘          │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ Web Scraping
                         │
┌────────────────────────▼────────────────────────────────────┐
│            EXTERNAL DATA SOURCES                             │
│  • MRC (Mekong River Commission)                            │
│  • GPS/Location Services                                     │
│  • Email Service (SMTP)                                      │
└─────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Công nghệ sử dụng

### Frontend (Mobile App)

| Công nghệ | Phiên bản | Mục đích |
|-----------|-----------|----------|
| **Flutter** | 3.0+ | Framework phát triển mobile cross-platform |
| **Dart** | 3.0+ | Ngôn ngữ lập trình |
| **Provider** | ^6.1.1 | State management |
| **Geolocator** | ^10.1.0 | GPS và định vị |
| **Geocoding** | ^2.1.1 | Chuyển đổi tọa độ sang địa chỉ |
| **Shake** | ^3.0.0 | Phát hiện rung lắc thiết bị |
| **Mailer** | ^6.0.1 | Gửi email |
| **Dio** | ^5.4.0 | HTTP client |
| **Sqflite** | ^2.3.0 | Local database (SQLite) |
| **Intl** | ^0.20.2 | Internationalization (i18n) |
| **Flutter Localizations** | SDK | Đa ngôn ngữ |

### Backend (API Server)

| Công nghệ | Phiên bản | Mục đích |
|-----------|-----------|----------|
| **Python** | 3.13 | Ngôn ngữ lập trình backend |
| **Flask** | 3.1.0 | Web framework, REST API |
| **Flask-CORS** | 5.0.0 | Cross-Origin Resource Sharing |
| **Selenium** | 4.27.1 | Web scraping automation |
| **BeautifulSoup4** | 4.12.3 | HTML parsing |
| **Pandas** | 2.2.3 | Data processing |
| **NumPy** | 2.2.1 | Numerical computing |
| **APScheduler** | 3.11.0 | Task scheduling |
| **Requests** | 2.32.3 | HTTP library |

---

## 📥 Cài đặt

> 💡 **Muốn hướng dẫn chi tiết từng bước?** Xem [GETTING_STARTED.md](GETTING_STARTED.md)

### Yêu cầu hệ thống

#### Mobile App
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / Xcode
- Android 5.0+ hoặc iOS 12.0+

#### Backend Server
- Python 3.13+
- pip (Python package manager)
- Chrome/Chromium browser (cho Selenium)

### Cài đặt Mobile App

```bash
# 1. Clone repository
git clone https://github.com/your-username/fpt-guard-v2.git
cd fpt-guard-v2

# 2. Cài đặt dependencies
flutter pub get

# 3. Tạo file .env trong thư mục root
cp .env.example .env
# Chỉnh sửa .env với thông tin của bạn

# 4. Tạo localization files
flutter gen-l10n

# 5. Chạy ứng dụng
flutter run
```

#### File .env

```env
# Email Configuration
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password

# API Configuration
API_BASE_URL=http://localhost:5000
```

### Cài đặt Backend Server

```bash
# 1. Di chuyển vào thư mục backend
cd backend-python

# 2. Tạo virtual environment
python -m venv venv

# 3. Kích hoạt virtual environment
# Windows:
venv\Scripts\activate
# Linux/Mac:
source venv/bin/activate

# 4. Cài đặt dependencies
pip install -r requirements.txt

# 5. Chạy server
python app.py
```

Server sẽ chạy tại `http://localhost:5000`

---

## 🚀 Sử dụng

### Khởi động lần đầu

1. **Cài đặt thông tin cá nhân**
   - Mở ứng dụng
   - Vào **Settings (Cài đặt)**
   - Nhập họ tên, MSSV, số điện thoại, email

2. **Thêm danh bạ khẩn cấp**
   - Vào **Contacts (Danh bạ)**
   - Nhấn **Thêm liên lạc**
   - Nhập tên, số điện thoại, email người thân

3. **Cho phép quyền**
   - GPS/Location: Để theo dõi vị trí
   - Phone: Để gọi điện khẩn cấp
   - Camera: Để chụp ảnh khi SOS
   - Sensors: Để phát hiện rung lắc

### Gửi SOS khẩn cấp

#### Cách 1: Nhấn nút SOS
1. Nhấn nút **SOS** màu đỏ ở màn hình chính
2. Chụp ảnh hiện trường (tùy chọn)
3. Nhập mô tả tình huống
4. Nhấn **Gửi**

#### Cách 2: Rung mạnh điện thoại
1. Rung điện thoại mạnh 2 lần liên tiếp
2. Xác nhận trong dialog xuất hiện
3. SOS sẽ được gửi tự động (không cần ảnh)

### Xem mực nước sông Mekong

1. Vào **Mực nước Sông Mekong** từ màn hình chính
2. Xem danh sách 5 trạm đo
3. Nhấn vào trạm để xem chi tiết:
   - Biểu đồ xu hướng
   - Mực nước hiện tại
   - Lịch sử 7 ngày
   - Thông tin trạm

### Chia sẻ vị trí

1. Nhấn nút **Chia sẻ** ở thẻ vị trí hiện tại
2. Chọn liên hệ từ danh sách
3. Email với vị trí sẽ được gửi tự động

---

## 🌐 Đa ngôn ngữ

Ứng dụng hỗ trợ 3 ngôn ngữ:

### 🇻🇳 Tiếng Việt (Vietnamese)
- Ngôn ngữ mặc định
- Dành cho sinh viên Việt Nam

### 🇬🇧 English
- For international students
- Complete translation

### 🇯🇵 日本語 (Japanese)
- 留学生向け
- 完全な翻訳

### Cách thay đổi ngôn ngữ

1. Vào **Settings (Cài đặt)**
2. Nhấn vào **Language (Ngôn ngữ)**
3. Chọn ngôn ngữ mong muốn
4. Ứng dụng tự động chuyển đổi

### Cấu trúc file ngôn ngữ

```
lib/l10n/
├── app_en.arb        # English
├── app_vi.arb        # Tiếng Việt
├── app_ja.arb        # 日本語
└── app_localizations.dart
```

---

## 📚 API Documentation

### Base URL
```
http://localhost:5000/api
```

### Endpoints

#### 1. Get Latest Water Levels
```http
GET /water-levels/latest
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "station_name": "Tân Châu",
      "water_level": 2.45,
      "date": "2026-01-10",
      "time": "08:00",
      "status": "normal"
    }
  ],
  "updated_at": "2026-01-10T08:00:00Z"
}
```

#### 2. Get Historical Data
```http
GET /water-levels/historical?station=Tân Châu&days=7
```

**Parameters:**
- `station` (optional): Tên trạm đo
- `days` (optional): Số ngày lấy về (default: 7)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "date": "2026-01-10",
      "water_level": 2.45,
      "station": "Tân Châu"
    }
  ],
  "count": 7
}
```

#### 3. Get Station Info
```http
GET /stations
```

**Response:**
```json
{
  "success": true,
  "stations": [
    {
      "id": "tan_chau",
      "name": "Tân Châu",
      "location": "An Giang",
      "latitude": 10.8167,
      "longitude": 105.2500
    }
  ]
}
```

#### 4. Trigger Manual Update
```http
POST /update
```

**Response:**
```json
{
  "success": true,
  "message": "Data updated successfully",
  "records_updated": 5
}
```

### Error Response

```json
{
  "success": false,
  "error": "Error message here"
}
```

### Scheduler

Backend tự động cập nhật dữ liệu mỗi **6 giờ**:
- 00:00 AM
- 06:00 AM
- 12:00 PM
- 06:00 PM

---

## 📁 Cấu trúc thư mục

```
fpt-guard-v2/
│
├── android/                      # Android native code
├── ios/                          # iOS native code
├── web/                          # Web support files
│
├── assets/                       # Static assets
│   ├── images/                   # Hình ảnh
│   │   ├── app_icon.jpg
│   │   └── background.jpeg
│   └── icons/                    # Icons
│
├── lib/                          # Flutter source code
│   ├── l10n/                     # Localization files
│   │   ├── app_en.arb           # English
│   │   ├── app_vi.arb           # Tiếng Việt
│   │   ├── app_ja.arb           # 日本語
│   │   └── app_localizations.dart
│   │
│   ├── models/                   # Data models
│   │   ├── contact_model.dart
│   │   ├── news_model.dart
│   │   ├── safe_location_model.dart
│   │   ├── tide_model.dart
│   │   ├── user_model.dart
│   │   └── water_level_model.dart
│   │
│   ├── providers/                # State management
│   │   ├── contacts_provider.dart
│   │   ├── locale_provider.dart
│   │   ├── location_provider.dart
│   │   ├── user_provider.dart
│   │   └── water_level_provider.dart
│   │
│   ├── screens/                  # UI screens
│   │   ├── home_screen.dart
│   │   ├── settings_screen.dart
│   │   ├── sos_form_screen.dart
│   │   ├── water_level_screen.dart
│   │   ├── station_detail_screen.dart
│   │   ├── contacts_screen.dart
│   │   ├── location_screen.dart
│   │   ├── news_screen.dart
│   │   ├── tide_screen.dart
│   │   └── splash_screen.dart
│   │
│   ├── services/                 # Business logic
│   │   ├── api_service.dart
│   │   ├── database_service.dart
│   │   ├── email_service.dart
│   │   ├── location_service.dart
│   │   ├── tide_service.dart
│   │   └── water_level_service.dart
│   │
│   ├── widgets/                  # Reusable widgets
│   │   ├── custom_drawer.dart
│   │   ├── sos_button.dart
│   │   ├── water_level_card.dart
│   │   └── water_level_chart.dart
│   │
│   └── main.dart                 # Entry point
│
├── backend-python/               # Python backend
│   ├── app.py                   # Flask API server
│   ├── auth.py                  # Authentication system
│   ├── database.py              # User database (SQLite)
│   ├── scheduler.py             # Data update scheduler
│   ├── mrc_scraper.py           # Web scraper
│   ├── data_processor.py        # Data processing
│   ├── config.py                # Configuration
│   ├── requirements.txt         # Python dependencies
│   ├── Dockerfile               # Docker configuration
│   ├── Procfile                 # Railway/Heroku deployment
│   │
│   ├── templates/               # Web templates
│   │   └── admin.html          # Admin dashboard UI
│   │
│   ├── static/                  # Static files
│   │   └── images/             # Images for dashboard
│   │
│   ├── data/                    # Data storage (auto-created)
│   │   ├── users.db            # User database
│   │   ├── latest_water_levels.json
│   │   └── historical_data.csv
│   │
│   ├── logs/                    # Log files (auto-created)
│   │   ├── api.log
│   │   └── scheduler.log
│   │
│   └── docs/                    # 📖 Backend Documentation
│       ├── README.md                    # Backend overview
│       ├── DEPLOYMENT_CHEATSHEET.md     # Quick reference
│       ├── DEPLOYMENT_QUICKSTART.md     # 5-minute deploy
│       ├── DEPLOYMENT_GUIDE.md          # Full deployment guide
│       ├── USER_MANAGEMENT_GUIDE.md     # User management
│       └── USER_MANAGEMENT_QUICKSTART.md # Quick user guide
│
├── test/                         # Unit tests
│   └── widget_test.dart
│
├── pubspec.yaml                  # Flutter dependencies
├── l10n.yaml                     # Localization config
├── .env                          # Environment variables
└── README.md                     # This file
```

---

## 🔧 Cấu hình

### Backend Configuration

File `backend-python/config.py`:

```python
# Data directories
DATA_DIR = Path(__file__).parent / "data"
LOGS_DIR = Path(__file__).parent / "logs"

# MRC URL
MRC_BASE_URL = "https://monitoring.mrcmekong.org"

# Stations
STATIONS = {
    'tan_chau': 'Tân Châu',
    'chau_doc': 'Châu Đốc',
    'can_tho': 'Cần Thơ',
    'vinh_long': 'Vĩnh Long',
    'my_thuan': 'Mỹ Thuận'
}

# Update interval (hours)
UPDATE_INTERVAL = 6
```

### Email Configuration

Để gửi email SOS, cấu hình SMTP trong `.env`:

```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password  # Use App Password, not regular password
```

**Lấy App Password (Gmail):**
1. Vào Google Account > Security
2. Bật 2-Step Verification
3. Vào App passwords
4. Tạo password cho "Mail" app
5. Copy password vào `.env`

---

## 🧪 Testing

### Unit Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Integration Tests

```bash
# Run integration tests
flutter drive --target=test_driver/app.dart
```

---

## 🚀 Deployment

### Backend Server - Deploy 24/7 Admin Dashboard

> 📖 **Hướng dẫn chi tiết deploy backend admin dashboard để theo dõi all time:**

| Tài liệu | Mô tả | Thời gian |
|----------|-------|-----------|
| **[📋 Deployment Cheat Sheet](backend-python/DEPLOYMENT_CHEATSHEET.md)** | Quick reference cho tất cả platforms | 2 phút đọc |
| **[⚡ Quick Deploy - Railway](backend-python/DEPLOYMENT_QUICKSTART.md)** | Deploy trong 5 phút với Railway (Free) | 5 phút |
| **[📖 Full Deployment Guide](backend-python/DEPLOYMENT_GUIDE.md)** | Hướng dẫn đầy đủ: Railway, Render, VPS, Docker | 30 phút |
| **[👥 User Management Guide](backend-python/USER_MANAGEMENT_GUIDE.md)** | Quản lý users và API documentation | 15 phút |

**Deploy Options:**

#### Option 1: Railway (Recommended - Free) ⚡
```bash
# 5 phút deploy
# Xem: backend-python/DEPLOYMENT_QUICKSTART.md

# 1. Push code lên GitHub
git push origin main

# 2. Vào Railway.app → Deploy from GitHub
# 3. Set Root Directory: backend-python
# 4. Done! URL: https://your-app.railway.app/admin
```

#### Option 2: Render (Free tier)
```bash
# Xem: backend-python/DEPLOYMENT_GUIDE.md#option-2-deploy-lên-render
cd backend-python
# Follow detailed instructions in guide
```

#### Option 3: VPS (DigitalOcean/AWS)
```bash
# Xem: backend-python/DEPLOYMENT_GUIDE.md#option-3-deploy-lên-vps
# Full control, 24/7 uptime
# Recommended for production
```

#### Option 4: Docker
```bash
cd backend-python
docker build -t fpt-guard-backend .
docker run -p 5000:5000 fpt-guard-backend

# Xem: backend-python/DEPLOYMENT_GUIDE.md#option-4-deploy-với-docker
```

**Admin Dashboard Access:**
```
URL: https://your-deployed-domain.com/admin
Default Login:
  Email: admin@fptguard.com
  Password: admin123

⚠️ ĐỔI PASSWORD NGAY SAU KHI DEPLOY!
```

**Backend Features:**
- ✅ API cho Flutter app
- ✅ Admin web dashboard
- ✅ User management system
- ✅ SOS reports management
- ✅ Analytics & statistics
- ✅ Auto-update water level data (mỗi giờ)
- ✅ Chạy 24/7 không gián đoạn

### Mobile App

#### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Google Play)
flutter build appbundle --release
```

#### iOS
```bash
# Build iOS app
flutter build ios --release

# Archive for App Store
flutter build ipa
```

---

## 🤝 Đóng góp

Chúng tôi rất hoan nghênh mọi đóng góp! Để đóng góp:

1. **Fork** repository
2. Tạo **branch** mới (`git checkout -b feature/AmazingFeature`)
3. **Commit** changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** lên branch (`git push origin feature/AmazingFeature`)
5. Mở **Pull Request**

### Coding Standards

- **Dart/Flutter**: Tuân thủ [Effective Dart](https://dart.dev/guides/language/effective-dart)
- **Python**: Tuân thủ [PEP 8](https://pep8.org/)
- Code phải có comments đầy đủ
- Viết unit tests cho code mới

---

## 📄 License

Dự án này được phát hành dưới [MIT License](LICENSE).

```
MIT License

Copyright (c) 2026 FPT University Can Tho

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

---

## 👥 Team

**FPT Guard Development Team**

- **Project Lead**: [Your Name]
- **Mobile Developer**: [Developer Name]
- **Backend Developer**: [Developer Name]
- **UI/UX Designer**: [Designer Name]

---

## 📞 Liên hệ

- **Email**: contact@fptguard.com
- **Website**: https://fptguard.com
- **Issues**: [GitHub Issues](https://github.com/your-username/fpt-guard-v2/issues)

---

## 🙏 Acknowledgments

- [MRC (Mekong River Commission)](https://monitoring.mrcmekong.org) - Dữ liệu mực nước
- [Flutter Team](https://flutter.dev) - Framework tuyệt vời
- [FPT University](https://fpt.edu.vn) - Hỗ trợ dự án
- Tất cả contributors và testers

---

<div align="center">

**Made with ❤️ by FPT University Can Tho**

⭐ Star us on GitHub — it helps!

[⬆ Back to top](#fpt-guard-20-)

</div>

---

## 📖 Additional Documentation

### English

<a name="english"></a>

# FPT Guard 2.0 - Student Safety Application

A comprehensive mobile application designed to ensure student safety at FPT University Can Tho, especially during emergencies and natural disasters.

**Key Features:**
- 🚨 Emergency SOS with shake detection
- 🌊 Real-time Mekong River water level monitoring
- 📍 Location sharing with contacts
- 📞 Quick dial to emergency services
- 🌐 Multi-language support (Vietnamese, English, Japanese)

For detailed documentation, see sections above.

### Japanese

<a name="japanese"></a>

# FPT Guard 2.0 - 学生安全アプリケーション

FPTカントー大学の学生の安全を確保するために設計された包括的なモバイルアプリケーション。特に緊急事態や自然災害時に役立ちます。

**主な機能:**
- 🚨 振動検知付き緊急SOS
- 🌊 メコン川の水位のリアルタイム監視
- 📍 連絡先との位置情報共有
- 📞 緊急サービスへのクイックダイヤル
- 🌐 多言語サポート（ベトナム語、英語、日本語）

詳細なドキュメントについては、上記のセクションを参照してください。

---

**Version**: 2.0.0  
**Last Updated**: January 10, 2026  
**Maintained by**: FPT University Can Tho Development Team