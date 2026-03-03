# Luồng sử dụng ứng dụng SAFE GUARD

Tài liệu mô tả chi tiết luồng từ lần mở app, đăng ký/đăng nhập đến sử dụng các tính năng.

---

## 1. Khởi động ứng dụng

```
Mở app
  → Splash (logo + "Đang khởi động...", ~2 giây)
  → Kiểm tra đã đăng nhập chưa (token trong máy)
       ├─ Đã đăng nhập → Load user, danh bạ, vị trí → Chuyển đến Trang chủ
       └─ Chưa đăng nhập → Chuyển đến Màn hình Đăng nhập
```

---

## 2. Đăng ký tài khoản (lần đầu)

```
Màn hình Đăng nhập
  → Chọn "Đăng ký ngay"
  → Màn hình Đăng ký tài khoản

Nhập đầy đủ:
  - Họ và tên
  - MSSV
  - Số điện thoại
  - Email
  - Mật khẩu (≥ 6 ký tự)
  - Xác nhận mật khẩu

  → Bấm "Đăng ký"
       ├─ Lỗi (email trùng, thiếu field, …) → Hiện thông báo, sửa và thử lại
       └─ Thành công
            → Backend tạo tài khoản + gửi mã OTP 6 số vào email
            → App chuyển sang Màn hình Xác thực email
```

### 2.1. Xác thực email (OTP)

```
Màn hình Xác thực email
  - Hiển thị email đã đăng ký (dạng ẩn: abc***@fpt.edu.vn)
  - 6 ô nhập mã OTP (nhận trong email)

Người dùng:
  - Mở email → copy mã 6 số
  - Nhập lần lượt vào 6 ô (hoặc paste)
  - Khi nhập đủ 6 số, app tự gọi API xác thực
       ├─ Đúng → Đăng nhập luôn → Chuyển đến Trang chủ
       └─ Sai → Báo lỗi, xóa ô, nhập lại

  - "Gửi lại" → Backend gửi OTP mới (mã cũ hết hiệu lực sau 10 phút)
  - "Quay lại đăng nhập" → Về Màn hình Đăng nhập
```

---

## 3. Đăng nhập (đã có tài khoản)

Có **2 cách** đăng nhập:

### 3.1. Đăng nhập bằng Email + Mật khẩu

```
Màn hình Đăng nhập
  → Nhập Email + Mật khẩu
  → Bấm "Đăng nhập"

  ├─ Sai email/mật khẩu → Hiện thông báo lỗi
  ├─ Tài khoản bị khóa → Báo "Account is disabled"
  ├─ Email chưa xác thực
  │    → Backend tự gửi lại OTP vào email
  │    → App chuyển sang Màn hình Xác thực email (nhập OTP như mục 2.1)
  └─ Thành công → Chuyển đến Trang chủ
```

### 3.2. Đăng nhập bằng Mã nhóm

```
Màn hình Đăng nhập
  → Bấm "Đăng nhập bằng mã nhóm"
  → Màn hình Đăng nhập nhóm

Nhập:
  - Mã nhóm (do admin cấp, VD: FPT2024)
  - Tên hiển thị (VD: Nguyen Van A)

  → Bấm "Vào nhóm"
       ├─ Mã sai / đã tắt / hết hạn → Báo lỗi
       └─ Thành công → Tạo hoặc dùng lại tài khoản nhóm → Chuyển đến Trang chủ
```

*Lưu ý:* Mỗi cặp (mã nhóm + tên hiển thị) là một “tài khoản” riêng; dùng lại cùng tên trên thiết bị khác = tiếp tục phiên đó.

---

## 4. Trang chủ (sau khi đăng nhập)

```
Trang chủ
  - Lời chào + tên user
  - Thẻ Vị trí hiện tại (địa chỉ, tọa độ) + nút "Chia sẻ"
  - Nút SOS lớn (nhấn để gửi cảnh báo khẩn cấp)
  - Gợi ý: "Nhấn để gửi cảnh báo khẩn cấp" / "Email sẽ được gửi đến tất cả liên hệ"
  - Mục Gọi nhanh: 4 số cố định (Công an 113, Cảnh sát, Cứu thương, Cứu hỏa 114)
  - Danh sách Liên hệ cá nhân (thêm từ Danh bạ)

Menu drawer (góc trái):
  - Trang chủ
  - Danh bạ
  - Tin tức
  - Cài đặt
  - About
```

---

## 5. Gửi SOS (cảnh báo khẩn cấp)

### 5.1. Gửi SOS qua nút chính

