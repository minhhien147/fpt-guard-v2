## So sánh tài khoản FREE vs PRO – SAFE GUARD

Tài liệu này tóm tắt **khác biệt tính năng** giữa 2 gói tài khoản hiện tại trong app.

> Ghi chú:
> - Các thông tin dưới đây bám sát đúng logic đã triển khai trong code (backend + Flutter).
> - Nếu sau này thay đổi giới hạn (ví dụ nâng số SOS/tháng), chỉ cần sửa lại bảng này.

---

### 1. Tổng quan

| Hạng tài khoản | Mục tiêu sử dụng                          |
| -------------- | ------------------------------------------ |
| **FREE**       | Dùng thử, nhu cầu cơ bản, thỉnh thoảng SOS |
| **PRO**        | Bảo vệ chủ động, dùng SOS & theo dõi thường xuyên |

---

### 2. Bảng so sánh chi tiết tính năng

| Nhóm tính năng | FREE | PRO |
| -------------- | ---- | --- |
| **Giới hạn SOS mỗi tháng** | **10 lần / tháng**. Đếm theo **tháng dương lịch**, tự reset đầu tháng (logic: `FREE_SOS_LIMIT = 10`, auto reset trong DB). | **Không giới hạn** (limit = `-1` trong DB). |
| **Gửi email SOS đến danh bạ** | ✅ Có – gửi email với nội dung SOS, vị trí hiện tại, kèm ảnh nếu có. | ✅ Có – như FREE. |
| **Ghi âm tự động khi gửi SOS** | ⛔ **Không** – không tự bật ghi âm nền, chỉ gửi nội dung văn bản/ảnh. | ✅ **Có** – khi mở form SOS, app tự ghi âm nền; khi gửi sẽ dừng ghi và **đính kèm file âm thanh** vào email SOS. |
| **Bảo vệ chạy nền (Foreground service)** | ⛔ Không bật được – khi cố bật sẽ hiện cảnh báo “chỉ dành cho Pro”. | ✅ Có thể bật/tắt trong Cài đặt. Khi bật, app chạy nền ổn định hơn cho các tính năng bảo vệ. |
| **Chia sẻ vị trí thời gian thực (real-time, có link)** | ⛔ Không | ✅ Có – khi bật “Bảo vệ chạy nền”, app tự động ping vị trí mỗi ~60 giây lên server và tạo **link theo dõi vị trí** để gửi cho người thân. |
| **Lịch sử & thống kê SOS** | ⛔ Không truy cập được màn “Lịch sử SOS” (hiện màn khóa Pro). | ✅ Có – xem lại danh sách các lần SOS, thống kê tổng số SOS, số SOS trong tháng, trạng thái FREE/PRO, ngày reset quota… |
| **Khu vực an toàn (Geofence)** | ⛔ Không – màn Geofence bị khóa với tài khoản Free. | ✅ Có – cấu hình “vùng an toàn” (tên, tâm, bán kính). Khi ra khỏi vùng: **hiện cảnh báo trong app + gửi email cảnh báo tới danh bạ có email + tạo SOS report tự động**. |
| **Danh bạ liên hệ khẩn cấp (số người được thêm)** | **Tối đa 3 liên hệ** (nếu thêm hơn sẽ hiện pop-up yêu cầu nâng cấp Pro). | **Không giới hạn**. |
| **Tin tức an ninh (RSS)** | ✅ Có – xem toàn bộ tin tức đã crawl (không giới hạn). | ✅ Như FREE. |
| **Thủy triều / thông tin môi trường (nếu bật)** | ✅ Có | ✅ Có |
| **Đa ngôn ngữ (VI / EN / JP)** | ✅ Có | ✅ Có |

---

### 3. Tóm tắt nhanh cho marketing / màn giới thiệu

- **FREE (miễn phí)**:
  - 10 lần SOS / tháng, reset tự động mỗi đầu tháng.
  - Gửi email SOS cơ bản (không ghi âm tự động).
  - Tối đa 3 liên hệ khẩn cấp.
  - Xem tin tức an ninh, thủy triều, đổi ngôn ngữ.

- **PRO (trả phí)**:
  - SOS **không giới hạn**, luôn ưu tiên xử lý.
  - **Tự động ghi âm hiện trường** khi gửi SOS, đính kèm vào email.
  - **Bảo vệ chạy nền** + **chia sẻ vị trí thời gian thực** bằng link.
  - **Lịch sử & thống kê SOS** chi tiết.
  - **Khu vực an toàn (Geofence)**: ra khỏi vùng → cảnh báo app + email người thân + lưu SOS.
  - Thêm **không giới hạn liên hệ** nhận SOS/email.

---

### 4. Gợi ý chỗ dùng file này

- Dùng làm nguồn dữ liệu để:
  - Viết nội dung màn **“Nâng cấp lên Pro”** trong app.
  - Cập nhật nội dung trên website giới thiệu SAFE GUARD.
  - Trả lời nhanh cho sinh viên/người dùng khi hỏi “Free khác Pro chỗ nào?”.

