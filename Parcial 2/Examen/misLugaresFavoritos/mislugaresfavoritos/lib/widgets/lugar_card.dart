import 'package:flutter/material.dart';
import '../models/lugar_model.dart';

class LugarCard extends StatelessWidget {
  final Lugar lugar;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LugarCard({
    super.key,
    required this.lugar,
    required this.onEdit,
    required this.onDelete,
  });

  IconData _getCategoryIcon(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'comida':
        return Icons.restaurant;
      case 'estudio':
        return Icons.school;
      case 'diversión':
      case 'diversion':
        return Icons.attractions;
      case 'gym':
        return Icons.fitness_center;
      case 'casa':
        return Icons.home;
      default:
        return Icons.place;
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar lugar?'),
        content: Text('¿Estás seguro de eliminar "${lugar.nombre}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              onDelete();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lugar.imagenUrl != null && lugar.imagenUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                lugar.imagenUrl!,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 100,
                  color: Colors.grey.shade200,
                  child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                ),
              ),
            ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.indigo.shade100,
              child: Icon(_getCategoryIcon(lugar.categoria), color: Colors.indigo),
            ),
            title: Text(
              lugar.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: Text(lugar.categoria, style: const TextStyle(fontSize: 11)),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
                if (lugar.descripcion != null && lugar.descripcion!.isNotEmpty)
                  Text(lugar.descripcion!, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.indigo),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _confirmDelete(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
