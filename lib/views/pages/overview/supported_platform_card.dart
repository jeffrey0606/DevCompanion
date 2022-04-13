import 'package:devcompanion/helpers/colors.dart';
import 'package:devcompanion/helpers/enums.dart';
import 'package:devcompanion/helpers/extensions.dart';
import 'package:devcompanion/models/logo_models.dart';
import 'package:devcompanion/views/components/display_image.dart';
import 'package:devcompanion/views/components/toggle_transition.dart';
import 'package:devcompanion/views/pages/overview/logo_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SupportedPlatformCard extends StatefulWidget {
  final List<LogoModel> platformLogos;
  final ProjectPlatform projectPlatform;
  const SupportedPlatformCard({
    Key? key,
    required this.platformLogos,
    required this.projectPlatform,
  }) : super(key: key);

  @override
  State<SupportedPlatformCard> createState() => _SupportedPlatformCardState();
}

class _SupportedPlatformCardState extends State<SupportedPlatformCard> {
  bool expanded = false;
  bool animEnd = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 1.3,
                  child: InkWell(
                    onTap: () {
                      expanded = !expanded;
                      animEnd = false;
                      setState(() {});
                    },
                    splashColor: secondaryColor,
                    borderRadius: BorderRadius.circular(50),
                    child: ToggleTransition(
                      expanded: expanded,
                      firstChild: const Icon(
                        // Icons.keyboard_arrow_up_rounded,
                        Icons.remove,
                      ),
                      secondChild: const Icon(
                        // Icons.keyboard_arrow_down_outlined,
                        Icons.add,
                      ),
                      duration: const Duration(
                        milliseconds: 300,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 1.3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Text(
                              widget.projectPlatform.name
                                  .firstCharToUpperCase(),
                              style: const TextStyle(
                                color: headerTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 6,
                                    ),
                                    child: const Text(
                                      "Default", //Custom
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: infoColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 5,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    decoration: BoxDecoration(
                                      color: successColor, //errorColor
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  Container(
                                    height: 29,
                                    width: 29,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: normalTextColor,
                                        width: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    padding: const EdgeInsets.all(2),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: DisplayImage(
                                        asset: widget.platformLogos.last.path,
                                        imageType: ImageType.file,
                                        //fit: BoxFit.cover,
                                        useImageSize: false,
                                        isLogo: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: const [
                                Text(
                                  "Thu Feb 24, 03:35:09AM",
                                  style: TextStyle(
                                    color: normalTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          width: double.infinity,
          height: expanded ? 300 : 0,
          onEnd: () {
            setState(() {
              animEnd = true;
            });
          },
          //transform: Matrix4.identity()..scale(expanded ? 1 : 0, 1),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: expanded && animEnd ? 1 : 0,
            child: Column(
              children: [
                if (animEnd)
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 40, right: 0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 1.3,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: double.infinity,
                              height: 80,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 1.3,
                            margin: const EdgeInsets.only(left: 44, right: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: double.infinity,
                              child: ScrollConfiguration(
                                behavior:
                                    ScrollConfiguration.of(context).copyWith(
                                  dragDevices: {
                                    PointerDeviceKind.mouse,
                                    PointerDeviceKind.touch,
                                  },
                                ),
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    bottom: 8.0,
                                    // bottom: 20,
                                    top: 8.0,
                                  ),
                                  // physics: const BouncingScrollPhysics(),
                                  children: widget.platformLogos.map((logo) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                        // bottom: 20,
                                        // top: 20,
                                      ),
                                      child: LogoCard(
                                        logo: logo,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
