import 'package:devcompanion/helpers/colors.dart';
import 'package:devcompanion/helpers/enums.dart';
import 'package:devcompanion/models/logo_models.dart';
import 'package:devcompanion/views/components/display_image.dart';
import 'package:flutter/material.dart';

class LogoCard extends StatefulWidget {
  final LogoModel logo;
  const LogoCard({Key? key, required this.logo}) : super(key: key);

  @override
  State<LogoCard> createState() => _LogoCardState();
}

class _LogoCardState extends State<LogoCard> {
  late Size? imageSize;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: normalTextColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: DisplayImage(
                  asset: widget.logo.path,
                  imageType: ImageType.file,
                  //fit: BoxFit.cover,
                  useImageSize: false,
                  isLogo: true,
                ),
              ),
            ),
          ),
        ),
        // const SizedBox(
        //   height: 15,
        // ),
        // Text(
        //   "${widget.logo.dimension.width}x${widget.logo.dimension.height}",
        // ),
      ],
    );
  }
}
