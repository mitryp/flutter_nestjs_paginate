class CityDto {
  final int id;
  final String name;
  final int population;

  const CityDto({
    required this.id,
    required this.name,
    required this.population,
  });

  factory CityDto.fromJson(Map<String, dynamic> json) => CityDto(
        id: json['id'] as int,
        name: json['name'] as String,
        population: json['population'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'population': population,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          population == other.population;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ population.hashCode;
}
