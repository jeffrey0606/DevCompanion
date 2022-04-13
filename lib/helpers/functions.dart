import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:devcompanion/helpers/contants.dart';
import 'package:devcompanion/helpers/enums.dart';
import 'package:devcompanion/helpers/exceptions.dart';
import 'package:devcompanion/models/device_info.dart';
import 'package:devcompanion/models/init_params.dart';
import 'package:devcompanion/models/projects_tech_model.dart';
import 'package:devcompanion/providers/logo/logo_provider.dart';
import 'package:devcompanion/providers/project_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:mime_type/mime_type.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path/path.dart' as path;

Future<bool> initAppConfigs(BuildContext context, WidgetRef ref) async {
  try {
    Hive
      ..init(
        await appDataFolderPath(),
      )
      ..registerAdapter(
        ProjectsTechModelAdapter(),
      )
      ..registerAdapter(
        ProjectsTechTypeAdapter(),
      )
      ..registerAdapter(
        ProjectModelAdapter(),
      )
      ..registerAdapter(
        InitParamsAdapter(),
      )
      ..registerAdapter(
        ImageTypeAdapter(),
      );

    // await Hive.deleteBoxFromDisk("initParams");
    // await Hive.deleteBoxFromDisk("techs");
    // await Hive.deleteFromDisk();

    await getDeviceInfo();

    final initParamsBox = await Hive.openBox<InitParams>("initParams");
    var initParams = initParamsBox.get("data") ?? InitParams(isFirstTime: true);
    final _projectProvider = ref.read(projectProvider);

    if (initParams.isFirstTime) {
      await initParamsBox.put("data", initParams);
      final techsBox = await Hive.openBox<ProjectsTechModel>("techs");

      await techsBox.addAll(techs);

      await techsBox.close();

      await _projectProvider.saveInitParams();

      return true;
    } else {
      await _projectProvider.changeProjectTech(
        null,
        init: true,
      );

      if (!_projectProvider.noProjectFound) {
        ref
            .read(logoProvider)
            .initSupportedPlatforms(_projectProvider.currentProject);
      }
    }

    return initParams.isFirstTime;
  } catch (e) {
    log("e: $e");
    throw InitAppConfigsException("error");
  }
}

Future<String> appDataFolderPath() async {
  String configPath = "";
  String packageManager = "deb"; //"deb" or "snap"
  Map<String, String> envVars = Platform.environment;
  bool isDev = false;
  if (Platform.isMacOS) {
    configPath = envVars['HOME']!;
  } else if (Platform.isLinux) {
    // final whoami = await run("whoami");
    // String userName = envVars['USERNAME']!;
    // whoami[0].stdout.toString().trimRight();
    String userPath;
    if (packageManager == "deb") {
      configPath = path.join(
        envVars['HOME']!,
        ".config",
      );
    } else {
      userPath = path.join(
        envVars['HOME']!,
        "snap",
        "whoshares",
        "33",
      );
      configPath = path.join(
        userPath,
        ".whoshares_config",
      );
      final configDir = Directory(configPath);
      if (!(await configDir.exists())) {
        await configDir.create();
      }
    }
  } else if (Platform.isWindows) {
    configPath = path.join(envVars['UserProfile']!, "AppData");
  }

  final directory = Directory(path.join(configPath, "DevCompanion"));
  if (!(await directory.exists())) {
    await directory.create();
  }

  return directory.path;
}

Future<String> saveStuffsDir(String stuffName) async {
  final directory = Directory(
    path.join(
      await appDataFolderPath(),
      stuffName,
    ),
  );
  if (!(await directory.exists())) {
    await directory.create();
  }

  return directory.path;
}

Size fromDimension(String dimension) {
  final size = dimension
      .split("x")
      .map(
        (e) => double.parse(e),
      )
      .toList();
  return Size(size.first, size.last);
}

String toDimension(Size size) {
  return "${size.width.toInt()}x${size.height.toInt()}";
}