```
Trang chủ
  → Bấm nút SOS (vòng tròn đỏ)
  → Kiểm tra: đã nhập thông tin cá nhân chưa? Có lấy được vị trí không?
       ├─ Thiếu → Báo lỗi / "Đang lấy vị trí..."
       └─ Đủ
            → Màn hình Form SOS

Form SOS:
  - Ảnh (tùy chọn), Mô tả (tùy chọn)
  - Bấm "Gửi SOS"
       → Gửi báo cáo lên server (nếu đăng nhập) + lưu local + gửi email đến danh sách liên hệ khẩn cấp (có thể kèm ảnh/ghi âm)
       → Thông báo thành công / lỗi → Quay lại Trang chủ
```

### 5.2. Gửi SOS nhanh (rung / nút âm lượng)

```
Trang chủ đang mở
  - Rung điện thoại 2 lần (shake) HOẶC nhấn nút âm lượng 3 lần
  → Hiện dialog: "Phát hiện rung" / "Phát hiện nút âm lượng"
  → "Gửi SOS ngay" hoặc "Hủy"
  → Nếu gửi: tự ghi âm 5 giây, gửi SOS + email (không cần mở form, không bắt buộc ảnh)
  → Tự gửi sau 5 giây nếu không bấm Hủy
```

---

## 6. Chia sẻ vị trí

```
Trang chủ
  → Trong thẻ "Vị trí hiện tại" bấm "Chia sẻ"
  → Chọn 1 liên hệ có email từ danh sách
  → App gửi email chứa địa chỉ + link bản đồ đến người đó
  → Thông báo "Đã chia sẻ vị trí" / lỗi
```

---

## 7. Danh bạ

```
Drawer → Danh bạ

  - Danh sách liên hệ khẩn cấp (cá nhân)
  - Thêm liên hệ: Tên + Số điện thoại (và email nếu cần nhận SOS / chia sẻ vị trí)
  - Gọi điện / Xóa từng liên hệ
```

*Liên hệ có email* dùng cho: nhận email SOS, nhận email chia sẻ vị trí.

---

## 8. Tin tức / Thủy triều

```
Drawer → Tin tức   → Màn hình Tin tức
Drawer → (Thủy triều nếu có trong menu) → Màn hình Thủy triều
```

---

## 9. Cài đặt

```
Drawer → Cài đặt

  - Ngôn ngữ: Chọn Tiếng Việt / English / 日本語
  - Bảo vệ chạy nền (Foreground Service)
       - Bật: App chạy nền, hỗ trợ SOS và vị trí khi thu nhỏ app
       - Tắt: Chỉ hoạt động khi mở app
       - Mặc định khi cài lần đầu: TẮT (chỉ bật khi người dùng bật)
  - Thông tin cá nhân: Họ tên, MSSV, SĐT, Email (chỉ xem/sửa, không đổi mật khẩu tại đây)
  - Lưu thông tin
  - Thông tin ứng dụng: Phiên bản, Tổ chức, Ứng dụng
  - Đăng xuất (nếu đã đăng nhập) → Xác nhận → Về Màn hình Đăng nhập
```

---

## 10. Tóm tắt luồng một trang

```
                    ┌─────────────┐
                    │   Mở app    │
                    └──────┬──────┘
                           ▼
                    ┌─────────────┐
                    │   Splash    │
                    └──────┬──────┘
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
       Đã đăng nhập              Chưa đăng nhập
              │                         │
              ▼                         ▼
       ┌─────────────┐           ┌─────────────┐
       │  Trang chủ  │           │   Đăng nhập │
       └─────────────┘           └──────┬──────┘
              ▲                          │
              │              ┌───────────┼───────────┐
              │              ▼           ▼           ▼
              │       Email+Pass    Mã nhóm    Đăng ký
              │              │           │           │
              │              │           │           ▼
              │              │           │    ┌─────────────┐
              │              │           │    │ Xác thực    │
              │              │           │    │ email (OTP)  │
              │              │           │    └──────┬──────┘
              │              │           │           │
              └──────────────┴───────────┴───────────┘
```

---

## 11. Điều kiện cần để dùng đầy đủ

| Tính năng              | Điều kiện |
|------------------------|-----------|
| Đăng ký / Đăng nhập    | Kết nối internet, backend hoạt động |
| Xác thực email (OTP)   | Backend cấu hình MAIL_USERNAME, MAIL_PASSWORD (Gmail App Password) |
| Gửi SOS lên server     | Đăng nhập (email hoặc mã nhóm) |
| Gửi email SOS / Chia sẻ vị trí | App: .env có MAIL_USERNAME, MAIL_PASSWORD |
| Chạy nền (Foreground)  | Người dùng bật trong Cài đặt |
| Vị trí                  | Quyền vị trí được cấp |

---

*Tài liệu luồng app — SAFE GUARD v2.0*
