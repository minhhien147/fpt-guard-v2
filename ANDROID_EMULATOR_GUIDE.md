# 📱 Hướng Dẫn Chạy Giả Lập Android

> Hướng dẫn chi tiết cách tạo và chạy Android Emulator để test FPT Guard 2.0

---

## 📋 Mục lục

1. [Cài đặt Android Studio](#-cài-đặt-android-studio)
2. [Tạo Android Emulator mới](#-tạo-android-emulator-mới)
3. [Khởi động Emulator](#-khởi-động-emulator)
4. [Chạy app trên Emulator](#-chạy-app-trên-emulator)
5. [Tối ưu hiệu suất](#-tối-ưu-hiệu-suất)
6. [Giải quyết lỗi thường gặp](#-giải-quyết-lỗi-thường-gặp)
7. [Tips & Tricks](#-tips--tricks)

---

## 🛠️ Cài đặt Android Studio

### Windows

#### Bước 1: Tải Android Studio

1. Truy cập: https://developer.android.com/studio
2. Click **Download Android Studio**
3. Chấp nhận Terms and Conditions
4. Click **Download Android Studio for Windows**

#### Bước 2: Cài đặt Android Studio

```powershell
# 1. Chạy file android-studio-xxx.exe
# 2. Click "Next" để bắt đầu
# 3. Chọn components để cài:
#    ✅ Android Studio
#    ✅ Android Virtual Device (AVD) - QUAN TRỌNG!
# 4. Click "Next"
# 5. Chọn thư mục cài đặt (mặc định: C:\Program Files\Android\Android Studio)
# 6. Click "Install"
# 7. Đợi cài đặt (5-10 phút)
# 8. Click "Finish"
```

#### Bước 3: Setup lần đầu

```
1. Mở Android Studio
2. "Import Android Studio Settings" → Chọn "Do not import settings"
3. Click "OK"
4. Welcome Screen → Click "Next"

5. Install Type:
   ○ Standard (Khuyên dùng - đầy đủ tính năng)
   ○ Custom
   Chọn "Standard" → Click "Next"

6. Select UI Theme:
   ○ Light (Sáng)
   ● Darcula (Tối - khuyên dùng cho mắt)
   Click "Next"

7. Verify Settings:
   - SDK Folder: C:\Users\YourName\AppData\Local\Android\Sdk
   - Emulator Settings
   Click "Next"

8. License Agreement:
   ✅ Accept cho tất cả licenses
   Click "Finish"

9. Downloading Components... (10-20 phút)
   - Android SDK Platform
   - Android SDK Build-Tools
   - Android Emulator
   - Android SDK Platform-Tools
   Đợi tải xong → Click "Finish"
```

### macOS

```bash
# Cách 1: Download từ website
# https://developer.android.com/studio

# Cách 2: Dùng Homebrew (Nhanh hơn)
brew install --cask android-studio

# Mở Android Studio
open -a "Android Studio"

# Làm theo setup wizard tương tự Windows
```

### Linux (Ubuntu/Debian)

```bash
# 1. Tải Android Studio
wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.x.x.x/android-studio-2023.x.x.x-linux.tar.gz

# 2. Giải nén
sudo tar -xzf android-studio-*-linux.tar.gz -C /opt/

# 3. Chạy setup
cd /opt/android-studio/bin
./studio.sh

# 4. Làm theo setup wizard
```

---

## 🎮 Tạo Android Emulator mới

### Cách 1: Qua Android Studio (Khuyên dùng)

#### Bước 1: Mở AVD Manager

```
1. Mở Android Studio
2. Click "More Actions" (3 chấm dọc)
3. Chọn "Virtual Device Manager"

HOẶC:

Top menu → Tools → Device Manager
```

#### Bước 2: Tạo Virtual Device

```
1. Click "Create Device" (hoặc nút + nếu đã có device)

2. Select Hardware:
   Category: Phone
   
   Khuyên dùng:
   ● Pixel 6 Pro (6.7", 1440 x 3120, 512 PPI)
   ● Pixel 5 (6.0", 1080 x 2340, 432 PPI)
   ● Pixel 4 (5.7", 1080 x 2280, 444 PPI)
   
   Chọn một device → Click "Next"

3. System Image (Android Version):
   
   Tab "Recommended":
   
   📌 API 33 (Android 13.0 "Tiramisu") - Khuyên dùng
      Target: Google APIs (Google Play)
      ABI: x86_64
      
   Hoặc:
   
   📌 API 34 (Android 14.0 "UpsideDownCake") - Mới nhất
      Target: Google APIs (Google Play)
      ABI: x86_64
   
   Nếu chưa tải:
   - Click "Download" bên cạnh version
   - Đợi tải xong (1-2GB)
   - Click "Finish"
   
   Chọn version đã tải → Click "Next"

4. Android Virtual Device (AVD):
   
   AVD Name: Pixel_6_Pro_API_33 (hoặc tên bạn muốn)
   
   Startup orientation:
   ● Portrait (Dọc)
   ○ Landscape (Ngang)
   
   Advanced Settings (Click "Show Advanced Settings"):
   
   Camera:
   - Front: Webcam0 (dùng webcam máy tính)
   - Back: VirtualScene (cảnh ảo)
   
   Network:
   - Speed: Full (không giới hạn)
   - Latency: None
   
   Memory and Storage:
   - RAM: 2048 MB (Tối thiểu)
          4096 MB (Khuyên dùng - Mượt hơn)
   - VM heap: 256 MB
   - Internal Storage: 2048 MB
   - SD card: 512 MB
   
   Graphics:
   ● Hardware - GLES 2.0 (Nhanh nhất - Khuyên dùng)
   ○ Software - GLES 2.0
   ○ Automatic
   
   Boot option:
   ● Cold boot (Boot bình thường)
   ○ Quick boot (Boot nhanh - lưu snapshot)
   
   Click "Finish"
```

### Cách 2: Qua Command Line

```bash
# 1. Liệt kê system images có sẵ
sdkmanager --list | grep system-images

# 2. Tải system image
sdkmanager "system-images;android-33;google_apis;x86_64"

# 3. Tạo AVD
avdmanager create avd -n Pixel_6_Pro_API_33 \
  -k "system-images;android-33;google_apis;x86_64" \
  -d "pixel_6_pro"

# 4. Xem danh sách AVD
emulator -list-avds
```

---

## ▶️ Khởi động Emulator

### Cách 1: Qua Android Studio (Đơn giản nhất)

```
1. Mở Android Studio
2. Tools → Device Manager
3. Tìm emulator đã tạo trong danh sách
4. Click nút ▶️ (Play) bên cạnh tên device
5. Đợi emulator khởi động (30-60 giây lần đầu)
```

### Cách 2: Qua Flutter Command

```bash
# 1. Xem danh sách emulator có sẵn
flutter emulators

# Output:
# 2 available emulators:
# 
# Pixel_6_Pro_API_33 • Pixel 6 Pro API 33 • Google • android
# Pixel_5_API_34     • Pixel 5 API 34     • Google • android

# 2. Khởi động emulator cụ thể
flutter emulators --launch Pixel_6_Pro_API_33

# 3. Emulator sẽ tự động mở
```

### Cách 3: Qua Command Line (Advanced)

```bash
# Windows (PowerShell)
$env:ANDROID_HOME = "C:\Users\YourName\AppData\Local\Android\Sdk"
& "$env:ANDROID_HOME\emulator\emulator.exe" -avd Pixel_6_Pro_API_33

# macOS/Linux
export ANDROID_HOME=$HOME/Library/Android/sdk  # macOS
export ANDROID_HOME=$HOME/Android/Sdk          # Linux
$ANDROID_HOME/emulator/emulator -avd Pixel_6_Pro_API_33

# Với options nâng cao
emulator -avd Pixel_6_Pro_API_33 \
  -memory 4096 \
  -cores 4 \
  -gpu host \
  -no-snapshot-load
```

### Kiểm tra Emulator đã sẵn sàng

```bash
# Kiểm tra device đã kết nối
adb devices

# Output mong muốn:
# List of devices attached
# emulator-5554    device

# Nếu thấy "device" → ✅ Emulator sẵn sàng
# Nếu thấy "offline" → ⏳ Đợi thêm
```

---

## 🚀 Chạy app trên Emulator

### Bước 1: Đảm bảo Backend đang chạy

```bash
# Terminal 1 - Backend
cd backend-python
python app.py

# Phải thấy:
# * Running on http://127.0.0.1:5000
```

### Bước 2: Đảm bảo Emulator đang chạy

```bash
# Kiểm tra
flutter devices

# Output mong muốn:
# sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64 • Android 13 (API 33)
```

### Bước 3: Chạy app

```bash
# Terminal 2 - Flutter App
cd E:\fpt-guard-v2

# Cài đặt dependencies (lần đầu)
flutter pub get
flutter gen-l10n

# Chạy app
flutter run

# Hoặc chỉ định emulator cụ thể
flutter run -d emulator-5554
```

### Bước 4: Đợi build

```
Lần đầu tiên:
- Build sẽ mất 5-10 phút
- Gradle sẽ tải dependencies
- Đừng tắt terminal!

Các lần sau:
- Chỉ mất 10-30 giây
- Hot reload sẽ nhanh hơn
```

### Bước 5: Xem app chạy

```
Khi thấy:
✓ Built build\app\outputs\flutter-apk\app.apk.
Installing build\app\outputs\flutter-apk\app.apk...
✓ Installed app (XX.Xs)

→ App sẽ tự động mở trên emulator! 🎉
```

---

## ⚡ Tối ưu hiệu suất

### 1. Bật Hardware Acceleration

#### Windows - Intel HAXM

```powershell
# Kiểm tra CPU hỗ trợ virtualization
systeminfo | findstr /i "virtualization"
# Phải thấy: "Enabled" hoặc "Firmware Enabled"

# Nếu chưa bật:
# 1. Restart máy
# 2. Vào BIOS (F2, F10, hoặc Del khi khởi động)
# 3. Tìm "Virtualization Technology" hoặc "Intel VT-x"
# 4. Enable nó
# 5. Save & Exit

# Cài Intel HAXM:
# 1. Vào Android Studio
# 2. Tools → SDK Manager → SDK Tools
# 3. ✅ Tick "Intel x86 Emulator Accelerator (HAXM installer)"
# 4. Click Apply
# 5. Sau đó chạy:
C:\Users\YourName\AppData\Local\Android\Sdk\extras\intel\Hardware_Accelerated_Execution_Manager\intelhaxm-android.exe
```

#### Windows - Hyper-V (Windows 10/11 Pro)

```powershell
# Enable Hyper-V
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

# Restart máy
```

#### macOS

```bash
# macOS tự động dùng Hypervisor.framework
# Không cần cài thêm gì
```

#### Linux - KVM

```bash
# Check hỗ trợ KVM
egrep -c '(vmx|svm)' /proc/cpuinfo
# Nếu > 0 → Hỗ trợ

# Cài KVM
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

# Add user vào group
sudo usermod -aG kvm $USER
sudo usermod -aG libvirt $USER

# Logout và login lại
```

### 2. Tăng RAM cho Emulator

```bash
# Khi tạo AVD, set RAM cao hơn:
# RAM: 4096 MB (4GB) - Khuyên dùng
# RAM: 6144 MB (6GB) - Nếu máy có 16GB+

# Hoặc edit config:
# Windows: C:\Users\YourName\.android\avd\Pixel_6_Pro_API_33.avd\config.ini
# macOS: ~/.android/avd/Pixel_6_Pro_API_33.avd/config.ini

# Thêm/sửa dòng:
hw.ramSize=4096
vm.heapSize=256
```

### 3. Giảm độ phân giải

```
Thay vì Pixel 6 Pro (1440x3120):
→ Dùng Pixel 5 (1080x2340)
→ Hoặc Pixel 4 (1080x2280)

Giảm 30-40% tải CPU/GPU!
```

### 4. Tắt Animation

```
Trong Emulator:
1. Settings → About emulated device
2. Tap "Build number" 7 lần
3. Quay lại → Developer options
4. Tìm "Window animation scale" → OFF
5. Tìm "Transition animation scale" → OFF
6. Tìm "Animator duration scale" → OFF
```

### 5. Use Quick Boot

```
AVD Manager → Edit Device → Show Advanced Settings:
Boot option: ● Quick boot
```

---

## 🔧 Giải quyết lỗi thường gặp

### Lỗi 1: Emulator không khởi động

```
Error: The emulator process for AVD was killed.
```

**Giải pháp:**

```bash
# 1. Xóa lock files
# Windows:
del C:\Users\YourName\.android\avd\*.lock

# macOS/Linux:
rm ~/.android/avd/*.lock

# 2. Cold boot
emulator -avd Pixel_6_Pro_API_33 -no-snapshot-load

# 3. Tăng timeout
emulator -avd Pixel_6_Pro_API_33 -boot-timeout 300
```

### Lỗi 2: Emulator chạy rất chậm

```
Emulator: WARNING: Running on slow storage...
```

**Giải pháp:**

```bash
# 1. Đảm bảo HAXM/KVM đã cài
# 2. Giảm RAM nếu máy yếu: 2048 MB
# 3. Dùng Graphics: Hardware
# 4. Tắt animations trong emulator
# 5. Đóng các app khác khi chạy emulator
```

### Lỗi 3: adb không nhìn thấy emulator

```bash
adb devices
# List of devices attached
# (empty)
```

**Giải pháp:**

```bash
# 1. Restart ADB
adb kill-server
adb start-server

# 2. Đợi 5 giây, check lại
adb devices

# 3. Nếu vẫn không thấy, restart emulator
```

### Lỗi 4: Không thể kết nối Internet trong Emulator

**Giải pháp:**

```bash
# 1. Check emulator settings
# AVD Manager → Edit → Show Advanced Settings
# Network: Speed = Full, Latency = None

# 2. Trong emulator, test:
# Settings → Network & Internet → Internet
# Phải thấy "VirtWifi" connected

# 3. Nếu không có Internet, restart emulator với:
emulator -avd Pixel_6_Pro_API_33 -dns-server 8.8.8.8
```

### Lỗi 5: Google Play Services không hoạt động

```
Error: Google Play Services is not available
```

**Giải pháp:**

```
1. Xóa AVD cũ
2. Tạo AVD mới với:
   - System Image: "Google APIs" (có Google Play)
   - KHÔNG chọn "Google APIs (No Google Play)"

3. Sau khi emulator khởi động:
   - Vào Play Store
   - Sign in với Google account
   - Update Play Services
```

### Lỗi 6: Emulator bị đen màn hình

**Giải pháp:**

```bash
# 1. Thử đổi Graphics mode
# AVD Manager → Edit → Graphics:
# Software - GLES 2.0

# 2. Hoặc chạy với:
emulator -avd Pixel_6_Pro_API_33 -gpu swiftshader_indirect

# 3. Update driver card màn hình
```

### Lỗi 7: HAXM không cài được (Windows)

```
Error: Intel HAXM installation failed
```

**Giải pháp:**

```powershell
# 1. Disable Hyper-V (nếu đang bật)
bcdedit /set hypervisorlaunchtype off
# Restart máy

# 2. Vào BIOS, enable Intel VT-x

# 3. Cài lại HAXM từ:
# https://github.com/intel/haxm/releases

# 4. Hoặc dùng Hyper-V thay HAXM:
# Tools → SDK Manager → SDK Tools
# ✅ Android Emulator Hypervisor Driver for AMD Processors
```

### Lỗi 8: Không đủ dung lượng ổ đĩa

```
Error: Not enough space to create AVD
```

**Giải pháp:**

```
1. Dọn dẹp disk:
   - Xóa emulator cũ không dùng
   - Xóa system images cũ
   - Dọn Temp files

2. Di chuyển Android SDK sang ổ khác:
   - Tools → SDK Manager
   - Click "Edit" bên cạnh SDK Location
   - Chọn ổ đĩa có nhiều dung lượng
   - Click "Next" → Di chuyển

3. Giảm Internal Storage khi tạo AVD:
   - 2048 MB thay vì 6144 MB
```

---

## 💡 Tips & Tricks

### 1. Shortcuts hữu ích trong Emulator

```
Ctrl + M (Cmd + M macOS)  - Menu
Ctrl + H (Cmd + H)        - Home
Ctrl + B (Cmd + B)        - Back
Ctrl + P (Cmd + P)        - Power (On/Off)
Ctrl + K (Cmd + K)        - Keyboard (Show/Hide)
Ctrl + L (Cmd + L)        - Rotate (Portrait/Landscape)
Ctrl + Z (Cmd + Z)        - Recent Apps
Ctrl + F (Cmd + F)        - Fullscreen
```

### 2. Chụp ảnh màn hình Emulator

```bash
# Qua ADB
adb shell screencap /sdcard/screenshot.png
adb pull /sdcard/screenshot.png

# Hoặc trong Emulator:
# Sidebar → Camera icon (Screenshot)
```

### 3. Record video Emulator

```bash
# Start recording
adb shell screenrecord /sdcard/demo.mp4

# Stop recording (Ctrl + C)
# Pull video
adb pull /sdcard/demo.mp4
```

### 4. Cài APK trực tiếp vào Emulator

```bash
# Kéo thả file APK vào emulator
# Hoặc:
adb install path/to/app.apk

# Gỡ cài đặt:
adb uninstall com.example.app
```

### 5. Debug GPS trong Emulator

```
1. Sidebar → Extended controls (... icon)
2. Location
3. Chọn một trong các tab:
   - Single points: Nhập lat/long thủ công
   - Routes: Tạo đường đi
   - GPX/KML file: Import file
4. Click "Set Location"

Test với FPT Guard:
- Lat: 10.0297 (FPT University Cần Thơ)
- Lon: 105.7701
```

### 6. Chạy nhiều Emulator cùng lúc

```bash
# Terminal 1
emulator -avd Pixel_6_Pro_API_33 &

# Terminal 2
emulator -avd Pixel_5_API_34 &

# Check
adb devices
# emulator-5554    device
# emulator-5556    device

# Chạy app trên emulator cụ thể
flutter run -d emulator-5554
```

### 7. Xóa dữ liệu Emulator (Factory Reset)

```bash
# Qua AVD Manager
# Click dropdown (▼) → Wipe Data

# Hoặc command:
emulator -avd Pixel_6_Pro_API_33 -wipe-data
```

### 8. Export/Import Emulator

```bash
# Backup AVD
# Copy folder:
# Windows: C:\Users\YourName\.android\avd\Pixel_6_Pro_API_33.avd
# macOS: ~/.android/avd/Pixel_6_Pro_API_33.avd

# Restore: Paste folder vào cùng vị trí
```

### 9. Đổi IP Backend khi dùng Emulator

```env
# File .env

# Emulator có thể dùng:
API_BASE_URL=http://10.0.2.2:5000

# 10.0.2.2 = localhost của máy host từ emulator
```

### 10. Tăng tốc build lần đầu

```bash
# Trong android/gradle.properties, thêm:
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.configureondemand=true
org.gradle.jvmargs=-Xmx4096m -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8
```

---

## 📊 So sánh cấu hình Emulator

| Cấu hình | RAM máy | RAM AVD | Device | Graphics | Tốc độ |
|----------|---------|---------|--------|----------|--------|
| **Tối thiểu** | 8GB | 2048 MB | Pixel 4 | Software | Chậm |
| **Khuyên dùng** | 16GB | 4096 MB | Pixel 5 | Hardware | Trung bình |
| **Tối ưu** | 32GB | 6144 MB | Pixel 6 Pro | Hardware | Nhanh |

---

## ✅ Checklist Setup Emulator

- [ ] Đã cài Android Studio
- [ ] Đã cài Android SDK (API 33+)
- [ ] Đã bật Hardware Acceleration (HAXM/Hyper-V/KVM)
- [ ] Đã tạo AVD với Google APIs
- [ ] RAM AVD >= 4GB (nếu máy cho phép)
- [ ] Graphics mode = Hardware
- [ ] Đã test emulator khởi động thành công
- [ ] `adb devices` hiển thị emulator
- [ ] `flutter devices` hiển thị emulator
- [ ] Đã test chạy app: `flutter run`
- [ ] App hiển thị đúng trên emulator
- [ ] GPS hoạt động trong app
- [ ] Backend kết nối thành công

---

## 🎥 Video hướng dẫn

### YouTube Tutorials (Tiếng Việt)

1. **Cài đặt Android Studio**: [Link video]
2. **Tạo Android Emulator**: [Link video]
3. **Chạy Flutter app trên Emulator**: [Link video]
4. **Tối ưu hiệu suất Emulator**: [Link video]

---

## 🚀 Quick Commands Cheat Sheet

```bash
# ===== EMULATOR =====
# Xem danh sách emulator
flutter emulators

# Khởi động emulator
flutter emulators --launch <name>

# Khởi động với options
emulator -avd <name> -memory 4096 -cores 4

# ===== ADB =====
# Xem devices
adb devices

# Restart ADB
adb kill-server && adb start-server

# Cài APK
adb install app.apk

# Gỡ app
adb uninstall com.example.app

# Screenshot
adb shell screencap /sdcard/screen.png
adb pull /sdcard/screen.png

# Record video (Ctrl+C để stop)
adb shell screenrecord /sdcard/demo.mp4
adb pull /sdcard/demo.mp4

# Xem logs
adb logcat

# ===== FLUTTER =====
# Xem devices
flutter devices

# Chạy app
flutter run

# Chạy trên device cụ thể
flutter run -d emulator-5554

# Hot reload
r (trong console đang chạy app)

# Hot restart
R (trong console đang chạy app)

# Xem logs
flutter logs
```

---

## 📞 Hỗ trợ

Nếu vẫn gặp vấn đề:

1. **Stack Overflow**: [android-emulator tag](https://stackoverflow.com/questions/tagged/android-emulator)
2. **Flutter Discord**: [flutter.dev/community](https://flutter.dev/community)
3. **GitHub Issues**: [Repo Issues](https://github.com/your-username/fpt-guard-v2/issues)

---

## 🎉 Kết luận

Bây giờ bạn đã biết:
- ✅ Cài đặt Android Studio
- ✅ Tạo Android Emulator
- ✅ Khởi động và sử dụng Emulator
- ✅ Chạy app FPT Guard trên Emulator
- ✅ Tối ưu hiệu suất
- ✅ Giải quyết các lỗi thường gặp
- ✅ Tips & tricks hữu ích

**Happy coding!** 🚀

---

<div align="center">

**Made with ❤️ by FPT University Can Tho**

[⬆ Back to top](#-hướng-dẫn-chạy-giả-lập-android)

</div>