Future<void> getDeviceInfo() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  if (Platform.isLinux) {
    LinuxDeviceInfo linuxDeviceInfo = await deviceInfoPlugin.linuxInfo;
    deviceInfo = DeviceInfo(
      hostName: Platform.localHostname,
      osName: linuxDeviceInfo.prettyName,
      platform: getPlatform(),
    );
    log("device info: ${linuxDeviceInfo.toMap()}");
  } else if (Platform.isMacOS) {
    MacOsDeviceInfo macOsDeviceInfo = await deviceInfoPlugin.macOsInfo;
    deviceInfo = DeviceInfo(
      hostName: Platform.localHostname,
      osName: macOsDeviceInfo.computerName + "-" + macOsDeviceInfo.osRelease,
      platform: getPlatform(),
    );
    log("device info: ${macOsDeviceInfo.toMap()}");
  } else if (Platform.isWindows) {
    try {
      WindowsDeviceInfo windowsDeviceInfo = await deviceInfoPlugin.windowsInfo;
      deviceInfo = DeviceInfo(
        hostName: Platform.localHostname,
        osName: windowsDeviceInfo.computerName,
        platform: getPlatform(),
      );
      log("device info: ${windowsDeviceInfo.toMap()}");
    } catch (e) {
      final String osName =
          Platform.operatingSystemVersion.replaceAll("\"", "");
      deviceInfo = DeviceInfo(
        hostName: Platform.localHostname,
        osName: osName,
        platform: getPlatform(),
      );
    }
  }
}

String getPlatform() {
  if (Platform.isLinux) {
    return "Linux";
  } else if (Platform.isMacOS) {
    return "MacOS";
  } else if (Platform.isWindows) {
    return "Windows";
  }
  return "";
}

Future<Size> getImageSize(String asset, ImageType imageType) async {
  late final Image image;
  switch (imageType) {
    case ImageType.asset:
      image = Image.asset(
        asset,
      );
      break;
    case ImageType.file:
      image = Image.file(
        File(asset),
      );
      break;
    case ImageType.network:
      image = Image.network(
        asset,
      );
      break;
    default:
  }
  final Completer<Size> completer = Completer<Size>();
  image.image.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener(
      (ImageInfo image1, bool synchronousCall) {
        final myImage = image1.image;
        final Size size = Size(
          myImage.width.toDouble(),
          myImage.height.toDouble(),
        );
        completer.complete(size);
      },
    ),
  );

  return await completer.future;
}

Future<List<Color>> getImageColors(String asset, ImageType imageType) async {
  late ImageProvider imageProvider;
  switch (imageType) {
    case ImageType.asset:
      imageProvider = AssetImage(
        asset,
      );
      break;
    case ImageType.file:
      imageProvider = FileImage(
        File(asset),
      );
      break;
    case ImageType.network:
      imageProvider = NetworkImage(
        asset,
      );
      break;
    default:
  }

  final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(imageProvider);
  final List<Color> colors = [];
  for (Color color in paletteGenerator.colors.toList()) {
    if (colors.isNotEmpty &&
        getColorHex(colors.first).substring(0, 2) !=
            getColorHex(color).substring(0, 2)) {
      colors.add(color);
      break;
    }

    if (colors.isEmpty) {
      colors.add(color);
    }
  }
  return colors;
}

String getColorHex(Color color) {
  String colorStr = color.toString();
  colorStr = colorStr.replaceFirst("Color(0xff", "");
  colorStr = colorStr.replaceFirst(")", "");

  return colorStr;
}

Future<Size> getSvgImageSize(String asset, ImageType imageType) async {
  late String rawSvg;

  switch (imageType) {
    case ImageType.asset:
      rawSvg = await rootBundle.loadString(asset);
      break;
    case ImageType.file:
      // image = Image.file(
      //   File(asset),
      // );
      break;
    case ImageType.network:
      // image = Image.network(
      //   asset,
      // );
      break;
    default:
  }
  final DrawableRoot svgRoot = await svg.fromSvgString(rawSvg, rawSvg);

// If you only want the final Picture output, just use
  // final Picture picture = svgRoot.toPicture();

  return svgRoot.viewport.viewBox;

  // picture.toImage(svgRoot.viewport.size, height)
}

String humanFileSize(int size) {
  var i1 = (math.log(size) / math.log(1000));
  if (i1.isNaN || i1.isInfinite) return "0B";
  var i = i1.floor();
  return ((size / math.pow(1000, i)).toStringAsFixed(2) * 1 +
      " " +
      ["B", "kB", "MB", "GB", "TB"][i]);
}

