import 'dart:math' show Random;

import 'package:devcompanion/helpers/enums.dart';
import 'package:devcompanion/models/init_params.dart';
import 'package:devcompanion/models/projects_tech_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;

final projectProvider = ChangeNotifierProvider<ProjectProvider>(
  (ref) {
    return ProjectProvider();
  },
);

class ProjectProvider extends ChangeNotifier {
  ProjectProvider() {
    currentProjectIndex = 0;
  }
  List<ProjectModel> _projects = [];

  late int currentProjectIndex;

  ProjectModel get currentProject => _projects[currentProjectIndex];

  bool isSelected(int index) {
    return currentProjectIndex == index;
  }

  List<ProjectModel> get projects => [..._projects];

  List<ProjectsTechModel> _techs = [];

  List<ProjectsTechModel> get currentSupportedTechs => _techs
      .where(
        (tech) => tech.isActive,
      )
      .toList();

  late ProjectsTechModel _currentTech;

  ProjectsTechModel get currentTech => _currentTech;

  bool get noProjectFound => _projects.isEmpty;

  int index(ProjectModel project) => _projects.indexOf(project);

  void changeProject(int index) {
    currentProjectIndex = index;
    notifyListeners();
  }

  Future<void> changeProjectTech(ProjectsTechType? type,
      {bool init = false}) async {
    type ??= getRecentProjectsTech();

    if (await Hive.boxExists(type.name)) {
      final box = await Hive.openBox<ProjectModel>(type.name);
      await updateTech(
        type,
        box: box,
      );
    } else {
      final box = await Hive.openBox<ProjectModel>(type.name);
      await updateTech(
        type,
        box: box,
        newTech: true,
      );
    }
    if (!init) {
      notifyListeners();
    }
  }

  Future<void> saveInitParams() async {
    final initParamsBox = await Hive.openBox<InitParams>("initParams");
    var initParams = initParamsBox.get("data");

    initParams!.isFirstTime = false;

    await initParams.save();

    await initParamsBox.close();
  }

  ProjectsTechType getRecentProjectsTech() {
    //TODO: Still to be implemented
    return ProjectsTechType.flutter;
  }

  Future<void> updateTech(
    ProjectsTechType type, {
    Box<ProjectModel>? box,
    bool newTech = false,
  }) async {
    final techsBox = await Hive.openBox<ProjectsTechModel>("techs");
    final values = techsBox.values.toList();

    if (newTech) {
      _projects = [];
      await box!.addAll([]);

      final tech = values.firstWhere((tech) => tech.type == type);
      tech.isActive = true;
      await tech.save();
    }

    final projects = box!.values.toList();

    _projects = projects.isEmpty ? [] : projects;

    _currentTech = values.firstWhere((tech) => tech.type == type);

    _techs = values;

    await techsBox.close();
  }

  bool projectAlreadyExists(String path) {
    try {
      projects.firstWhere(
        (element) => element.location == path,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> addNewProject(String projectPath) async {
    final String defaultName = path.basename(projectPath);
    final ProjectModel newProject = ProjectModel(
      id: "$defaultName-${Random().nextInt(100000)}",
      name: defaultName,
      type: _currentTech.type,
      // dimension: _currentTech.dimension,
      // logo: _currentTech.asset,
      // size: _currentTech.size,
      location: projectPath,
      // logoType: ImageType.asset,
    );

    final box = await Hive.openBox<ProjectModel>(_currentTech.type.name);

    final int index = await box.add(newProject);

    _projects = box.values.toList();
    currentProjectIndex = index;
    await box.close();

    notifyListeners();
  }
}
