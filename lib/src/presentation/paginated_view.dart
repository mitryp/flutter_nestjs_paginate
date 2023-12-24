import 'dart:async';

import 'package:flutter/widgets.dart';

import '../application/pagination_controller.dart';
import '../domain/dto/paginated.dart';
import '../domain/typedefs.dart';

typedef ErrorBuilder = Widget Function(BuildContext context, Object? error);

typedef PaginatedViewBuilder<TModel> = Widget Function(
  BuildContext context,
  Paginated<TModel> data,
  PaginationController controller,
);

typedef PaginatedDataFetcher<TModel> = FutureOr<Paginated<TModel>> Function(
  BuildContext context,
  QueryParams params,
);

class PaginatedView<TModel> extends StatefulWidget {
  final PaginationController controller;
  final PaginatedViewBuilder<TModel> builder;
  final ErrorBuilder errorBuilder;
  final PaginatedDataFetcher<TModel> fetcher;
  final WidgetBuilder loadingIndicator;

  const PaginatedView({
    required this.controller,
    required this.builder,
    required this.errorBuilder,
    required this.fetcher,
    required this.loadingIndicator,
    super.key,
  });

  @override
  State<PaginatedView<TModel>> createState() => _PaginatedViewState();
}

class _PaginatedViewState<TModel> extends State<PaginatedView<TModel>> {
  late PaginationController _controller = widget.controller;
  late Paginated<TModel> _data;
  Object? _error;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _controller.addListener(_updateData);
    _updateData();
  }

  @override
  void didUpdateWidget(covariant PaginatedView<TModel> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_updateData);
      widget.controller.addListener(_updateData);
      setState(() => _controller = widget.controller);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateData);

    super.dispose();
  }

  Future<void> _updateData() async {
    setState(() => _isLoading = true);

    try {
      _data = await widget.fetcher(context, _controller.toMap());
    } catch (err) {
      _error = err;
    }

    if (!mounted) return;

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.loadingIndicator(context);
    }

    final error = _error;

    if (error != null) {
      return widget.errorBuilder(context, error);
    }

    return widget.builder(context, _data, _controller);
  }
}
