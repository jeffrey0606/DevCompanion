import 'package:devcompanion/helpers/enums.dart';
import 'package:devcompanion/models/device_info.dart';
import 'package:devcompanion/models/logo_models.dart';
import 'package:devcompanion/models/nav_bar_pages_icon_model.dart';
import 'package:devcompanion/models/projects_tech_model.dart';
import 'package:path/path.dart' as path;

List<ProjectsTechModel> techs = [
  ProjectsTechModel(
    asset: "assets/images/flutter_logo.png",
    type: ProjectsTechType.flutter,
    dimension: "192x192",
    size: 14000,
  ),
  ProjectsTechModel(
    asset: "assets/images/swift_logo.png",
    type: ProjectsTechType.swift,
    size: 17500,
    dimension: "512x512",
  ),
  ProjectsTechModel(
    asset: "assets/images/android_logo.png",
    type: ProjectsTechType.android,
    size: 12500,
    dimension: "512x512",
  ),
  ProjectsTechModel(
    asset: "assets/images/web_logo.png",
    type: ProjectsTechType.web,
    size: 30200,
    dimension: "512x512",
  ),
];

late DeviceInfo deviceInfo;

const List<NavBarPagesIconModel> navBarPagesIcon = [
  NavBarPagesIconModel(
    asset: "assets/svgs/overview.svg",
    page: NavBarPages.overview,
  ),
  NavBarPagesIconModel(
    asset: "assets/svgs/assets.svg",
    page: NavBarPages.assets,
  ),
  NavBarPagesIconModel(
    asset: "assets/svgs/color_picker.svg",
    page: NavBarPages.colorPicker,
  ),
  NavBarPagesIconModel(
    asset: "assets/svgs/preview.svg",
    page: NavBarPages.preview,
  ),
];

final LogoVarientModel linuxLogoVarient = LogoVarientModel(
  contentJson: {
    "images": [
      {
        "size": "1024x1024",
        "filename": "",
      },
    ],
    "info": {"version": 1, "author": "DevAssets"}
  },
  path: path.join(
    "debian",
    "gui",
  ),
  projectPlatform: ProjectPlatform.linux,
  altPath: path.join(
    "snap",
    "gui",
  ),
);

final LogoVarientModel windowsLogoVarient = LogoVarientModel(
  contentJson: {
    "images": [
      {
        "size": "48x48",
        "filename": "app_icon.ico",
      },
    ],
    "info": {"version": 1, "author": "DevAssets"}
  },
  path: path.join(
    "windows",
    "runner",
    "resources",
  ),
  projectPlatform: ProjectPlatform.windows,
);

final LogoVarientModel macosLogoVarient = LogoVarientModel(
  contentJson: {
    "images": [
      {
        "size": "16x16",
        "idiom": "mac",
        "filename": "app_icon_16.png",
        "scale": "1x"
      },
      {
        "size": "16x16",
        "idiom": "mac",
        "filename": "app_icon_32.png",
        "scale": "2x"
      },
      {
        "size": "32x32",
        "idiom": "mac",
        "filename": "app_icon_32.png",
        "scale": "1x"
      },
      {
        "size": "32x32",
        "idiom": "mac",
        "filename": "app_icon_64.png",
        "scale": "2x"
      },
      {
        "size": "128x128",
        "idiom": "mac",
        "filename": "app_icon_128.png",
        "scale": "1x"
      },
      {
        "size": "128x128",
        "idiom": "mac",
        "filename": "app_icon_256.png",
        "scale": "2x"
      },
      {
        "size": "256x256",
        "idiom": "mac",
        "filename": "app_icon_256.png",
        "scale": "1x"
      },
      {
        "size": "256x256",
        "idiom": "mac",
        "filename": "app_icon_512.png",
        "scale": "2x"
      },
      {
        "size": "512x512",
        "idiom": "mac",
        "filename": "app_icon_512.png",
        "scale": "1x"
      },
      {
        "size": "512x512",
        "idiom": "mac",
        "filename": "app_icon_1024.png",
        "scale": "2x"
      }
    ],
    "info": {"version": 1, "author": "xcode"}
  },
  path: path.join(
    "macos",
    "Runner",
    "Assets.xcassets",
    "AppIcon.appiconset",
  ),
  projectPlatform: ProjectPlatform.macos,
);

