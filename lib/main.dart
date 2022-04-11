import 'package:devcompanion/views/pages/app.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FluentApp(
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   backgroundColor: const Color(0xfff0efff),
      // ),
      home: MaterialApp(
        home: App(),
        debugShowCheckedModeBanner: false,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
