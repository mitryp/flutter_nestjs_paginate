import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_nestjs_paginate/flutter_nestjs_paginate.dart';

import 'error_widget.dart';

void main() {
  runApp(const FlutterNestjsPaginateExample());
}

class FlutterNestjsPaginateExample extends StatelessWidget {
  const FlutterNestjsPaginateExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Placeholder(),
    );
  }
}

class PaginatedPage extends StatefulWidget {
  const PaginatedPage({super.key});

  @override
  State<PaginatedPage> createState() => _PaginatedPageState();
}

class _PaginatedPageState extends State<PaginatedPage> {
  static const PaginateConfig _config = PaginateConfig(sortableColumns: {'amount', ''});

  final PaginationController _controller = PaginationController(paginateConfig: _config);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PaginatedView(
        controller: _controller,
        errorBuilder: (context, error) => ErrorWidget(error),


      ),
    );
  }
}
