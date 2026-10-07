# App icon

The shared artwork is `assets/AppIcon-master.png`, generated with the built-in image_gen tool.

Final prompt:

> Use case: logo-brand. Asset type: production app icon master for MovieFX Player, an iOS and macOS video player with MetalFX upscaling. Create a polished minimal premium icon: one large luminous metallic play triangle pointing right, with a subtle cyan-to-blue prismatic edge and a tiny four-point sharpening sparkle at its upper-right. Deep midnight navy full-bleed square background with restrained smooth gradient, soft dimensional lighting. Strong simple silhouette readable at 16 pixels. Centered generous safe margins, triangle occupies about 52% canvas width. Front view, elegant Apple-platform aesthetic. Output exactly square 1024x1024. Background extends to all four edges, no rounded outer corners, no border, no exterior padding, no words, no letters, no watermark, no mockup.

Regenerate platform sizes from the master at the repository root:

```sh
swift scripts/generate-icons.swift
iconutil -c icns macos/AppIcon.iconset -o Sources/MovieFXPlayer/Resources/AppIcon.icns
```

The iOS catalog includes opaque PNGs for iPhone, iPad, Spotlight, Settings, and the App Store (1024 × 1024). The target selects `AppIcon`; both the checked-in Xcode project and XcodeGen configuration include it. System rounding is applied by iOS.

The macOS iconset includes 16, 32, 128, 256, and 512 point representations at 1× and 2×. The artwork has rounded corners and transparent outer margins for macOS. Swift Package Manager copies the ICNS resource; `AppDelegate` uses it as the Dock icon, including when launched with `swift run`.

Create a Finder-launchable macOS app with its bundle icon:

```sh
scripts/build-macos-app.sh
open '.build/app/MovieFX Player.app'
```

The script builds the current sources, copies package resources and `macos/Info.plist`, and signs the app locally with an ad hoc signature. Distribution signing and notarization require a Developer ID.

Apple reference: [Configuring your app icon using an asset catalog](https://developer.apple.com/documentation/xcode/configuring-your-app-icon).
