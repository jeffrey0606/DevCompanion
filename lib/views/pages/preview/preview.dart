import 'package:flutter/material.dart';

class Preview extends StatelessWidget {
  const Preview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Project's Preview",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
