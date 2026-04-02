#!/bin/bash
set -euo pipefail

# M2 Shop - Android Build Script
# Usage:
#   ./build_m2.sh [emulator|device|localhost] [device_id(optional)]

echo "=========================================="
echo "M2 Shop - Building Android APK"
echo "=========================================="
echo ""

PROJECT_DIR="/home/mufutumari/Desktop/projects/m2"
TARGET="${1:-device}"
DEVICE_ID="${2:-}"

cd "$PROJECT_DIR"

echo "📁 Project directory: $PROJECT_DIR"
echo "🎯 Target mode: $TARGET"
echo ""

LOCAL_IP="$(hostname -I 2>/dev/null | awk '{print $1}')"

case "$TARGET" in
  emulator)
    API_HOST="10.0.2.2"
    ;;
  localhost)
    API_HOST="127.0.0.1"
    ;;
  device)
    if [[ -n "${HOST_IP:-}" ]]; then
      API_HOST="$HOST_IP"
    elif [[ -n "$LOCAL_IP" ]]; then
      API_HOST="$LOCAL_IP"
    else
      echo "❌ Could not detect local IP automatically."
      echo "Set HOST_IP manually, e.g. HOST_IP=192.168.1.12 ./build_m2.sh device"
      exit 1
    fi
    ;;
  *)
    echo "❌ Invalid target '$TARGET'. Use: emulator, device, or localhost"
    exit 1
    ;;
esac

API_BASE_URL="http://${API_HOST}:5000/api"
IMAGE_BASE_URL="http://${API_HOST}:5000/uploads"

echo "🔗 API_BASE_URL=$API_BASE_URL"
echo "🖼️  IMAGE_BASE_URL=$IMAGE_BASE_URL"
echo ""

# Step 1: Clean
echo "🧹 Cleaning build directories..."
flutter clean
echo "✅ Clean complete"
echo ""

# Step 2: Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get
echo "✅ Dependencies retrieved"
echo ""

# Step 3: Build APK with runtime URL defines
echo "🔨 Building debug APK..."
echo "This may take 5-15 minutes. Please wait..."
echo ""

flutter build apk --debug \
  --dart-define=API_BASE_URL="$API_BASE_URL" \
  --dart-define=IMAGE_BASE_URL="$IMAGE_BASE_URL"

echo ""
echo "=========================================="
echo "✅ BUILD SUCCESSFUL!"
echo "=========================================="
echo ""
APK_PATH="$PROJECT_DIR/build/app/outputs/flutter-apk/app-debug.apk"
echo "📱 APK Location: $APK_PATH"
echo ""
echo "📝 Next steps:"
echo "1. Connect your phone via USB"
echo "2. Enable USB Debugging on your phone"
if [[ -n "$DEVICE_ID" ]]; then
  echo "3. Install directly: flutter install -d $DEVICE_ID"
else
  echo "3. Install directly (optional): flutter install -d <YOUR_DEVICE_ID>"
fi
echo "4. OR transfer APK to your phone and install manually"
echo ""
