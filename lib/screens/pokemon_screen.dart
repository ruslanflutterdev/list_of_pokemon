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
  bool _isLoadingMore = false;
  String? _error;
  String? _nextUrl;
  int _offset = 0;

  @override
  void initState() {
    super.initState();
    _fetchPokemons();
  }

  Future<void> _fetchPokemons({bool loadMore = false}) async {
    if (_isLoadingMore) return;

    try {
      if (loadMore) {
        setState(() {
          _isLoadingMore = true;
        });
      } else {
        setState(() {
          _isLoading = true;
        });
      }

      final Map<String, dynamic> result = await fetchPokemonList(
        offset: _offset,
      );
      final List<PokemonModel> newPokemons = result['pokemonList'];
      final String? nextUrl = result['nextUrl'];

      setState(() {
        if (loadMore) {
          _pokemonList.addAll(newPokemons);
        } else {
          _pokemonList = newPokemons;
        }
        _nextUrl = nextUrl;
        _offset += 20;
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
        _isLoadingMore = false;
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
                  fit: BoxFit.contain,
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
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          _pokemonList.length + (_nextUrl != null ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (_nextUrl != null && index == _pokemonList.length) {
                          return Padding(
                            padding: EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: () => _fetchPokemons(loadMore: true),
                              child:
                                  _isLoadingMore
                                      ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                      : Text('Загрузить ещё'),
                            ),
                          );
                        }
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
                                    (context) => PokemonDetailScreen(
                                      pokemonUrl: pokemon.url,
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
