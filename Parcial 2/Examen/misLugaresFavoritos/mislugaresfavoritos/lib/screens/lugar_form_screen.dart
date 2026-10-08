import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import '../models/lugar_model.dart';
import '../services/location_service.dart';
import '../services/supabase_service.dart';

class LugarFormScreen extends StatefulWidget {
  final Lugar? lugar; // null para crear, objeto para editar

  const LugarFormScreen({super.key, this.lugar});

  @override
  State<LugarFormScreen> createState() => _LugarFormScreenState();
}

class _LugarFormScreenState extends State<LugarFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  
  String _categoria = 'Comida';
  final List<String> _categorias = ['Comida', 'Estudio', 'Diversión', 'Gym', 'Casa', 'Otro'];

  LatLng _selectedLocation = LocationService.defaultLocation;
  XFile? _selectedImage;
  String? _currentImageUrl;
  bool _isLoading = false;

@override
  void initState() {
    super.initState();
    if (widget.lugar != null) {
      _nombreController.text = widget.lugar!.nombre;
      _descripcionController.text = widget.lugar!.descripcion ?? '';
      _categoria = _categorias.contains(widget.lugar!.categoria) ? widget.lugar!.categoria : 'Otro';
      _selectedLocation = LatLng(widget.lugar!.latitud, widget.lugar!.longitud);
      _currentImageUrl = widget.lugar!.imagenUrl;
    }
    
  }

  Future<void> _loadCurrentLocation() async {
    final loc = await LocationService.getCurrentLocation();
    if (mounted) {
      setState(() => _selectedLocation = loc);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      setState(() => _selectedImage = pickedFile);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String? imageUrl = _currentImageUrl;
      if (_selectedImage != null) {
        imageUrl = await SupabaseService().uploadFoto(_selectedImage!);
      }

      final service = SupabaseService();

      if (widget.lugar == null) {
        // Crear
        final nuevoLugar = Lugar(
          id: '',
          userId: service.currentUser!.id,
          nombre: _nombreController.text.trim(),
          descripcion: _descripcionController.text.trim(),
          categoria: _categoria,
          latitud: _selectedLocation.latitude,
          longitud: _selectedLocation.longitude,
          imagenUrl: imageUrl,
          createdAt: DateTime.now(),
        );
        await service.createLugar(nuevoLugar);
      } else {
        // Editar
        await service.updateLugar(widget.lugar!.id, {
          'nombre': _nombreController.text.trim(),
          'descripcion': _descripcionController.text.trim(),
          'categoria': _categoria,
          'latitud': _selectedLocation.latitude,
          'longitud': _selectedLocation.longitude,
          'imagen_url': imageUrl,
        });
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lugar == null ? 'Agregar Lugar' : 'Editar Lugar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre del Lugar *', border: OutlineInputBorder()),
                validator: (val) => val == null || val.trim().isEmpty ? 'Ingresa un nombre' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _categoria,
                decoration: const InputDecoration(labelText: 'Categoría', border: OutlineInputBorder()),
                items: _categorias.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) => setState(() => _categoria = val!),
              ),
              const SizedBox(height: 16),

              // Selector de foto
              const Text('Foto del lugar:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickImage,
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: _selectedImage != null
                      ? const Center(child: Text('📷 Foto seleccionada (lista para subir)'))
                      : (_currentImageUrl != null
                          ? Image.network(_currentImageUrl!, fit: BoxFit.cover)
                          : const Center(child: Icon(Icons.add_a_photo, size: 40, color: Colors.grey))),
                ),
              ),
              const SizedBox(height: 16),

              // ==========================================
              // AQUÍ VA LA SEGUNDA PARTE DENTRO DEL BUILD
              // ==========================================
              OutlinedButton.icon(
                onPressed: () async {
                  final ubicacionActual = await LocationService.getCurrentLocation();
                  setState(() {
                    _selectedLocation = ubicacionActual;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ubicación actualizada a tu posición GPS actual')),
                  );
                },
                icon: const Icon(Icons.my_location),
                label: const Text('Centrar en mi ubicación GPS'),
              ),
              const SizedBox(height: 8),

              const Text('O haz clic en el mapa para elegir el punto exacto:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 220,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: _selectedLocation,
                      initialZoom: 14.0,
                      onTap: (_, point) {
                        setState(() => _selectedLocation = point);
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.examen.mislugares',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _selectedLocation,
                            width: 40,
                            height: 40,
                            child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // ==========================================

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Guardar Lugar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}