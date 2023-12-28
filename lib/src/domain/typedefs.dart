/// A Map from String keys matching any values.
///
/// In this library, keys are query parameter names and values are the values.
/// The value can be a List. In this case, it means the key has multiple values assigned to it.
///
/// To use the QueryParams correctly with `package:http`, you will need to pass them to any [Uri]
/// constructor.
///
/// For example, this is a paginated GET request using `http`:
/// ```dart
/// http.get(Uri.https('example.com', 'endpoint', params);
/// ```
///
/// where `params` is a [QueryParams] in a `fetcher` function in PaginatedView.
typedef QueryParams = Map<String, Object?>;

/// A Dart representation of JSON.
typedef JsonMap = Map<String, dynamic>;

/// A function decoding an object of type [T] from the given [json].
typedef FromJsonDecoder<T> = T Function(JsonMap json);
