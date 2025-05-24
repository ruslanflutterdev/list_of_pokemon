import 'package:flutter/material.dart';
import 'package:list_of_pokemon/services/pokemon_service.dart';
import 'package:lottie/lottie.dart';
import '../models/pokemon_model.dart';
import 'pokemon_detail_screen.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  List<PokemonModel> _pokemonList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPokemons();
  }

  Future<void> _fetchPokemons() async {
    try {
      final List<PokemonModel> pokemons = await fetchPokemonList();
      setState(() {
        _pokemonList = pokemons;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список покемонов'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? Center(
                child: Lottie.asset(
                  'assets/animation_loading.json',
                  width: 200,
                  height: 200,
                  repeat: true,
                  fit: BoxFit.cover,
                ),
              )
              : _error != null
              ? Center(
                child: Text(
                  'Ошибка загрузки: $_error',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              )
              : ListView.builder(
                itemCount: _pokemonList.length,
                itemBuilder: (context, index) {
                  final pokemon = _pokemonList[index];
                  return ListTile(
                    leading: Text(
                      '${index + 1}.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    title: Text(
                      pokemon.name.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  PokemonDetailScreen(pokemonUrl: pokemon.url),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
