import 'package:devcompanion/helpers/exceptions.dart';
import 'package:flutter/material.dart';

class InitAppConfigsError extends StatelessWidget {
  final InitAppConfigsException exception;
  const InitAppConfigsError({
    Key? key,
    required this.exception,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(exception.message),
    );
  }
}
