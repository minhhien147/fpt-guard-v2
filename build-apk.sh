#!/bin/bash
# Script build APK cho SAFE GUARD
# Chạy: ./build-apk.sh

echo "=== SAFE GUARD - APK Builder ==="
echo ""

# Kiểm tra file .env
if [ ! -f ".env" ]; then
    echo "⚠️  File .env không tồn tại. Tạo file .env? (y/n)"
    read -r createEnv
    
    if [ "$createEnv" = "y" ] || [ "$createEnv" = "Y" ]; then
        echo "Nhập API URL (Enter để dùng mặc định: https://web-production-dd806.up.railway.app):"
        read -r apiUrl
        
        if [ -z "$apiUrl" ]; then
            apiUrl="https://web-production-dd806.up.railway.app"
        fi
        
        cat > .env << EOF
# API Configuration
API_BASE_URL=$apiUrl

# App Configuration
APP_NAME=SAFE GUARD
APP_VERSION=2.0.0
EOF
        
        echo "✅ Đã tạo file .env"
    else
        echo "ℹ️  Tiếp tục build mà không có file .env (sẽ dùng config mặc định)"
    fi
fi

# Clean project
echo ""
echo "🧹 Cleaning project..."
flutter clean

# Get dependencies
echo ""
echo "📦 Getting dependencies..."
flutter pub get

# Build APK
echo ""
echo "Chọn loại build:"
echo "1. Release APK (Universal - 1 file)"
echo "2. Release APK (Split per ABI - 3 files, nhẹ hơn)"
echo "3. Debug APK"
echo -n "Nhập lựa chọn (1/2/3): "
read -r choice

echo ""
case $choice in
    1)
        echo "🔨 Building Release APK (Universal)..."
        flutter build apk --release
        apkPath="build/app/outputs/flutter-apk/app-release.apk"
        ;;
    2)
        echo "🔨 Building Release APK (Split per ABI)..."
        flutter build apk --split-per-abi --release
        apkPath="build/app/outputs/flutter-apk/"
        ;;
    3)
        echo "🔨 Building Debug APK..."
        flutter build apk --debug
        apkPath="build/app/outputs/flutter-apk/app-debug.apk"
        ;;
    *)
        echo "❌ Lựa chọn không hợp lệ!"
        exit 1
        ;;
esac

# Kiểm tra build thành công
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build thành công!"
    echo ""
    echo "📱 File APK tại: $apkPath"
    
    # Mở thư mục chứa APK (chỉ hoạt động trên macOS/Linux có xdg-open)
    if command -v xdg-open &> /dev/null; then
        echo -n "Mở thư mục chứa APK? (y/n): "
        read -r openFolder
        if [ "$openFolder" = "y" ] || [ "$openFolder" = "Y" ]; then
            xdg-open "build/app/outputs/flutter-apk/"
        fi
    elif command -v open &> /dev/null; then
        echo -n "Mở thư mục chứa APK? (y/n): "
        read -r openFolder
        if [ "$openFolder" = "y" ] || [ "$openFolder" = "Y" ]; then
            open "build/app/outputs/flutter-apk/"
        fi
    fi
else
    echo ""
    echo "❌ Build thất bại! Kiểm tra lỗi bên trên."
    exit 1
fi

echo ""
echo "=== Hoàn tất ==="
