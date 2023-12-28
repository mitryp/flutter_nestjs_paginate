import 'dart:async';

import 'package:flutter/widgets.dart';

import '../application/pagination_controller.dart';
import '../domain/dto/paginated.dart';
import '../domain/typedefs.dart';

typedef ErrorBuilder = Widget Function(BuildContext context, Object? error);

typedef PaginatedViewBuilder<TModel> = Widget Function(
  BuildContext context,
  Paginated<TModel> data,
);

typedef PaginatedDataFetcher<TModel> = FutureOr<Paginated<TModel>> Function(
  BuildContext context,
  QueryParams params,
);

/// A widget providing a framework for building controllable paginated data views powered by
/// `nestjs-paginate` on backend. It combines together the [controller] for pagination,
/// [viewBuilder] for building the presentation of the data of type [TModel] received from a
/// [fetcher]. It handles displaying of errors with [errorBuilder] and shows a [loadingIndicator].
///
/// Components:
/// - [controller] provides reactive controls for the query, notifying this widget of
/// its updates.
/// - [fetcher] is a function taking [BuildContext] and [QueryParams]  (Map<String, Object?>) and
/// returning a [Paginated] of [TModel] or its Future.
/// - [viewBuilder] is a builder of the presentation of the current page data received from the
/// [fetcher].
/// - [errorBuilder] is a builder which will be used in the event of [fetcher] throwing.
/// - [loadingIndicator] is a builder which will be used while the data from the [fetcher] is
/// loading.
class PaginatedView<TModel> extends StatefulWidget {
  /// A [PaginationController] of this [PaginatedView].
  /// This widget will rebuild whenever the controller sends notifications.
  final PaginationController controller;

  /// A builder of the presentation of the current page data received from the [fetcher].
  final PaginatedViewBuilder<TModel> viewBuilder;

  /// A builder of the error message.
  /// It is used when the [fetcher] throws an error.
  final ErrorBuilder errorBuilder;

  /// A widget that ish shown when the data from fetcher is being loaded.
  final WidgetBuilder loadingIndicator;

  /// A function that takes [QueryParams] built by the controller and [BuildContext] and returns
  /// [Paginated]<[TModel]>.
  final PaginatedDataFetcher<TModel> fetcher;

  /// Creates a [PaginatedView] with the parameters provided.
  ///
  /// [controller] updates will make this widget update its data and call the [fetcher] with the
  /// result of [PaginationController.toMap].
  ///
  /// See the fields docs for more info.
  const PaginatedView({
    required this.controller,
    required this.viewBuilder,
    required this.errorBuilder,
    required this.fetcher,
    required this.loadingIndicator,
    super.key,
  });

  @override
  State<PaginatedView<TModel>> createState() => _PaginatedViewState();
}

class _PaginatedViewState<TModel> extends State<PaginatedView<TModel>> {
  late Paginated<TModel> _data;
  Object? _error;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_updateData);
    _updateData();
  }

  @override
  void didUpdateWidget(covariant PaginatedView<TModel> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_updateData);
      widget.controller.addListener(_updateData);
      _updateData();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateData);

    super.dispose();
  }

  Future<void> _updateData() async {
    setState(() => _isLoading = true);

    try {
      _data = await widget.fetcher(context, widget.controller.toMap());
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

    return widget.viewBuilder(context, _data);
  }
}
