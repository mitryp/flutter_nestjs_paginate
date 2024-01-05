import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  final Object? error;

  const ErrorWidget(this.error, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Oh no! An error occurred: $error'),
    );
  }
}
