import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_nestjs_paginate/flutter_nestjs_paginate.dart';
import 'package:flutter_nestjs_paginate_example/cities_view.dart';

import 'error_widget.dart';
import 'fetcher.dart';

void main() => runApp(const FlutterNestjsPaginateExample());

class FlutterNestjsPaginateExample extends StatelessWidget {
  const FlutterNestjsPaginateExample({super.key});

  @override
  Widget build(BuildContext context) =>
      const MaterialApp(home: PaginatedPage());
}

class PaginatedPage extends StatefulWidget {
  const PaginatedPage({super.key});

  @override
  State<PaginatedPage> createState() => _PaginatedPageState();
}

class _PaginatedPageState extends State<PaginatedPage> {
  static const PaginateConfig _config = PaginateConfig(defaultLimit: 3);

  final PaginationController _controller =
      PaginationController(paginateConfig: _config);

  PaginatedMetadata? _metadata;

  // the fetcher will be called on load, so the controls will be locked initially
  bool _areControlsLocked = true;

  @override
  Widget build(BuildContext context) {
    final meta = _metadata;

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PaginatedView(
            // provide a controller to control the pagination
            controller: _controller,
            // fetcher is used to make a paginated request to your server
            fetcher: (context, params) => fetch(
                limit: params['limit'] as int, page: params['page'] as int),
            // error builder will be called to visualise the error, if it occurs
            errorBuilder: (context, error) => ErrorWidget(error),
            // loading indicator will be built while the data is fetched
            loadingIndicator: (context) =>
                const Center(child: CircularProgressIndicator()),
            // view builder visualises a list of TModels received from the fetcher
            viewBuilder: (context, data) => CitiesView(data.data),
            // you can also provide listeners for the
            // fetch start end finish events. they are called
            // in a post-frame callbacks, so you can call setState
            // inside
            onFetch: () {
              if (!mounted) return;
              setState(() => _areControlsLocked = true);
            },
            onLoaded: (res) {
              if (!mounted || res == null) return;
              setState(() {
                _metadata = res.meta;
                _areControlsLocked = false;
              });
            },
          ),

          // pagination controls
          if (meta == null)
            const SizedBox()
          else
            Row(
              children: [
                IconButton(
                  onPressed: !_areControlsLocked && meta.currentPage > 1
                      ? () => _controller.page--
                      : null,
                  icon: const Icon(Icons.keyboard_arrow_left),
                ),
                Text('${_controller.page}'),
                IconButton(
                  onPressed:
                      !_areControlsLocked && meta.currentPage < meta.totalPages
                          ? () => _controller.page++
                          : null,
                  icon: const Icon(Icons.keyboard_arrow_right),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
