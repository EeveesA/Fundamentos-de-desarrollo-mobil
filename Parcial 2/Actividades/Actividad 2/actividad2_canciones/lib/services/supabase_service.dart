import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/song_model.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  // Obtener todas las canciones
  Future<List<Song>> fetchSongs() async {
    final response = await _client
        .from('canciones')
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((json) => Song.fromMap(json)).toList();
  }

  // Alternar canción favorita
  Future<void> toggleFavorite(int songId, bool currentStatus) async {
    await _client
        .from('canciones')
        .update({'favorita': !currentStatus})
        .eq('id', songId);
  }
}