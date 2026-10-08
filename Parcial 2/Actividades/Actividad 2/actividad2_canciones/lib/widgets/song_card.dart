import 'package:flutter/material.dart';
import '../models/song_model.dart';

class SongCard extends StatelessWidget {
  final Song song;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const SongCard({
    super.key,
    required this.song,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.shade100,
          child: const Icon(Icons.music_note, color: Colors.deepPurple),
        ),
        title: Text(
          song.titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${song.artista} • ${song.duracionFormateada}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                song.favorita ? Icons.star : Icons.star_border,
                color: song.favorita ? Colors.amber : Colors.grey,
              ),
              onPressed: onFavoriteToggle,
            ),
            const Icon(Icons.play_circle_fill, color: Colors.deepPurple, size: 32),
          ],
        ),
      ),
    );
  }
}