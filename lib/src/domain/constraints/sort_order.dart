enum SortOrder {
  asc,
  desc;

  SortOrder flipped() => switch (this) {
        SortOrder.asc => SortOrder.desc,
        SortOrder.desc => SortOrder.asc,
      };

  static SortOrder fromName(String name) {
    final normalizedName = name.trim().toLowerCase();

    return values.firstWhere((order) => order.name == normalizedName);
  }
}
