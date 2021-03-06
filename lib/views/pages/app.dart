import 'package:devcompanion/helpers/colors.dart';
import 'package:devcompanion/helpers/exceptions.dart';
import 'package:devcompanion/helpers/functions.dart';
import 'package:devcompanion/views/pages/errors/init_app_configs_error.dart';
import 'package:devcompanion/views/pages/home/home.dart';
import 'package:devcompanion/views/pages/intro/projects_tech.dart';
import 'package:devcompanion/views/pages/splash/spash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerStatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late Future<bool>? _initAppConfigs;

  @override
  void initState() {
    _initAppConfigs = initAppConfigs(context, ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<bool>(
        future: _initAppConfigs,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              return const ProjectsTech();
            } else {
              return const Home();
            }
          } else if (snapshot.hasError) {
            return InitAppConfigsError(
              exception: snapshot.error as InitAppConfigsException,
            );
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }
}