Future<Size> resizeImage(
  String asset,
  Size availableSize, {
  ImageType? imageType,
  bool useImageSize = false,
  bool isLogo = false,
}) async {
  bool scaleImageToFit = false;
  late Size originalSize;
  final String mimeType = mime(path.basename(asset)) ?? "";
  if (mimeType.contains("svg")) {
    originalSize = await getSvgImageSize(
      asset,
      imageType ?? ImageType.asset,
    );
  } else {
    originalSize = await getImageSize(
      asset,
      imageType ?? ImageType.asset,
    );
  }

  double? targetWidth;
  double? targetHeight;

  // if (isLogo) {
  //   if ((originalSize.height) > availableSize.height) {
  //     double diff = (originalSize.height - availableSize.height);
  //     while (diff > availableSize.height) {
  //       diff -= availableSize.height;
  //     }
  //     final ratio = (availableSize.height / diff);
  //     originalSize = Size(
  //       availableSize.height - (ratio * 1.5),
  //       availableSize.height - (ratio * 1.5),
  //     );
  //   }
  // }

  if (!useImageSize) {
    if (originalSize.width > originalSize.height) {
      //Landscape
      targetWidth = availableSize.width == double.infinity
          ? originalSize.width
          : availableSize.width;
      if (targetWidth > originalSize.width) {
        scaleImageToFit = true;
      }
    } else if (originalSize.width < originalSize.height) {
      targetHeight = availableSize.height;
      if (targetHeight > originalSize.width) {
        scaleImageToFit = true;
      }
    } else {
      targetHeight = availableSize.height;
      targetWidth = availableSize.height;
      log("$targetHeight");
    }
  }

  targetWidth ??= originalSize.width;

  targetHeight ??= originalSize.height;
  // Calculate resize ratios for resizing
  final double ratioW = targetWidth / originalSize.width;
  final double ratioH = targetHeight / originalSize.height;

  double ratio;
  if (useImageSize || !scaleImageToFit) {
    // smaller ratio will ensure that the image fits in the view
    ratio = ratioW < ratioH ? ratioW : ratioH;
  } else {
    if (targetWidth > originalSize.width) {
      // to scale image up to specified width or height keeping the aspect ratio intact
      ratio = ratioW > ratioH ? ratioW : ratioH;
    } else {
      // to scale image down to specified width or height keeping the aspect ratio intact
      ratio = ratioW < ratioH ? ratioW : ratioH;
    }
  }

  final double newWidth = originalSize.width * ratio;
  final double newHeight = originalSize.height * ratio;

  if (newWidth.toInt() > (1 * originalSize.width.toInt()) ||
      newHeight.toInt() > (1 * originalSize.height)) {
    return originalSize;
  }
  return Size(
    newWidth,
    newHeight,
  );
}

// Size resizeImage(
//   Size originalSize, {
//   double? targetWidth,
//   double? targetHeight,
//   bool scaleImageToFit = false,
// }) {
//   targetWidth ??= originalSize.width;

//   targetHeight ??= originalSize.height;
//   // Calculate resize ratios for resizing
//   final double ratioW = targetWidth / originalSize.width;
//   final double ratioH = targetHeight / originalSize.height;

//   late double ratio;
//   if (!scaleImageToFit) {
//     // smaller ratio will ensure that the image fits in the view
//     ratio = ratioW < ratioH ? ratioW : ratioH;
//   } else {
//     if (targetWidth > originalSize.width) {
//       // to scale image up to specified width or height keeping the aspect ratio intact
//       ratio = ratioW > ratioH ? ratioW : ratioH;
//     } else {
//       // to scale image down to specified width or height keeping the aspect ratio intact
//       ratio = ratioW < ratioH ? ratioW : ratioH;
//     }
//   }

//   final double newWidth = originalSize.width * ratio;
//   final double newHeight = originalSize.height * ratio;

//   if (newWidth.toInt() > (1 * originalSize.width.toInt()) ||
//       newHeight.toInt() > (1 * originalSize.height)) {
//     return originalSize;
//   }
//   return Size(
//     newWidth,
//     newHeight,
//   );
// }
