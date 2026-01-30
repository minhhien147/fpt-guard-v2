# 🛡️ SAFE GUARD

**Ứng dụng Bảo vệ Sinh viên FPT University Cần Thơ**

*An toàn mọi lúc, mọi nơi*

---

## 🌟 Tính Năng Chính

- 🚨 **SOS Khẩn Cấp**: Phát hiện rung lắc tự động, gửi email + vị trí GPS
- 🌊 **Giám Sát Mực Nước**: 5 trạm đo sông Mekong theo thời gian thực
- 📍 **Chia Sẻ Vị Trí**: Gửi vị trí cho người thân
- 📞 **Gọi Nhanh**: Công an 113, Cấp cứu 115, Cứu hỏa 114
- 🌐 **Đa Ngôn Ngữ**: Tiếng Việt, English, 日本語
- 👨‍💼 **Admin Dashboard**: Quản lý users, SOS reports, thống kê (Web)

---

## 🚀 Chạy App Nhanh

### 📱 Mobile App:

```bash
# 1. Cài dependencies
flutter pub get

# 2. Chạy app
flutter run
```

**Xem hướng dẫn chi tiết:** [QUICK_START.md](QUICK_START.md)

---

## 🌐 Backend API

**Backend đã deploy lên Railway - chạy 24/7:**

- **Admin Dashboard**: `https://web-production-dd806.up.railway.app/admin`
- **API Endpoint**: `https://web-production-dd806.up.railway.app/api`

**Login Admin:**
```
Email: admin@fptguard.com
Password: admin123
```

**Tính Năng Backend:**
- ✅ REST API cho Flutter app
- ✅ Admin web dashboard  
- ✅ User & SOS management
- ✅ Analytics & statistics
- ✅ Auto-update dữ liệu mỗi giờ

**Backend Repo:** https://github.com/minhhien147/fpt-guard-backend

---

## 🛠️ Tech Stack

**Frontend:**
- Flutter 3.0+
- Provider (State management)
- Geolocator, Shake, Mailer
- Sqflite (Local DB)

**Backend:**
- Python 3.11 + Flask
- Selenium (Web scraping)
- APScheduler (Auto-update)
- SQLite (User DB)

---

## 📁 Cấu Trúc

```
fpt-guard-v2/
├── lib/                    # Flutter app
│   ├── screens/           # UI screens
│   ├── providers/         # State management
│   ├── services/          # Business logic
│   ├── models/            # Data models
│   └── l10n/              # Đa ngôn ngữ
├── assets/                # Images, icons
├── android/               # Android native
├── ios/                   # iOS native
└── QUICK_START.md         # Hướng dẫn chạy app
```

**Backend:** [fpt-guard-backend](https://github.com/minhhien147/fpt-guard-backend)

---

## 📖 Tài Liệu

- **[⚡ Quick Start](QUICK_START.md)** - Chạy app trong 5 phút
- **[🔐 Login Info](#)** - Tài khoản admin & user mẫu
- **[🌐 Backend Repo](https://github.com/minhhien147/fpt-guard-backend)** - Backend source code

---

## 🙏 Credits

- [MRC](https://monitoring.mrcmekong.org) - Dữ liệu mực nước sông Mekong
- [Flutter Team](https://flutter.dev) - Framework
- FPT University Cần Thơ

---

**Made with ❤️ by FPT University Can Tho**

**Version 2.0.0** | **Last Updated: January 2026**
