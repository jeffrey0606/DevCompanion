import 'package:devcompanion/helpers/enums.dart';
import 'package:devcompanion/models/projects_tech_model.dart';

List<ProjectModel> flutterMockProjects = [
  ProjectModel(
    id: "whoshares-331313",
    name: "WhoShares",
    type: ProjectsTechType.flutter,
    dimension: "512x512",
    logo:
        "/home/jeff/Documents/FlutterProjects/who_shares_desktop/snap/gui/whoshares.png",
    size: 43900,
    location: "/home/jeff/Documents/FlutterProjects/who_shares_desktop/",
    logoType: ImageType.file,
  ),
  ProjectModel(
    id: "TaskIt-355655",
    name: "TaskIt",
    type: ProjectsTechType.flutter,
    dimension: "512x512",
    logo: "/home/jeff/Documents/internship_project/TaskIt/assets/logo.png",
    size: 39800,
    location: "/home/jeff/Documents/internship_project/TaskIt/",
    logoType: ImageType.file,
  ),
];

Map<String, List<ProjectModel>> mockTechsProjects = {
  ProjectsTechType.flutter.name: flutterMockProjects,
};
