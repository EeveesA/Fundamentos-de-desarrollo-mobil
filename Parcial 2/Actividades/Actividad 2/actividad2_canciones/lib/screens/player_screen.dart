import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';

class PlayerScreen extends StatefulWidget {
  final Song song;

  const PlayerScreen({super.key, required this.song});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    if (widget.song.audioUrl == null || widget.song.audioUrl!.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Esta canción no tiene una URL de audio asignada.';
      });
      return;
    }

    try {
      await _audioPlayer.setUrl(widget.song.audioUrl!);
      setState(() {
        _isLoading = false;
      });
      _audioPlayer.play();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar el archivo de audio desde Supabase.';
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '0:00';
    final minutes = duration.inMinutes;
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.titulo),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Carátula o Arte de la Canción
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.music_note,
                size: 100,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 32),

            // Título y Artista
            Text(
              widget.song.titulo,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.song.artista,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            if (widget.song.album != null) ...[
              const SizedBox(height: 4),
              Text(
                'Álbum: ${widget.song.album}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],

            const SizedBox(height: 32),

            // Reproductor y Controles
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              )
            else ...[
              // Barra de progreso interactiva
              StreamBuilder<Duration>(
                stream: _audioPlayer.positionStream,
                builder: (context, snapshotPosition) {
                  final position = snapshotPosition.data ?? Duration.zero;
                  final duration = _audioPlayer.duration ?? Duration.zero;

                  final maxDuration = duration.inMilliseconds.toDouble() > 0
                      ? duration.inMilliseconds.toDouble()
                      : 1.0;

                  final currentPosition = position.inMilliseconds
                      .toDouble()
                      .clamp(0.0, maxDuration);

                  return Column(
                    children: [
                      Slider(
                        activeColor: Colors.deepPurple,
                        min: 0.0,
                        max: maxDuration,
                        value: currentPosition,
                        onChanged: (value) {
                          _audioPlayer.seek(
                            Duration(milliseconds: value.toInt()),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(position)),
                            Text(_formatDuration(duration)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),

              // Botón de Play / Pausa / Replay
              StreamBuilder<PlayerState>(
                stream: _audioPlayer.playerStateStream,
                builder: (context, snapshotState) {
                  final playerState = snapshotState.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing ?? false;

                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
                    return const CircularProgressIndicator();
                  } else if (!playing) {
                    return IconButton(
                      iconSize: 72,
                      icon: const Icon(Icons.play_circle_fill),
                      color: Colors.deepPurple,
                      onPressed: _audioPlayer.play,
                    );
                  } else if (processingState != ProcessingState.completed) {
                    return IconButton(
                      iconSize: 72,
                      icon: const Icon(Icons.pause_circle_filled),
                      color: Colors.deepPurple,
                      onPressed: _audioPlayer.pause,
                    );
                  } else {
                    return IconButton(
                      iconSize: 72,
                      icon: const Icon(Icons.replay_circle_filled),
                      color: Colors.deepPurple,
                      onPressed: () => _audioPlayer.seek(Duration.zero),
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}