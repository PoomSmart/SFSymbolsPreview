#!/bin/sh

set -e

seven_zip() {
    if command -v 7zz >/dev/null 2>&1; then
        7zz "$@"
    elif command -v 7z >/dev/null 2>&1; then
        7z "$@"
    else
        echo "7zz or 7z not found. Install p7zip (brew install p7zip)." >&2
        exit 1
    fi
}

run_xcodebuild() {
    if command -v xcbeautify >/dev/null 2>&1; then
        xcodebuild "$@" | xcbeautify
    else
        xcodebuild "$@"
    fi
}

require_ios_device_platform() {
    destinations="$(xcodebuild \
        -workspace SFSymbolsPreview.xcworkspace \
        -scheme SFSymbolsPreview \
        -showdestinations 2>&1)" || true
    if printf '%s\n' "$destinations" | grep 'Any iOS Device' | grep -q 'is not installed'; then
        echo "The iOS device platform is not installed in this Xcode." >&2
        echo "Open Xcode → Settings → Platforms and install iOS (device support, not Simulator only)." >&2
        exit 1
    fi
    if ! printf '%s\n' "$destinations" | grep -q 'Available destinations'; then
        echo "No iOS device destination for xcodebuild." >&2
        printf '%s\n' "$destinations" >&2
        exit 1
    fi
}

cd "$(dirname "$0")"

require_ios_device_platform

rm -rf build SFSymbolsPreview.xcarchive || true
mkdir -p build/Payload
mkdir -p packages

run_xcodebuild archive \
    -scheme SFSymbolsPreview \
    -workspace SFSymbolsPreview.xcworkspace \
    -sdk iphoneos \
    -destination 'generic/platform=iOS' \
    -archivePath SFSymbolsPreview \
    CODE_SIGNING_ALLOWED=NO

cd SFSymbolsPreview.xcarchive/Products/Applications
codesign --remove-signature SF\ Symbols.app
cd -
cd SFSymbolsPreview.xcarchive/Products
mv Applications Payload
zip -qr SFSymbolsPreview_Havoc.tipa Payload
seven_zip a -tzip -mm=LZMA SFSymbolsPreview.tipa Payload
cd -
mkdir -p packages

mv SFSymbolsPreview.xcarchive/Products/SFSymbolsPreview_Havoc.tipa packages/SFSymbolsPreview_Havoc.tipa
mv SFSymbolsPreview.xcarchive/Products/SFSymbolsPreview.tipa packages/SFSymbolsPreview.tipa
