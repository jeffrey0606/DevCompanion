import 'package:devcompanion/helpers/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navBarPagesProvider = ChangeNotifierProvider<NavBarPagesProvider>(
  (ref) {
    return NavBarPagesProvider();
  },
);

class NavBarPagesProvider extends ChangeNotifier {
  NavBarPages _navBarPage = NavBarPages.overview;

  NavBarPages get currentPage => _navBarPage;

  void changePage(NavBarPages page) {
    _navBarPage = page;
    notifyListeners();
  }
}
