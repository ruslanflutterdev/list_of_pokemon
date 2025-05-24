import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:list_of_pokemon/models/pokemon_model.dart';

Future<Map<String, dynamic>> fetchPokemonList({int offset = 0, int limit = 20}) async {
  final url = Uri.parse(
    'https://pokeapi.co/api/v2/pokemon/?offset=$offset&limit=$limit',
  );
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('results') && data['results'] != null) {
        final List<dynamic> pokemonJsonList = data['results'];
        final List<PokemonModel> pokemonList = pokemonJsonList
            .map((json) => PokemonModel.fromJson(json))
            .toList();
        return {
          'pokemonList': pokemonList,
          'nextUrl': data['next'],
        };
      } else {
        throw Exception('В ответе API нет поля "results"');
      }
    } else {
      throw Exception(
        'Ошибка при загрузке списка покемонов: ${response.statusCode}',
      );
    }
  } catch (e) {
    throw Exception('Произошла ошибка при загрузке списка покемонов: $e');
  }
}