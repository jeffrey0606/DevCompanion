import 'package:devcompanion/helpers/colors.dart';
import 'package:devcompanion/providers/project_provider.dart';
import 'package:devcompanion/views/pages/overview/list_supported_platforms.dart';
import 'package:devcompanion/views/pages/overview/overview_card.dart';
import 'package:devcompanion/views/pages/overview/supported_platforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Overview extends StatelessWidget {
  Overview({
    Key? key,
  }) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Consumer(
            builder: (context, watch, child) {
              final watcher = watch.watch(projectProvider);

              return OverviewCard(
                projectModel:
                    watcher.noProjectFound ? null : watcher.currentProject,
              );
            },
          ),
        ),
        const SliverToBoxAdapter(
          child: ListSupportedPlatforms(),
        ),
        const SupportedPlatform(),
        const SliverToBoxAdapter(
          child: SizedBox(height: 10),
        ),
        SliverToBoxAdapter(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 1.3,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              width: double.infinity,
              child: const Text(
                "🔥🔥🔥",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: headerTextColor,
                  // fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 5),
        ),
      ],
    );
  }
}
