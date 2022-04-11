import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Project's Color Picker",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
