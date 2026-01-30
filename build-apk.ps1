# Script build APK cho SAFE GUARD
# Chạy: .\build-apk.ps1

Write-Host "=== SAFE GUARD - APK Builder ===" -ForegroundColor Cyan
Write-Host ""

# Kiểm tra file .env
if (-not (Test-Path ".env")) {
    Write-Host "⚠️  File .env không tồn tại. Tạo file .env? (Y/N)" -ForegroundColor Yellow
    $createEnv = Read-Host
    
    if ($createEnv -eq "Y" -or $createEnv -eq "y") {
        $apiUrl = Read-Host "Nhập API URL (Enter để dùng mặc định: https://web-production-dd806.up.railway.app)"
        
        if ([string]::IsNullOrWhiteSpace($apiUrl)) {
            $apiUrl = "https://web-production-dd806.up.railway.app"
        }
        
        @"
# API Configuration
API_BASE_URL=$apiUrl

# App Configuration
APP_NAME=SAFE GUARD
APP_VERSION=2.0.0
"@ | Out-File -FilePath ".env" -Encoding UTF8
        
        Write-Host "✅ Đã tạo file .env" -ForegroundColor Green
    } else {
        Write-Host "ℹ️  Tiếp tục build mà không có file .env (sẽ dùng config mặc định)" -ForegroundColor Cyan
    }
}

# Clean project
Write-Host ""
Write-Host "🧹 Cleaning project..." -ForegroundColor Yellow
flutter clean

# Get dependencies
Write-Host ""
Write-Host "📦 Getting dependencies..." -ForegroundColor Yellow
flutter pub get

# Build APK
Write-Host ""
Write-Host "Chọn loại build:" -ForegroundColor Cyan
Write-Host "1. Release APK (Universal - 1 file)" 
Write-Host "2. Release APK (Split per ABI - 3 files, nhẹ hơn)"
Write-Host "3. Debug APK"

$choice = Read-Host "Nhập lựa chọn (1/2/3)"

Write-Host ""
switch ($choice) {
    "1" {
        Write-Host "🔨 Building Release APK (Universal)..." -ForegroundColor Yellow
        flutter build apk --release
        $apkPath = "build\app\outputs\flutter-apk\app-release.apk"
    }
    "2" {
        Write-Host "🔨 Building Release APK (Split per ABI)..." -ForegroundColor Yellow
        flutter build apk --split-per-abi --release
        $apkPath = "build\app\outputs\flutter-apk\"
    }
    "3" {
        Write-Host "🔨 Building Debug APK..." -ForegroundColor Yellow
        flutter build apk --debug
        $apkPath = "build\app\outputs\flutter-apk\app-debug.apk"
    }
    default {
        Write-Host "❌ Lựa chọn không hợp lệ!" -ForegroundColor Red
        exit 1
    }
}

# Kiểm tra build thành công
if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Build thành công!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📱 File APK tại: $apkPath" -ForegroundColor Cyan
    
    # Mở thư mục chứa APK
    $openFolder = Read-Host "Mở thư mục chứa APK? (Y/N)"
    if ($openFolder -eq "Y" -or $openFolder -eq "y") {
        explorer "build\app\outputs\flutter-apk\"
    }
} else {
    Write-Host ""
    Write-Host "❌ Build thất bại! Kiểm tra lỗi bên trên." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== Hoàn tất ===" -ForegroundColor Green
