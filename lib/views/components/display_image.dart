import 'dart:async';
import 'dart:io';

import 'package:devcompanion/helpers/enums.dart';
import 'package:devcompanion/helpers/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as pathz;
import 'package:watcher/watcher.dart';

class DisplayImage extends StatelessWidget {
  final String asset;
  final ImageType imageType;
  final BoxFit fit;
  final Color? color;
  final bool? useImageSize;
  final bool? isLogo;
  const DisplayImage({
    Key? key,
    required this.asset,
    this.imageType = ImageType.asset,
    this.fit = BoxFit.contain,
    this.color,
    this.useImageSize,
    this.isLogo,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(
          constraints.maxWidth,
          constraints.maxHeight,
        );
        return ShowImage(
          asset: asset,
          size: size,
          imageType: imageType,
          color: color,
          fit: fit,
          useImageSize: useImageSize,
          isLogo: isLogo,
        );
      },
    );
  }
}

class ShowImage extends StatefulWidget {
  final String asset;
  final Size size;
  final ImageType imageType;
  final BoxFit fit;
  final Color? color;
  final bool? useImageSize;
  final bool? isLogo;
  const ShowImage({
    Key? key,
    required this.asset,
    required this.size,
    required this.imageType,
    required this.fit,
    this.color,
    this.useImageSize,
    this.isLogo,
  }) : super(key: key);

  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  late Future<Size> _resizeImage;

  StreamSubscription<WatchEvent>? sub;

  @override
  void initState() {
    loadImage();

    if (widget.imageType == ImageType.file) {
      final watcher = FileWatcher(widget.asset);

      sub = watcher.events.listen((event) {
        if (ChangeType.MODIFY == event.type) {
          imageCache?.clearLiveImages();
          imageCache?.clear();

          loadImage();

          setState(() {});
        }
      });
    }
    super.initState();
  }

  void loadImage() {
    _resizeImage = resizeImage(
      widget.asset,
      widget.size,
      imageType: widget.imageType,
      useImageSize: widget.useImageSize ?? false,
      isLogo: widget.isLogo ?? false,
    );
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Size>(
      future: _resizeImage,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            width: snapshot.data?.height,
            height: snapshot.data?.width,
            child: Builder(
              builder: (context) {
                final String mimeType =
                    mime(pathz.basename(widget.asset)) ?? "";

                if (mimeType.contains("svg")) {
                  switch (widget.imageType) {
                    case ImageType.asset:
                      return SvgPicture.asset(
                        widget.asset,
                        height: snapshot.data?.height,
                        width: snapshot.data?.width,
                        color: widget.color,
                        fit: widget.fit,
                      );
                    case ImageType.file:
                      return SvgPicture.file(
                        File(widget.asset),
                        height: snapshot.data?.height,
                        width: snapshot.data?.width,
                        color: widget.color,
                        fit: widget.fit,
                      );
                    case ImageType.network:
                      return SvgPicture.network(
                        widget.asset,
                        height: snapshot.data?.height,
                        width: snapshot.data?.width,
                        color: widget.color,
                        fit: widget.fit,
                      );
                    default:
                      return Container();
                  }
                }

                switch (widget.imageType) {
                  case ImageType.asset:
                    return Image.asset(
                      widget.asset,
                      // cacheHeight: snapshot.data?.height.toInt(),
                      // cacheWidth: snapshot.data?.width.toInt(),
                      height: snapshot.data?.height,
                      width: snapshot.data?.width,
                      fit: widget.fit,
                      filterQuality: FilterQuality.medium,
                    );
                  case ImageType.file:
                    return Image.file(
                      File(widget.asset),
                      // cacheHeight: snapshot.data?.height.toInt(),
                      // cacheWidth: snapshot.data?.width.toInt(),
                      height: snapshot.data?.height,
                      width: snapshot.data?.width,
                      fit: widget.fit,
                      filterQuality: FilterQuality.medium,
                    );
                  case ImageType.network:
                    return Image.network(
                      widget.asset,
                      // cacheHeight: snapshot.data?.height.toInt(),
                      // cacheWidth: snapshot.data?.width.toInt(),
                      height: snapshot.data?.height,
                      width: snapshot.data?.width,
                      fit: widget.fit,
                      filterQuality: FilterQuality.medium,
                    );
                  default:
                    return Container();
                }
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }
}

// class WatchFileSystemImageChanges {
//   static Stream<ImageChangesEvent> get events => _eventsController.stream;

//   static final _eventsController =
//       StreamController<ImageChangesEvent>.broadcast();

//   static add(ImageChangesEvent changesEvent) {
//     _eventsController.add(changesEvent);
//   }
// }

// class ImageChangesEvent {
//   final String path;

//   final ImageChangesType type;

//   ImageChangesEvent({
//     required this.path,
//     required this.type,
//   });
// }

// enum ImageChangesType {
//   modify,
// }