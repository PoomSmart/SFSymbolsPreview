# SFSymbolsPreview

Fork of [Lessica/SFSymbolsPreview](https://github.com/Lessica/SFSymbolsPreview) (from [MORECATS/SFSymbolsPreview](https://github.com/MORECATS/SFSymbolsPreview)). Used to preview SF Symbols on device.

SF Symbols iOS app: free and open source, inspired by [Adaptivity](https://apps.apple.com/app/id1054670022?platform=iphone).

## This fork

- Bundle ID `com.ps.SFSymbolsPreview` for side-by-side installs with the App Store build.
- `SFSYMBOLS_BACKPORT_PREVIEW` lists every symbol and variant in the catalog on iOS, even when metadata says the name needs a newer OS. Availability strings in symbol details are unchanged.
- CocoaPods pulls [Lessica/XUI](https://github.com/Lessica/XUI.git) from GitHub instead of a sibling `../XUI` checkout.
- Symbol metadata under `SFSymbolsPreview/Resources/` is refreshed from Apple's SF Symbols app via `DevKit/generate_resources.py` when you update the catalog.

## Build

```sh
pod install
open SFSymbolsPreview.xcworkspace
```

Archive or run from Xcode. For unsigned `.tipa` packages:

```sh
./compile.sh
```

`compile.sh` archives for device (`iphoneos`). Xcode must have the **iOS device platform** installed (Settings → Platforms). A Simulator runtime download does not satisfy that. Install the iOS entry that includes device support from the Platforms tab.

Optional: [xcbeautify](https://github.com/cpisciotta/xcbeautify) for shorter build logs (`brew install xcbeautify`). The Sileo-style package uses LZMA inside the zip. Install [p7zip](https://github.com/ip7z/p7zip) so `7zz` or `7z` is available (`brew install p7zip`).

Outputs land in `packages/` (`SFSymbolsPreview.tipa` and `SFSymbolsPreview_Havoc.tipa`).

## Why?

SF Symbols are free to use, but why [Adaptivity](https://apps.apple.com/app/id1054670022?platform=iphone) costs **$7.99**?

## Screenshot

![ScreenshotPreview](Images/SFSymbol-Screenshot-Preview.png)
