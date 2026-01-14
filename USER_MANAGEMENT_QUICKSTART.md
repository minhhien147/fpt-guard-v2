# 🚀 Quick Start - Quản Lý Người Dùng FPT Guard 2.0

## ✅ Đã Hoàn Thành

Hệ thống quản lý người dùng đã được xây dựng hoàn chỉnh với các tính năng:

1. ✅ **Backend Authentication API** - JWT authentication, user management
2. ✅ **Admin Dashboard** - Giao diện web quản lý users
3. ✅ **User Analytics** - Theo dõi và thống kê người dùng
4. ✅ **SOS Management** - Quản lý báo cáo khẩn cấp
5. ✅ **Flutter Integration** - Login/Register screens, Auth service

---

## 🎯 Bắt Đầu Sử Dụng (3 Bước)

### Bước 1: Khởi Động Backend

```bash
cd backend-python
pip install -r requirements.txt
python app.py
```

Server sẽ chạy tại: **http://localhost:5000**

### Bước 2: Truy Cập Admin Dashboard

Mở trình duyệt: **http://localhost:5000/admin**

**Tài khoản mặc định:**
- Email: `admin@fptguard.com`
- Password: `admin123`

⚠️ **Quan trọng**: Đổi mật khẩu ngay sau khi đăng nhập!

### Bước 3: Cấu Hình Flutter App

Mở `lib/services/auth_service.dart` và cập nhật URL:

```dart
// Line 6
static const String baseUrl = 'http://10.0.2.2:5000'; // Android Emulator
// hoặc
static const String baseUrl = 'http://192.168.x.x:5000'; // Real device (thay IP)
```

Chạy app:
```bash
flutter pub get
flutter run
```

---

## 📱 Luồng Hoạt Động User

1. **Lần đầu mở app** → Hiển thị Login Screen
2. **Chưa có tài khoản** → Nhấn "Đăng ký ngay" → Register
3. **Đã đăng ký** → Login → Tự động vào Home
4. **Đã login trước đó** → Tự động login (JWT token)

---

## 🎨 Admin Dashboard - Các Tab

### 👥 Tab Người Dùng
- Xem danh sách tất cả users
- Tìm kiếm theo tên/email/MSSV
- Xem chi tiết user
- Khóa/mở khóa tài khoản

### 🆘 Tab SOS
- Xem báo cáo khẩn cấp
- Cập nhật trạng thái (Pending/Resolved/Cancelled)
- Xem vị trí trên Google Maps

### 📊 Tab Hoạt Động
- Top users hoạt động nhiều nhất
- Thống kê theo loại hoạt động

---

## 🔐 API Endpoints Quan Trọng

### User APIs
- `POST /api/auth/register` - Đăng ký
- `POST /api/auth/login` - Đăng nhập
- `POST /api/auth/logout` - Đăng xuất
- `GET /api/auth/me` - Thông tin user hiện tại
- `PUT /api/auth/update` - Cập nhật profile

### Admin APIs (Yêu cầu admin role)
- `GET /api/admin/users` - Danh sách users
- `GET /api/admin/statistics` - Thống kê
- `GET /api/admin/sos` - Danh sách SOS

### SOS APIs
- `POST /api/sos` - Tạo báo cáo SOS

Chi tiết: Xem file `backend-python/USER_MANAGEMENT_GUIDE.md`

---

## 💡 Tips & Best Practices

### Cho Admin
1. **Thường xuyên check SOS reports** - Phản hồi nhanh
2. **Monitor statistics daily** - Hiểu user behavior
3. **Review new users** - Phát hiện spam/fake accounts
4. **Backup database** - SQLite file: `backend-python/data/users.db`

### Cho Developer
1. **Environment Variables** - Dùng `.env` cho sensitive data
2. **Error Handling** - Luôn handle API errors trong Flutter
3. **Token Refresh** - Implement token refresh khi expired
4. **HTTPS** - Dùng HTTPS cho production

---

## 📁 Cấu Trúc Files Mới

### Backend
```
backend-python/
├── app.py (updated)           # Added auth & admin APIs
├── auth.py (new)              # Authentication middleware
├── database.py (new)          # User management database
├── templates/
│   └── admin.html (new)       # Admin dashboard UI
├── data/
│   └── users.db (auto-created) # SQLite database
└── USER_MANAGEMENT_GUIDE.md (new) # Detailed guide
```

### Flutter
```
lib/
├── services/
│   └── auth_service.dart (new)     # Authentication service
├── screens/
│   ├── login_screen.dart (new)     # Login UI
│   ├── register_screen.dart (new)  # Register UI
│   └── splash_screen.dart (updated) # Added auth check
└── main.dart (updated)             # Added routes
```

---

## 🚀 Next Steps - Tính Năng Nâng Cao

### Phiên bản tiếp theo có thể thêm:

1. **Email Notifications** - Gửi email khi có SOS
2. **2FA Authentication** - Bảo mật 2 lớp
3. **Advanced Analytics** - Charts & graphs
4. **Export Reports** - PDF/CSV reports
5. **Push Notifications** - Real-time alerts
6. **User Roles** - Nhiều roles hơn (moderator, etc.)
7. **Audit Logs** - Detailed activity logs

---

## 🆘 Cần Trợ Giúp?

1. **Xem hướng dẫn chi tiết**: `backend-python/USER_MANAGEMENT_GUIDE.md`
2. **Check logs**: 
   - Backend: `backend-python/logs/api.log`
   - Flutter: Terminal khi run app
3. **Common issues**:
   - Connection refused → Check backend đã chạy chưa
   - 401 Unauthorized → Token expired, login lại
   - 403 Forbidden → Không có quyền admin

---

## 📊 Database Location

SQLite database được lưu tại:
```
backend-python/data/users.db
```

**Backup database**:
```bash
cp backend-python/data/users.db backend-python/data/users_backup_$(date +%Y%m%d).db
```

---

## ✅ Checklist Khi Deploy Production

- [ ] Đổi password admin
- [ ] Update `baseUrl` trong Flutter app
- [ ] Enable HTTPS
- [ ] Setup proper CORS
- [ ] Configure environment variables
- [ ] Setup database backups
- [ ] Configure logging
- [ ] Add rate limiting
- [ ] Test on real devices
- [ ] Prepare support documentation

---

**🎉 Hệ thống đã sẵn sàng! Bắt đầu quản lý người dùng của bạn ngay!**

*Tài liệu được tạo tự động - FPT Guard 2.0*
