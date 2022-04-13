import 'dart:math' show Random;

import 'package:devcompanion/helpers/colors.dart';
import 'package:devcompanion/providers/logo/logo_provider.dart';
import 'package:devcompanion/views/components/display_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListSupportedPlatforms extends StatelessWidget {
  const ListSupportedPlatforms({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 1.3,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Consumer(
              builder: (context, watch, child) {
                final watcher = watch.watch(logoProvider);
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    child!,
                    ...watcher.listOfProjectPlatforms.map((platform) {
                      int index = Random().nextInt(Colors.primaries.length - 1);
                      return Chip(
                        label: Text(
                          platform.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        backgroundColor:
                            Colors.primaries[index].withOpacity(0.6),
                        avatar: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: CircleAvatar(
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(50),
                            // ),
                            // radius: 23,
                            backgroundColor: backgroundColor,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: DisplayImage(
                                  asset: "assets/svgs/${platform.name}.svg",
                                ),
                              ),
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    })
                  ],
                );
              },
              child: const SizedBox(
                width: 100,
                height: 28,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Platforms: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: headerTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
