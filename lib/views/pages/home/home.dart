import 'package:devcompanion/helpers/colors.dart';
import 'package:devcompanion/helpers/enums.dart';
import 'package:devcompanion/providers/nav_bar_pages_provider.dart';
import 'package:devcompanion/views/components/nav_bar.dart';
import 'package:devcompanion/views/components/projects_content.dart';
import 'package:devcompanion/views/components/projects_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final Size size = Size(
            constraints.maxWidth,
            constraints.maxHeight,
          );
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const NavBar(),
                        const Expanded(
                          child: ProjectsContent(),
                        ),
                        Consumer(
                          builder: (context, watch, child) {
                            final watcher = watch(navBarPagesProvider);

                            switch (watcher.currentPage) {
                              case NavBarPages.colorPicker:
                                return Container();
                              default:
                                return child!;
                            }
                          },
                          child: ProjectHistory(
                            windowSize: size,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 1.5,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 60,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {},
                                child: const Icon(
                                  Icons.settings,
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            "v1.0.0",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: headerTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
