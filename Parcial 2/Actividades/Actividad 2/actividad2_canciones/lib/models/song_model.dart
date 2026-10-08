class Song {
  final int id;
  final String titulo;
  final String artista;
  final String? album;
  final int? anio;
  final int? duracionSeg;
  final bool favorita;
  final String? audioUrl;

  Song({
    required this.id,
    required this.titulo,
    required this.artista,
    this.album,
    this.anio,
    this.duracionSeg,
    required this.favorita,
    this.audioUrl,
  });

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      titulo: map['titulo'],
      artista: map['artista'],
      album: map['album'],
      anio: map['anio'],
      duracionSeg: map['duracion_seg'],
      favorita: map['favorita'] ?? false,
      audioUrl: map['audio_url'],
    );
  }

  String get duracionFormateada {
    if (duracionSeg == null) return '--:--';
    final minutos = duracionSeg! ~/ 60;
    final segundos = (duracionSeg! % 60).toString().padLeft(2, '0');
    return '$minutos:$segundos';
  }
}