final LogoVarientModel iosLogoVarient = LogoVarientModel(
  contentJson: {
    "images": [
      {
        "size": "20x20",
        "idiom": "iphone",
        "filename": "Icon-App-20x20@2x.png",
        "scale": "2x"
      },
      {
        "size": "20x20",
        "idiom": "iphone",
        "filename": "Icon-App-20x20@3x.png",
        "scale": "3x"
      },
      {
        "size": "29x29",
        "idiom": "iphone",
        "filename": "Icon-App-29x29@1x.png",
        "scale": "1x"
      },
      {
        "size": "29x29",
        "idiom": "iphone",
        "filename": "Icon-App-29x29@2x.png",
        "scale": "2x"
      },
      {
        "size": "29x29",
        "idiom": "iphone",
        "filename": "Icon-App-29x29@3x.png",
        "scale": "3x"
      },
      {
        "size": "40x40",
        "idiom": "iphone",
        "filename": "Icon-App-40x40@2x.png",
        "scale": "2x"
      },
      {
        "size": "40x40",
        "idiom": "iphone",
        "filename": "Icon-App-40x40@3x.png",
        "scale": "3x"
      },
      {
        "size": "60x60",
        "idiom": "iphone",
        "filename": "Icon-App-60x60@2x.png",
        "scale": "2x"
      },
      {
        "size": "60x60",
        "idiom": "iphone",
        "filename": "Icon-App-60x60@3x.png",
        "scale": "3x"
      },
      {
        "size": "20x20",
        "idiom": "ipad",
        "filename": "Icon-App-20x20@1x.png",
        "scale": "1x"
      },
      {
        "size": "20x20",
        "idiom": "ipad",
        "filename": "Icon-App-20x20@2x.png",
        "scale": "2x"
      },
      {
        "size": "29x29",
        "idiom": "ipad",
        "filename": "Icon-App-29x29@1x.png",
        "scale": "1x"
      },
      {
        "size": "29x29",
        "idiom": "ipad",
        "filename": "Icon-App-29x29@2x.png",
        "scale": "2x"
      },
      {
        "size": "40x40",
        "idiom": "ipad",
        "filename": "Icon-App-40x40@1x.png",
        "scale": "1x"
      },
      {
        "size": "40x40",
        "idiom": "ipad",
        "filename": "Icon-App-40x40@2x.png",
        "scale": "2x"
      },
      {
        "size": "76x76",
        "idiom": "ipad",
        "filename": "Icon-App-76x76@1x.png",
        "scale": "1x"
      },
      {
        "size": "76x76",
        "idiom": "ipad",
        "filename": "Icon-App-76x76@2x.png",
        "scale": "2x"
      },
      {
        "size": "83.5x83.5",
        "idiom": "ipad",
        "filename": "Icon-App-83.5x83.5@2x.png",
        "scale": "2x"
      },
      {
        "size": "1024x1024",
        "idiom": "ios-marketing",
        "filename": "Icon-App-1024x1024@1x.png",
        "scale": "1x"
      }
    ],
    "info": {"version": 1, "author": "xcode"}
  },
  path: path.join(
    "ios",
    "Runner",
    "Assets.xcassets",
    "AppIcon.appiconset",
  ),
  projectPlatform: ProjectPlatform.ios,
);

final LogoVarientModel androidLogoVarient = LogoVarientModel(
  contentJson: {
    "images": [
      {
        "size": "48x48",
        "filename": "ic_launcher.png",
        "alt_filename": "ic_launcher.webp",
        "folder": "mipmap-mdpi",
      },
      {
        "size": "72x72",
        "filename": "ic_launcher.png",
        "alt_filename": "ic_launcher.webp",
        "folder": "mipmap-hdpi",
      },
      {
        "size": "96x96",
        "filename": "ic_launcher.png",
        "alt_filename": "ic_launcher.webp",
        "folder": "mipmap-xhdpi",
      },
      {
        "size": "144x144",
        "filename": "ic_launcher.png",
        "alt_filename": "ic_launcher.webp",
        "folder": "mipmap-xxhdpi",
      },
      {
        "size": "192x192",
        "filename": "ic_launcher.png",
        "alt_filename": "ic_launcher.webp",
        "folder": "mipmap-xxxhdpi",
      },
    ],
    "info": {"version": 1, "author": "DevAssets"}
  },
  path: path.join(
    "app",
    "src",
    "main",
    "res",
  ),
  projectPlatform: ProjectPlatform.android,
);

List<LogoVarientModel> flutterLogoVarients = [
  linuxLogoVarient,
  windowsLogoVarient,
  macosLogoVarient,
  iosLogoVarient,
  androidLogoVarient,
];
