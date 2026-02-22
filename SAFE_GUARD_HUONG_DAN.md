# SAFE GUARD — Tài liệu hướng dẫn sử dụng

> **Phiên bản:** 2.0 · **Nền tảng:** Android · **Tổ chức:** FPT University Cần Thơ

---

## Mục lục

1. [Giới thiệu ứng dụng](#1-giới-thiệu-ứng-dụng)
2. [Yêu cầu hệ thống](#2-yêu-cầu-hệ-thống)
3. [Cài đặt](#3-cài-đặt)
4. [Đăng ký tài khoản](#4-đăng-ký-tài-khoản)
5. [Đăng nhập](#5-đăng-nhập)
6. [Trang chủ](#6-trang-chủ)
7. [Gửi SOS khẩn cấp](#7-gửi-sos-khẩn-cấp)
8. [Chia sẻ vị trí](#8-chia-sẻ-vị-trí)
9. [Danh bạ khẩn cấp](#9-danh-bạ-khẩn-cấp)
10. [Tin tức & Thủy triều](#10-tin-tức--thủy-triều)
11. [Cài đặt](#11-cài-đặt)
12. [Đăng xuất](#12-đăng-xuất)
13. [Dành cho Admin](#13-dành-cho-admin)
14. [Flowchart tổng quan](#14-flowchart-tổng-quan)
15. [Câu hỏi thường gặp](#15-câu-hỏi-thường-gặp)

---

## 1. Giới thiệu ứng dụng

**SAFE GUARD** là ứng dụng an toàn cá nhân dành cho sinh viên và cán bộ FPT University Cần Thơ, với các tính năng chính:

| Tính năng | Mô tả |
|-----------|-------|
| 🆘 **SOS khẩn cấp** | Gửi cảnh báo kèm vị trí GPS đến danh bạ và server |
| 📍 **Chia sẻ vị trí** | Gửi vị trí thời gian thực qua email |
| 📋 **Danh bạ khẩn cấp** | Quản lý danh sách liên hệ cứu hộ cá nhân |
| 📰 **Tin tức** | Cập nhật thông tin an toàn, thủy triều |
| 🛡️ **Chạy nền** | Hỗ trợ SOS và vị trí ngay cả khi thu nhỏ app |
| 👥 **Đăng nhập nhóm** | Truy cập nhanh bằng mã nhóm, không cần tạo tài khoản riêng |

---

## 2. Yêu cầu hệ thống

- **Thiết bị:** Android 7.0 (API 24) trở lên
- **Dung lượng:** ~30 MB
- **Kết nối:** Internet (dữ liệu di động hoặc Wi-Fi)
- **Quyền cần cấp:**
  - Vị trí (Location) — bắt buộc để SOS và chia sẻ vị trí
  - Microphone — để ghi âm kèm SOS nhanh
  - Thông báo (Notification) — để nhận cảnh báo

---

## 3. Cài đặt

1. Tải file **SAFE_GUARD.apk** từ link được cung cấp bởi admin/tổ chức
2. Trên điện thoại: **Cài đặt → Bảo mật → Cho phép cài từ nguồn không rõ** (bật một lần)
3. Mở file `.apk` → Bấm **Cài đặt**
4. Sau khi cài xong → Bấm **Mở**
5. Cấp các quyền khi app yêu cầu (Vị trí, Microphone, Thông báo)

---

## 4. Đăng ký tài khoản

> Chỉ cần đăng ký **một lần**. Sau đó app nhớ đăng nhập, không cần nhập lại mỗi khi mở.

### Các bước:

1. Mở app → Màn hình đăng nhập → Bấm **"Đăng ký ngay"**
2. Nhập đầy đủ thông tin:

| Trường | Yêu cầu |
|--------|---------|
| Họ và tên | Bắt buộc |
| MSSV | Bắt buộc |
| Số điện thoại | Bắt buộc |
| Email | Bắt buộc, định dạng hợp lệ, chưa đăng ký |
| Mật khẩu | Bắt buộc, tối thiểu 6 ký tự |
| Xác nhận mật khẩu | Phải khớp với mật khẩu |

3. Bấm **"Đăng ký"**
4. Đăng ký thành công → **Vào trang chủ ngay**

> ℹ️ Nếu email đã tồn tại trong hệ thống, app sẽ báo lỗi — hãy dùng email khác hoặc đăng nhập.

---

## 5. Đăng nhập

Có **2 cách** đăng nhập:

### 5.1. Đăng nhập bằng Email + Mật khẩu

Dành cho người đã có tài khoản cá nhân:

1. Mở app → Nhập **Email** và **Mật khẩu**
2. Bấm **"Đăng nhập"**
3. Thành công → Vào Trang chủ

**Các lỗi thường gặp:**

| Thông báo lỗi | Nguyên nhân | Cách xử lý |
|---------------|-------------|------------|
| Invalid email or password | Sai email hoặc mật khẩu | Kiểm tra lại |
| Account is disabled | Tài khoản bị admin khóa | Liên hệ admin |

---

### 5.2. Đăng nhập bằng Mã nhóm

Dành cho thành viên nhóm được admin cấp mã — **không cần tạo tài khoản riêng**:

1. Màn hình đăng nhập → Bấm **"Đăng nhập bằng mã nhóm"**
2. Nhập **Mã nhóm** (VD: `FPT2026`) và **Tên hiển thị** (VD: `Nguyen Van A`)
3. Bấm **"Vào nhóm"**
4. Thành công → Vào Trang chủ

> ℹ️ Cùng mã nhóm + cùng tên hiển thị = cùng một tài khoản. Đăng nhập lại với đúng tên là tiếp tục phiên cũ.

> ⚠️ Nếu admin **tắt mã nhóm**, app sẽ **tự động đăng xuất** trong vòng 30 giây.

---

## 6. Trang chủ

Sau khi đăng nhập, bạn sẽ thấy màn hình chính với các thành phần:

```
┌─────────────────────────────────────┐
│  ≡   SAFE GUARD          👤 Tên     │  ← Thanh trên (menu + tên)
├─────────────────────────────────────┤
│  📍 Vị trí hiện tại                 │
│  [Địa chỉ đầy đủ]    [Chia sẻ →]   │
├─────────────────────────────────────┤
│                                     │
│         ┌───────────┐               │
│         │  🆘 SOS   │               │  ← Nút SOS chính
│         └───────────┘               │
│   "Nhấn để gửi cảnh báo khẩn cấp"  │
│                                     │
├─────────────────────────────────────┤
│  📞 Gọi nhanh                       │
│  [113]  [Cảnh sát]  [115]  [114]   │  ← Số khẩn cấp quốc gia
├─────────────────────────────────────┤
│  👥 Danh bạ cá nhân                 │
│  [Danh sách liên hệ đã thêm]        │
└─────────────────────────────────────┘
```

**Menu drawer (bấm ≡ hoặc vuốt từ trái):**

- 🏠 Trang chủ
- 📋 Danh bạ
- 📰 Tin tức
- ⚙️ Cài đặt
- ℹ️ Thông tin ứng dụng

---

## 7. Gửi SOS khẩn cấp

### 7.1. Gửi SOS qua nút chính

1. Trang chủ → Bấm nút **SOS** (vòng tròn đỏ lớn)
2. App kiểm tra vị trí và thông tin cá nhân
3. Màn hình **Form SOS** hiện ra:
   - Thêm ảnh (tùy chọn)
   - Nhập mô tả tình huống (tùy chọn)
4. Bấm **"Gửi SOS"**
5. Hệ thống:
   - Gửi báo cáo lên **server** (admin sẽ thấy trên dashboard)
   - Gửi **email** đến tất cả liên hệ trong danh bạ khẩn cấp
   - Email chứa: tên, vị trí GPS, link bản đồ, mô tả, ảnh (nếu có)

---

### 7.2. Gửi SOS nhanh — Rung điện thoại (Shake)

Khi đang ở trang chủ, **lắc điện thoại 2 lần mạnh**:

1. App hiện dialog: *"Phát hiện rung mạnh — Gửi SOS ngay?"*
2. Bấm **"Gửi SOS ngay"** hoặc chờ **5 giây** (tự gửi)
3. App **tự ghi âm 5 giây** rồi gửi SOS kèm file âm thanh
4. Bấm **"Hủy"** nếu không muốn gửi

---

### 7.3. Gửi SOS nhanh — Nút âm lượng

Khi đang ở trang chủ, **nhấn nút âm lượng 3 lần liên tiếp**:

1. Quy trình tương tự Shake SOS (mục 7.2)

---

### 7.4. Admin nhận SOS như thế nào?

Admin mở **Dashboard web** → Tab **"Báo cáo SOS"**:
- Xem danh sách báo cáo (người gửi, thời gian, vị trí, mô tả)
- Bấm **"Đã xử lý"** để đánh dấu hoàn thành

---

## 8. Chia sẻ vị trí

1. Trang chủ → Trong ô **"Vị trí hiện tại"** → Bấm **"Chia sẻ"**
2. Chọn liên hệ (phải có email) từ danh sách
3. App gửi email đến người đó chứa:
   - Địa chỉ đầy đủ
   - Tọa độ GPS
   - Link mở bản đồ Google Maps
4. Thông báo **"Đã chia sẻ vị trí"**

---

## 9. Danh bạ khẩn cấp

**Drawer → Danh bạ**

### Thêm liên hệ:
1. Bấm nút **"+"** (góc phải)
2. Nhập: Tên, Số điện thoại, Email (nếu muốn nhận SOS/chia sẻ vị trí)
3. Lưu

### Sử dụng:
- **Gọi điện:** Bấm vào tên → Gọi ngay
- **Xóa:** Giữ tên hoặc vuốt → Xóa
- Liên hệ **có email** sẽ tự động nhận email khi bạn gửi SOS hoặc chia sẻ vị trí

---

## 10. Tin tức & Thủy triều

**Drawer → Tin tức**

- Hiển thị các tin tức an toàn, cảnh báo thiên tai
- Dữ liệu cập nhật từ server

**Drawer → Thủy triều** *(nếu được bật)*

- Thông tin mực nước triều khu vực Cần Thơ
- Biểu đồ theo giờ

---

## 11. Cài đặt

**Drawer → Cài đặt**

| Mục | Mô tả |
|-----|-------|
| 🌐 **Ngôn ngữ** | Tiếng Việt / English / 日本語 |
| 🛡️ **Bảo vệ chạy nền** | Bật: app tiếp tục hoạt động khi thu nhỏ. Mặc định: **TẮT** |
| 👤 **Thông tin cá nhân** | Xem/sửa: Họ tên, MSSV, SĐT, Email |
| 💾 **Lưu thay đổi** | Lưu thông tin cá nhân lên server |

> ⚠️ **Bảo vệ chạy nền** cần bật để SOS và vị trí hoạt động khi app thu nhỏ. Do ảnh hưởng đến pin, mặc định để TẮT — chỉ bật khi thực sự cần.

---

## 12. Đăng xuất

**Drawer → Cài đặt → Đăng xuất**

1. Xác nhận đăng xuất
2. App xóa token, quay về màn hình đăng nhập
3. Lần sau mở app cần đăng nhập lại

> ℹ️ Tắt app (không đăng xuất) → App nhớ đăng nhập, mở lại vào thẳng trang chủ.

---

## 13. Dành cho Admin

> Truy cập Dashboard: mở trình duyệt → vào URL backend (Railway) → đăng nhập bằng tài khoản admin.

---

### 13.1. Quản lý người dùng

**Tab "Người dùng"**

| Hành động | Cách làm |
|-----------|----------|
| Xem danh sách | Mặc định hiển thị tất cả user |
| Xem chi tiết | Bấm **"Xem"** bên cạnh user |
| Khóa tài khoản | Bấm **"Khóa"** → User bị đăng xuất khỏi app trong vòng 30 giây |
| Mở khóa | Bấm **"Bật"** → User đăng nhập lại bình thường |

---

### 13.2. Quản lý mã nhóm

**Tab "Mã nhóm"**

#### Tạo mã nhóm mới:
1. Bấm **"+ Tạo mã nhóm"**
2. Điền thông tin:

| Trường | Mô tả |
|--------|-------|
| Mã nhóm | Chuỗi định danh (VD: `FPT2026`, `EXE202`) — **không trùng** |
| Tên nhóm | Tên hiển thị (VD: "Nhóm EXE202 HK1/2026") |
| Mô tả | Tùy chọn |
| Số thành viên tối đa | Để trống = không giới hạn |
| Ngày hết hạn | Để trống = không hết hạn |

3. Bấm **"Tạo"** → Mã nhóm hiển thị trong danh sách

#### Bật/Tắt mã nhóm:
- **"Tắt"** → Mã nhóm bị vô hiệu hóa, tất cả thành viên bị đăng xuất khỏi app trong 30 giây
- **"Bật"** → Mã nhóm hoạt động trở lại, thành viên đăng nhập lại bình thường

#### Xóa mã nhóm:
- Bấm **"Xóa"** → Xóa vĩnh viễn (thành viên không còn dùng được mã này nữa)

---

### 13.3. Xử lý báo cáo SOS

**Tab "Báo cáo SOS"** — Số đỏ trên tab = số báo cáo chưa xử lý

| Cột | Nội dung |
|-----|---------|
| Người gửi | Tên + ID |
| Thời gian | Ngày giờ gửi |
| Vị trí | Địa chỉ + tọa độ (click để mở bản đồ) |
| Mô tả | Nội dung người dùng nhập |
| Trạng thái | Chờ xử lý / Đã xử lý |

Bấm **"Đã xử lý"** để đóng báo cáo.

---

### 13.4. Xem hoạt động hệ thống

**Tab "Hoạt động"** — Log tất cả hành động: đăng nhập, đăng xuất, gửi SOS, đăng ký...

---

## 14. Flowchart tổng quan

### 14.1. Luồng khởi động & xác thực

```
                        ┌─────────────┐
                        │   Mở app    │
                        └──────┬──────┘
                               ▼
                        ┌─────────────┐
                        │   Splash    │ (~2 giây)
                        └──────┬──────┘
                               ▼
                   ┌───────────────────────┐
                   │  Kiểm tra token lưu   │
                   │  trong máy            │
                   └───────────┬───────────┘
                               │
              ┌────────────────┴─────────────────┐
              ▼                                   ▼
      Token hợp lệ                         Không có / hết hạn
              │                                   │
              ▼                                   ▼
   ┌─────────────────┐                   ┌─────────────────┐
   │  Tải thông tin  │                   │  Màn hình       │
   │  người dùng     │                   │  Đăng nhập      │
   └────────┬────────┘                   └────────┬────────┘
            │                                     │
            ▼                          ┌──────────┼──────────┐
   ┌─────────────────┐                 ▼          ▼          ▼
   │   Trang chủ     │          Email+Pass   Mã nhóm    Đăng ký
   └─────────────────┘                 │          │          │
                                       └──────────┴──────────┘
                                                  │
                                       ┌──────────┴──────────┐
                                       ▼                     ▼
                                  Thành công              Thất bại
                                       │                     │
                                       ▼                     ▼
                               ┌─────────────┐        Hiện lỗi,
                               │  Trang chủ  │        thử lại
                               └─────────────┘
```

---

### 14.2. Luồng gửi SOS

```
              ┌─────────────────────────────────┐
              │          Trang chủ              │
              └────────────────┬────────────────┘
                               │
         ┌─────────────────────┼─────────────────────┐
         ▼                     ▼                     ▼
    Bấm nút SOS          Lắc 2 lần              Âm lượng
         │               (Shake)               3 lần
         │                     │                     │
         ▼                     └──────────┬──────────┘
  ┌─────────────┐                         ▼
  │  Form SOS   │             ┌────────────────────┐
  │ (ảnh, mô tả)│             │ Dialog xác nhận    │
  └──────┬──────┘             │ (5 giây tự gửi)    │
         │                    └─────────┬──────────┘
         │                             │
         │                    ┌────────┴────────┐
         │                    ▼                 ▼
         │               Gửi ngay           Hủy bỏ
         │                    │
         └────────────────────┘
                              │
                              ▼
               ┌──────────────────────────┐
               │     Gửi báo cáo SOS      │
               ├──────────────────────────┤
               │ ✓ Lên server (dashboard) │
               │ ✓ Email danh bạ          │
               │ ✓ Kèm vị trí GPS         │
               │ ✓ Kèm ghi âm (SOS nhanh)│
               └──────────────────────────┘
```

---

### 14.3. Luồng Admin quản lý

```
┌─────────────────────────────────────────────────┐
│                  Admin Dashboard                │
└────────────────────────┬────────────────────────┘
                         │
     ┌───────────────────┼───────────────────┐
     ▼                   ▼                   ▼
Người dùng          Mã nhóm            Báo cáo SOS
     │                   │                   │
  ┌──┴──┐            ┌───┴───┐          ┌────┴────┐
  │Khóa │            │ Tạo   │          │  Xem    │
  │Mở   │            │ Bật   │          │  Xử lý  │
  │Xem  │            │ Tắt   │          └─────────┘
  └──┬──┘            │ Xóa   │
     │               └───┬───┘
     ▼                   ▼
Khóa user → app      Tắt mã nhóm →
user logout          toàn bộ thành
trong 30s            viên logout 30s
```

---

## 15. Câu hỏi thường gặp

**Q: Tắt app rồi mở lại có cần đăng nhập không?**
> Không. App nhớ đăng nhập, mở lại vào thẳng trang chủ (trừ khi bạn bấm Đăng xuất hoặc bị admin khóa).

**Q: SOS có hoạt động khi thu nhỏ app không?**
> Chỉ khi bật **"Bảo vệ chạy nền"** trong Cài đặt. Mặc định tắt để tiết kiệm pin.

**Q: Mã nhóm dùng chung có ổn không?**
> Mỗi cặp (mã nhóm + tên hiển thị) = một tài khoản riêng. Hai người cùng dùng một tên trên một mã nhóm sẽ dùng chung tài khoản đó — nên khuyến khích mỗi người dùng tên riêng.

**Q: Admin khóa tài khoản thì app báo gì?**
> App tự đăng xuất và quay về màn hình đăng nhập. Thử đăng nhập lại sẽ thấy lỗi "Account is disabled".

**Q: Quên mật khẩu làm sao?**
> Hiện tại chưa có tính năng tự đặt lại mật khẩu. Liên hệ admin để được hỗ trợ.

**Q: App có hỗ trợ iPhone không?**
> Hiện tại chỉ hỗ trợ **Android**. iOS đang trong kế hoạch phát triển.

**Q: Dữ liệu SOS lưu ở đâu?**
> Lưu trên **Railway cloud server** và trên thiết bị cục bộ. Admin có thể xem qua Dashboard.

---

## Thông tin liên hệ hỗ trợ

| | |
|-|-|
| **Tổ chức** | FPT University Cần Thơ |
| **Ứng dụng** | SAFE GUARD v2.0 |
| **Nền tảng backend** | Railway Cloud |
| **Admin Dashboard** | Truy cập URL backend được cung cấp |

---

*Tài liệu này dành cho người dùng cuối và đối tác. Cập nhật lần cuối: 02/2026.*
