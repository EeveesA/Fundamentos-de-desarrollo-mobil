import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../services/supabase_service.dart';
import '../widgets/song_card.dart';
import 'player_screen.dart';

class SongListScreen extends StatefulWidget {
  const SongListScreen({super.key});

  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  late Future<List<Song>> _songsFuture;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  void _loadSongs() {
    setState(() {
      _songsFuture = _supabaseService.fetchSongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca Vocaloid'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSongs,
          ),
        ],
      ),
      body: FutureBuilder<List<Song>>(
        future: _songsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar canciones: ${snapshot.error}'),
            );
          }

          final songs = snapshot.data ?? [];

          if (songs.isEmpty) {
            return const Center(
              child: Text('No hay canciones registradas en la base de datos.'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _loadSongs(),
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return SongCard(
                  song: song,
                  onFavoriteToggle: () async {
                    await _supabaseService.toggleFavorite(song.id, song.favorita);
                    _loadSongs();
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(song: song),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}