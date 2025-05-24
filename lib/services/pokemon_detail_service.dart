import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:list_of_pokemon/models/pokemon_detail_model.dart';

Future<PokemonDetailModel> fetchPokemonDetail(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return PokemonDetailModel.fromJson(data);
    } else {
      throw Exception(
          'Ошибка при загрузке информации о покемоне: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Произошла ошибка при загрузке данных: $e');
  }
}