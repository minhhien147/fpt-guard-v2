# 🚨 Tính năng SOS bằng nút âm lượng

## Mô tả

Tính năng cho phép người dùng **kích hoạt SOS khẩn cấp** bằng cách **bấm nút âm lượng 3 lần liên tiếp** trong vòng 3 giây.

Tính năng này hoạt động **ngay cả khi màn hình đang bật** và app đang mở.

---

## 🎯 Cách sử dụng

### Để kích hoạt SOS:

1. Mở app SAFE GUARD
2. Vào màn hình Home
3. **Bấm nút âm lượng (lên hoặc xuống) 3 lần nhanh** (trong vòng 3 giây)
4. Sẽ xuất hiện dialog xác nhận:
   - **"🚨 PHÁT HIỆN NÚT ÂM LƯỢNG"**
   - Bấm **"Gửi SOS"** để xác nhận
   - Hoặc **"Hủy"** nếu bấm nhầm

---

## ⚙️ Cơ chế hoạt động

```
Bấm nút âm lượng lần 1 → Đếm: 1/3
Bấm nút âm lượng lần 2 → Đếm: 2/3
Bấm nút âm lượng lần 3 → Đếm: 3/3 → KÍCH HOẠT SOS!
```

- **Thời gian chờ**: 3 giây giữa các lần bấm
- Nếu quá 3 giây không bấm tiếp → Reset về 0
- Sau khi trigger SOS, service tạm dừng 5 giây để tránh trigger nhầm

---

## 🔧 Cấu hình

### Trong code (`volume_sos_service.dart`):

```dart
final int _maxPressCount = 3;        // Số lần bấm (mặc định: 3)
final int _resetTimeSeconds = 3;     // Thời gian reset (mặc định: 3 giây)
```

### Bật/tắt tính năng:

Trong `home_screen.dart`:

```dart
bool _volumeSOSEnabled = true;  // true = bật, false = tắt
```

---

## 🚀 Test tính năng

### Cách test:

1. Chạy app trên emulator hoặc điện thoại thật
2. Vào màn hình Home
3. **Bấm nút Volume Up hoặc Volume Down 3 lần nhanh**
4. Xem log trong terminal:

```
flutter: Volume button pressed: 1/3
flutter: Volume button pressed: 2/3
flutter: Volume button pressed: 3/3
flutter: 🚨 TRIPLE PRESS DETECTED - TRIGGERING SOS!
```

5. Dialog xác nhận sẽ xuất hiện

---

## 📱 Hạn chế

### ❌ Không hoạt động khi:

- App bị đóng hoàn toàn (killed)
- App chạy ở background
- Màn hình khóa (lockscreen)

### ✅ Hoạt động khi:

- App đang mở (foreground)
- Màn hình bật, đang dùng app

---

## 🔮 Nâng cấp trong tương lai

Để tính năng hoạt động **ngay cả khi app bị đóng**, cần:

1. **Foreground Service** (chạy ngầm liên tục)
   - Hiển thị notification cố định
   - Lắng nghe nút âm lượng 24/7
   - Tốn pin cao

2. **Accessibility Service** (quyền cao)
   - Yêu cầu user cấp quyền Accessibility
   - Có thể lắng nghe mọi sự kiện hệ thống
   - Khó được duyệt trên Google Play

3. **Widget/Shortcut trên lockscreen**
   - Thêm nút SOS nhanh trên màn hình khóa
   - Android 7+ support

---

## 📝 Changelog

### Version 1.0 (2026-01-28)
- ✅ Phát hiện bấm nút âm lượng 3 lần
- ✅ Dialog xác nhận trước khi gửi SOS
- ✅ Tự động reset sau 3 giây
- ✅ Tạm dừng 5 giây sau khi trigger để tránh spam

---

## 🛠️ Troubleshooting

### Không trigger được SOS?

1. **Kiểm tra bạn đã bấm đủ 3 lần chưa**
   - Xem log: `flutter: Volume button pressed: X/3`

2. **Kiểm tra khoảng cách giữa các lần bấm**
   - Phải < 3 giây giữa mỗi lần bấm

3. **Kiểm tra app có đang chạy không**
   - Service chỉ hoạt động khi app ở foreground

4. **Xem log lỗi**:
   ```bash
   flutter run
   # Bấm nút âm lượng 3 lần
   # Xem log trong terminal
   ```

---

## 💡 Tips

- **Luyện tập**: Thử bấm nhanh để quen tay
- **Bấm liên tục**: Không chờ quá lâu giữa các lần bấm
- **Cảnh báo nhầm**: Nếu bấm nhầm, bấm "Hủy" trong dialog

---

## 📞 Liên hệ

Nếu có vấn đề, tạo issue hoặc liên hệ developer.
