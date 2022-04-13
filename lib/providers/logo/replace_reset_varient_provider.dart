import 'package:devcompanion/helpers/enums.dart';
import 'package:devcompanion/providers/logo/logo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final replaceResetVarientProvider =
    ChangeNotifierProvider<ReplaceResetVarientProvider>(
  (ref) {
    return ReplaceResetVarientProvider(
      ref,
    );
  },
);

class ReplaceResetVarientProvider extends ChangeNotifier {
  final Ref ref;
  ReplaceResetVarientProvider(this.ref);
  List<ProjectPlatform> selectedPlatforms = [];

  void select(ProjectPlatform platform) {
    selectedPlatforms.add(platform);
    notifyListeners();
  }

  void remove(ProjectPlatform platform) {
    selectedPlatforms.remove(platform);
    notifyListeners();
  }

  void replace() {
    ref.read(logoProvider).replaceLogoVarients(
          selectedPlatforms,
        );
  }

  void reset() {}
}
