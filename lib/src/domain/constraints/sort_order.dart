/// An enumeration of {asc, desc}.
enum SortOrder {
  asc,
  desc;

  /// Returns the opposite [SortOrder].
  SortOrder flipped() => switch (this) {
        SortOrder.asc => SortOrder.desc,
        SortOrder.desc => SortOrder.asc,
      };

  /// Finds a [SortOrder] with the given [name].
  /// The name will be trimmed and lowercased before the search.
  ///
  /// If no sort order with such a name exists, throws a [StateError].
  static SortOrder fromName(String name) {
    final normalizedName = name.trim().toLowerCase();

    return values.firstWhere((order) => order.name == normalizedName);
  }
}
