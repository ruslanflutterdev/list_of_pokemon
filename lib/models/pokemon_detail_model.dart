class PokemonDetailModel {
  final String name;
  final String imageUrl;
  final int height;
  final int weight;
  final List<String> types;
  final List<String> abilities;

  PokemonDetailModel({
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
  });

  factory PokemonDetailModel.fromJson(Map<String, dynamic> json) {
    final List<String> types =
        (json['types'] as List)
            .map((typeJson) => typeJson['type']['name'] as String)
            .toList();
    final List<String> abilities =
        (json['abilities'] as List)
            .map((abilityJson) => abilityJson['ability']['name'] as String)
            .toList();

    return PokemonDetailModel(
      name: json['name'] as String,
      imageUrl: json['sprites']['from_default'] as String,
      height: json['height'] as int,
      weight: json['weight'] as int,
      types: types,
      abilities: abilities,
    );
  }
}
