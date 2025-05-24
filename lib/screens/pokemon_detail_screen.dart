import 'package:flutter/material.dart';
import 'package:list_of_pokemon/models/pokemon_detail_model.dart';
import 'package:lottie/lottie.dart';
import '../services/pokemon_detail_service.dart';
import '../widgets/pokemon_detail_widget.dart';

class PokemonDetailScreen extends StatefulWidget {
  final String pokemonUrl;

  const PokemonDetailScreen({super.key, required this.pokemonUrl});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  PokemonDetailModel? _pokemonDetail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPokemonDetail();
  }

  Future<void> _fetchPokemonDetail() async {
    try {
      final PokemonDetailModel detail = await fetchPokemonDetail(
        widget.pokemonUrl,
      );
      setState(() {
        _pokemonDetail = detail;
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
        title: Text(_pokemonDetail?.name.toUpperCase() ?? 'Детали покемона'),
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
              : _pokemonDetail != null
              ? SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        _pokemonDetail!.imageUrl,
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 20),
                    PokemonDetailWidget(
                      label: 'Имя:',
                      value: _pokemonDetail!.name.toUpperCase(),
                    ),
                    PokemonDetailWidget(
                      label: 'Рост:',
                      value: '${_pokemonDetail!.height / 10} м',
                    ),
                    PokemonDetailWidget(
                      label: 'Вес:',
                      value: '${_pokemonDetail!.weight / 10} кг',
                    ),
                    PokemonDetailWidget(
                      label: 'Типы:',
                      value: _pokemonDetail!.types.join(', '),
                    ),
                    PokemonDetailWidget(
                      label: 'Способности:',
                      value: _pokemonDetail!.abilities.join(', '),
                    ),
                  ],
                ),
              )
              : Center(child: Text('Нет данных о покемоне.')),
    );
  }
}
