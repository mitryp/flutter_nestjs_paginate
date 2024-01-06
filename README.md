# flutter_nestjs_paginate

A library providing a base for building controllable paginated views powered by [`nestjs-paginate`](https://www.npmjs.com/package/nestjs-paginate) on the backend.

## Features
- `PaginationController` provides a comprehensive and reactive interface for building paginated queries. It can be configured with `PaginateConfig`, either hardcoded or received from the server directly, to empower client-side validation. `PaginateController` supports all features of `nestjs-paginate` except `select`, as it breaks the majority of DTOs in Dart, but it may change in future updates.
- `PaginatedView` utilises a pagination controller and user-defined widget builders to create a highly customisable presentation of data received from the server.
- `Paginated<TDto>` - a wrapper for the paginated DTO sent by the `nestjs-paginate` which includes `PaginatedMetadata` and a list of `TDto`.
## Getting started

To start using the package, install it using pub:

```shell
flutter pub add flutter_nestjs_paginate
```

This will install the latest compatible version of the package and you're ready to go.

## Minimal usage example

Create a `PaginateConfig` by hard-coding it or by fetching it from your server:

```dart
final configJson = await get<Map>('/paginate_config');
final config = PaginateConfig.fromJson(configJson);

// or

// all parameters are optional
const config = PaginateConfig(
   defaultSortBy: {'name': SortOrder.asc},
   defaultLimit: 10,
   filterableColumns: {
     'name': {Eq, Ilike},
     'population': {Gt, Lt, Eq, Btw},
   },
   sortableColumns: {'name', 'population'},
);
```

To control the pagination, a `PaginationController` is used.
Create it and supply the created config:

```dart
// in your state
final _controller = PaginationController(paginateConfig: config);
```

While the config parameter is optional, passing it enables filtering and sorting validation. If you want to omit config and disable validation, pass `validateColumns: false` to the controller constructor. There are also 

Then create a `PaginatedView`:

```dart
// in build()
return PaginatedView(
   // provide the controller. its updates will make the 
   controller: _controller,
   // fetcher is used to make a paginated request to your server  
   // it must return a Paginated<YourDto> - more 
   // information below and in the source docs
   fetcher: (context, QueryParams params) { ... },
   // error builder will be called to visualise 
   // the error, if it occurs
   errorBuilder: (context, Object error) => YourErrorWidget(error),
   // loading indicator will be built while the data is fetched  
   loadingIndicator: (context) => YourProgressIndicator(),
   // view builder visualizes a list of TModels 
   // received from the fetcher
   viewBuilder: (context, Paginated<YourDto> data) {
     return YourDataView(data.data);
   },
   // you can also provide listeners for the 
   // fetch start end finish events. they are called
   // in post-frame callbacks, so you can call setState 
   // inside
   onFetch: () { ... },
   onLoaded: (Paginated<YourDto> result) { ... },
);
```

Now, the pagination can be controlled with the `controller`:

```dart
// in a button callback

// fetch next page
_controller.page++;

// add a filter using the operator Btw 
_controller.addFilter(
   'date',
   const Btw('2023-12-20', '2023-12-26'),
);

// perform multiple operations simultaneously
controller.silently(
   notifyAfter: true,
   (controller) => controller
     ..page = 1
     ..clearFilters()
     ..addFilter('amount', const Gt(1000))
     ..addSort('amount', SortOrder.desc),
);
```

## Details

### Constraints
#### `SortOrder` 

An enum defining the order of sorting: either ascending or descending:

```dart
enum SortOrder {
   asc,
   desc
}
```

#### `FilterOperator` 

A family of classes representing the filters supported by `nestjs-paginate`:
- $eq - `Eq`
- $not - `Not`
- $null - `Null`
- $in - `In`
- $gt, $gte - `Gt` - for $gte, provide `orEquals: true` to the constructor
- $lt, $lte - `Lt` - for $lte, provide `orEquals: true` to the constructor
- $btw - `Btw`
- $ilike - `Ilike`
- $sw - `Sw`
- $contains - `Contains`

### `PaginationController`

This class provides the reactive interface to control the pagination.

It features fields with the names of query parameters accepted by `nestjs-paginate` and can be configured with client-side validation with `PaginateConfig` objects.

#### Validation

Pagination controllers support column validation, which is enabled by default - `validateColumns`

It can also be enforced to prevent unexpected behaviour in production (disabled by default) - `strictValidation` - it would throw StateErrors with meaningful messages to help you find the problem.

When validation is enabled, it will use the values from the provided `PaginateConfig` (and only if it is provided).

#### `PaginateConfig`

A class that duplicates the structure of PaginateConfig from nestjs-paginate, omitting database- and backend-specific values, can be passed to a PaginationController constructor. It can then be used by the developer and the controller to enable validation.

The fields it contains:
- Set\<String\> `sortableColumns` - the names of columns to be accepted by the controller in `addSort`. Default: `{}` - no columns allowed for sorting.
- Map\<String, Set\<Type\>\> `filterableColumns` - a map of column names accepted by the backend for filtering to sets of their allowed `FilterOperator` types. Default: `{}` - no columns allowed for filtering.
- int `maxLimit` - the maximum limit configured on the server. Default: `100`.
- int `defaultLimit` - the limit value to be set by default. Default: `20`.
- Map\<String, SortOrder> `defaultSortBy` - the default sort queries.

`PaginateConfig` has a `fromJson` factory which supports deserializing `nestjs-paginate` config syntax directly.

> Make sure not to send backend-specific values that you do not need in your Flutter application to avoid potential disclosure of system details.

> Note that no columns are allowed for sorting and filtering by default, so you should consider providing the paginateConfig or setting validateColumns to false in your controller.

#### Pagination

To control the pagination, use the following:
- get/set int **`page`** - the page of the paginated data to be requested. Default: `1`.
- get/set int **`limit`** - the maximum amount of entries per page. Default: `20`.
- get/set Object? **`search`** - the search query to be sent. Default: `null`.
    Note that the search object must be string-serialisable in a meaningful way with `toString` for it to be correctly received by your server.

If any of these fields are changed, the controller will notify its listeners (unless changed inside the `silently` function).  

#### Filters

To control the filters, use the following members of the controller:
- get Map\<String, Set\<FilterOperator\>\> **`filters`** - an unmodifiable view of the filters currently applied. `nestjs-paginate` supports multiple filters per single column. The map has the following structure:
```dart
{
   'column': { FilterOperator, FilterOperator, ... },
   ...
}
```
- `addFilter(String field, FilterOperator operator)` - adds a filter by the given field with the given `FilterOperator` to the query. If the filter set is changed, notifies listeners.
- `removeFilter(String field, [FilterOperator? operator])` - if the operator is not given, remove all filters for the given field. Otherwise, remove a filter by that operator from the field.
- `clearFilters()` - removes all filters from the query. If the filter set is not empty, notifies listeners.
#### Sorting

To control sorting, use the following members:
- get Map\<String, SortOrder\> **`sorts`** - an unmodifiable view of the sorts currently applied. The map has the following structure:
```dart
{
   'column': SortOrder,
   ...
}
```
- `addSort(String field, SortOrder order)` - updates the sort query to include the sort in the given order by the given field. If the sort set is changed, notifies listeners.
- `removeSort(String field)` - removes a sort query by the given field. If such a query is present, notifies listeners.
- `clearFilters()` - removes all sorts from the query. If the sort set is not empty, notifies listeners.

#### Multiple operations

By default, changing any fields of the controller will fire the notification and make the `PaginatedView` call its fetcher. However, if you need to change multiple parameters simultaneously and don't need to notify listeners, you can use `silently(Function(PaginationController) fn, {bool notifyAfter = false})`.

Refer to the docs in the source code for more information.

### `Paginated<TDto>`  

This is a generic wrapper for the responses received from paginated endpoints.

Matching the `PaginateConfig` from `nestjs-paginate`, it contains `data` - a list of your DTOs, and `meta` - `PaginatedMetadata`. 

It can be deserialised using `Paginated.fromJson<TDto>(json, decoder)`, where `decoder` is a function taking a Map\<String, dynamic\> and returning your DTO:

```dart
final json = await client.get<Map<String, dynamic>>('/paginated_collection');

final paginatedRes = Paginated.fromJson(json, YourDto.fromJson);
```

## Contributing

If you would like to contribute to this package, you can:
- [file an issue or propose an improvement](https://github.com/mitryp/flutter_nestjs_paginate/issues/new)
- [view the source code on GitHub](https://github.com/mitryp/flutter_nestjs_paginate)
- create a pull request in the repository

All contributions are most welcome.