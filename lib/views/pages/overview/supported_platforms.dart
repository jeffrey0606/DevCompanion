import 'package:devcompanion/providers/logo/logo_provider.dart';
import 'package:devcompanion/views/pages/overview/supported_platform_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SupportedPlatform extends StatelessWidget {
  const SupportedPlatform({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final watcher = watch.watch(logoProvider);

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return SupportedPlatformCard(
                platformLogos:
                    watcher.supportedProjectPlatforms.values.toList()[index],
                projectPlatform: watcher.listOfProjectPlatforms[index],
              );
            },
            childCount: watcher.listOfProjectPlatforms.length,
          ),
        );
      },
    );
  }
}
