class Lugar {
  final String id;
  final String userId;
  final String nombre;
  final String? descripcion;
  final String categoria;
  final double latitud;
  final double longitud;
  final String? imagenUrl;
  final DateTime createdAt;

  Lugar({
    required this.id,
    required this.userId,
    required this.nombre,
    this.descripcion,
    required this.categoria,
    required this.latitud,
    required this.longitud,
    this.imagenUrl,
    required this.createdAt,
  });

  factory Lugar.fromMap(Map<String, dynamic> map) {
    return Lugar(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'],
      categoria: map['categoria'] ?? 'Otro',
      latitud: (map['latitud'] as num).toDouble(),
      longitud: (map['longitud'] as num).toDouble(),
      imagenUrl: map['imagen_url'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria,
      'latitud': latitud,
      'longitud': longitud,
      'imagen_url': imagenUrl,
    };
  }
}