import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../services/espn_api_service.dart';
import '../widgets/game_card.dart';

class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen({super.key});

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final EspnApiService _apiService = EspnApiService();
  late Future<List<Game>> _gamesFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadGames();
  }

  void _loadGames() {
    setState(() {
      _gamesFuture = _apiService.fetchNflGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados NFL', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadGames,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.amber,
          tabs: const [
            Tab(icon: Icon(Icons.history), text: 'Recientes'),
            Tab(icon: Icon(Icons.event), text: 'Próximos'),
          ],
        ),
      ),
      body: FutureBuilder<List<Game>>(
        future: _gamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _loadGames,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final games = snapshot.data ?? [];
          final recentGames = games.where((g) => g.isCompleted || g.isInProgress).toList();
          final upcomingGames = games.where((g) => g.isUpcoming).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildGameList(recentGames, 'No hay partidos recientes o finalizados.'),
              _buildGameList(upcomingGames, 'No hay próximos partidos programados.'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGameList(List<Game> games, String emptyMessage) {
    if (games.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _loadGames(),
      child: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          return GameCard(game: games[index]);
        },
      ),
    );
  }
}