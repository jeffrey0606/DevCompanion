import 'package:devcompanion/helpers/colors.dart';
import 'package:devcompanion/helpers/functions.dart';
import 'package:devcompanion/models/projects_tech_model.dart';
import 'package:devcompanion/providers/logo/logo_provider.dart';
import 'package:devcompanion/providers/project_provider.dart';
import 'package:devcompanion/views/components/display_image.dart';
import 'package:devcompanion/views/pages/intro/projects_tech.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectHistory extends StatelessWidget {
  final Size windowSize;
  const ProjectHistory({
    Key? key,
    required this.windowSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _projectProvider = context.read(projectProvider);
    var _logoProvider = context.read(logoProvider);
    return SizedBox(
      height: double.infinity,
      width: 280,
      child: Column(
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
              width: double.infinity,
              child: const Text(
                "Project's history",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: headerTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 1.5,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Consumer(
                  builder: (context, watch, child) {
                    final watcher = watch(projectProvider);
                    return ListView(
                      children: watcher.projects.map(
                        (project) {
                          final int index = watcher.index(project);
                          return HistoryCard(
                            projectModel: project,
                            isSelected: watcher.isSelected(index),
                            index: index,
                          );
                        },
                      ).toList(),
                    );
                  },
                ),
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 1.5,
            child: Container(
              // padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              // height: 70,
              width: double.infinity,
              child: Consumer(
                builder: (context, watch, child) {
                  final watcher = watch(projectProvider);
                  return Wrap(
                    spacing: 1,
                    runSpacing: 1,
                    children: [
                      ...watcher.currentSupportedTechs.map((tech) {
                        final isSelected =
                            watcher.currentTech.type == tech.type;
                        return SizedBox(
                          width: 60,
                          height: 60,
                          child: TechCard(
                            tech: tech,
                            isSelected: isSelected,
                            romoveText: true,
                            padding: 3.0,
                            elevation: 2.0,
                            onTap: isSelected
                                ? null
                                : () async {
                                    context.refresh(projectProvider);
                                    context.refresh(logoProvider);
                                    _projectProvider =
                                        context.read(projectProvider);
                                    _logoProvider = context.read(logoProvider);
                                    await _projectProvider.changeProjectTech(
                                      tech.type,
                                      init: false,
                                    );
                                    if (!_projectProvider.noProjectFound) {
                                      _logoProvider.initSupportedPlatforms(
                                        _projectProvider.currentProject,
                                      );
                                    }
                                  },
                          ),
                        );
                      }),
                      child!,
                    ],
                  );
                },
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Card(
                    elevation: 0.0,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          builder: (context) {
                            final size = MediaQuery.of(context).size;
                            return Material(
                              type: MaterialType.transparency,
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: size.width >= 500
                                        ? 500
                                        : size.width * 0.9,
                                    height: size.height * 0.4,
                                    decoration: BoxDecoration(
                                      // color: colorTheme.backgroundColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const ProjectsTech(
                                      refresh: true,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          context: context,
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      splashColor: secondaryColor,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: successColor,
                            width: 4,
                          ),
                        ),
                        child: const FittedBox(
                          child: Icon(
                            Icons.add,
                            color: successColor,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final ProjectModel projectModel;
  final bool isSelected;
  final int index;
  const HistoryCard({
    Key? key,
    required this.projectModel,
    this.isSelected = false,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 1,
        child: InkWell(
          onTap: () async {
            final _projectProvider = context.read(projectProvider);

            if (index == _projectProvider.currentProjectIndex) return;
            _projectProvider.changeProject(index);
            context
                .read(logoProvider)
                .initSupportedPlatforms(_projectProvider.currentProject);
          },
          borderRadius: BorderRadius.circular(10),
          splashColor: secondaryColor,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(isSelected ? 4 : 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? Border.all(
                      color: primaryColor,
                      width: 4,
                    )
                  : null,
            ),
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(
                  height: double.infinity,
                  width: 80,
                  child:
                      //  projectModel.logo == null
                      // ? FDottedLine(
                      // color: primaryColor,
                      // strokeWidth: 1.5,
                      // dottedLength: 8.0,
                      // space: 3.0,
                      // corner: FDottedLineCorner.all(8.0),
                      // child: Container(),
                      // )
                      // :
                      Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: projectModel.logo == null
                          ? const SizedBox(
                              height: double.infinity,
                              width: 80,
                              child: Center(
                                child: Text(
                                  "🚀",
                                  style: TextStyle(
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                            )
                          : DisplayImage(
                              asset: projectModel.logo!,
                              imageType: projectModel.logoType!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        projectModel.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: headerTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      if (projectModel.size != null)
                        Text(
                          humanFileSize(projectModel.size!),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: normalTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      const SizedBox(
                        height: 4,
                      ),
                      if (projectModel.dimension != null)
                        Text(
                          projectModel.dimension!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: normalTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
