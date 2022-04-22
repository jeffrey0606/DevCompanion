import 'package:devcompanion/helpers/colors.dart';
import 'package:devcompanion/helpers/contants.dart';
import 'package:devcompanion/helpers/extensions.dart';
import 'package:devcompanion/models/projects_tech_model.dart';
import 'package:devcompanion/providers/assets_provider.dart';
import 'package:devcompanion/providers/logo/logo_provider.dart';
import 'package:devcompanion/providers/project_provider.dart';
import 'package:devcompanion/views/components/display_image.dart';
import 'package:devcompanion/views/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectsTech extends StatelessWidget {
  final bool refresh;
  const ProjectsTech({
    Key? key,
    this.refresh = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ColoredBox(
        color: backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "What's your project's Tech Boss 🎨🖌️?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: headerTextColor,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ProjectsTechOptions(
              refresh: refresh,
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectsTechOptions extends ConsumerStatefulWidget {
  final bool refresh;
  const ProjectsTechOptions({
    Key? key,
    required this.refresh,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ProjectsTechOptionsState();
}

class _ProjectsTechOptionsState extends ConsumerState<ProjectsTechOptions> {
  int? selectedIndex;

  void moveToProject() async {
    if (widget.refresh) {
      ref.refresh(projectProvider);
      ref.refresh(logoProvider);
    }
    final _projectProvider = ref.read(projectProvider);
    await _projectProvider.changeProjectTech(
      techs[selectedIndex!].type,
      init: true,
    );

    if (!_projectProvider.noProjectFound) {
      ref
          .read(logoProvider)
          .initSupportedPlatforms(_projectProvider.currentProject);
      ref
          .read(assetsProvider)
          .initProjectAssets(_projectProvider.currentProject);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          alignment: WrapAlignment.center,
          children: techs.map(
            (tech) {
              int index = techs.indexOf(tech);
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  width: 70,
                  height: 90,
                  child: TechCard(
                    tech: tech,
                    isSelected:
                        selectedIndex == null ? null : index == selectedIndex,
                    onTap: () {
                      selectedIndex = index;
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          ).toList(),
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              child: TextButton(
                onPressed: selectedIndex == null
                    ? null
                    : () {
                        moveToProject();
                      },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    selectedIndex == null ? Colors.transparent : primaryColor,
                  ),
                  elevation: MaterialStateProperty.all(
                    selectedIndex == null ? 0 : 4,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      "continue",
                      style: TextStyle(
                        color: selectedIndex == null ? null : Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: selectedIndex == null ? null : Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TechCard extends StatelessWidget {
  final bool? isSelected;
  final ProjectsTechModel tech;
  final bool romoveText;
  final double padding;
  final double elevation;
  final Function()? onTap;
  const TechCard({
    Key? key,
    this.isSelected,
    required this.tech,
    this.romoveText = false,
    this.padding = 8.0,
    this.elevation = 3.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Card(
            // height: 50,
            // width: 50,
            elevation: elevation,
            child: InkWell(
              onTap: onTap,
              splashColor: secondaryColor,
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected != null && isSelected!
                        ? primaryColor
                        : inActiveColor,
                    width: 4,
                  ),
                ),
                child: DisplayImage(
                  asset: tech.asset,
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        if (!romoveText)
          const SizedBox(
            height: 5,
          ),
        if (!romoveText)
          Text(
            tech.type.name.firstCharToUpperCase(),
            style: const TextStyle(
              color: headerTextColor,
              fontSize: 14,
            ),
          ),
      ],
    );
  }
}
