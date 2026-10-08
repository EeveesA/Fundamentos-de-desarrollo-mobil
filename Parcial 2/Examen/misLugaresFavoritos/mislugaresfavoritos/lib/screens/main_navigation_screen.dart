import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/lugar_model.dart';
import '../services/supabase_service.dart';
import '../services/location_service.dart'; 
import '../widgets/lugar_card.dart';
import 'lugar_form_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _GestorNavegacionPrincipal();
}

class _GestorNavegacionPrincipal extends State<MainNavigationScreen> {
  int _vistaActual = 0;
  List<Lugar> _listaLugares = [];
  bool _estaCargando = true;
  String _terminoBusqueda = '';
  String _filtroCategoria = 'Todas';

@override
  void initState() {
    super.initState(); // 1. Siempre primero
    _obtenerMiUbicacionGPS();
    _sincronizarDatos();
  }

  Future<void> _sincronizarDatos() async {
    setState(() => _estaCargando = true);
    try {
      final lugaresObtenidos = await SupabaseService().fetchLugares();
      if (mounted) {
        setState(() {
          _listaLugares = lugaresObtenidos;
          _estaCargando = false;
        });
      }
    } catch (error) {
      if (mounted) setState(() => _estaCargando = false);
    }
  }

  // Lógica para filtrar por nombre y categoría
  List<Lugar> get _lugaresProcesados {
    return _listaLugares.where((lugar) {
      final coincideNombre = lugar.nombre.toLowerCase().contains(_terminoBusqueda.toLowerCase());
      final coincideCategoria = _filtroCategoria == 'Todas' || lugar.categoria == _filtroCategoria;
      return coincideNombre && coincideCategoria;
    }).toList();
  }

LatLng? _miUbicacionActual;

  // Llama a esto en tu initState() junto con _sincronizarDatos()
  Future<void> _obtenerMiUbicacionGPS() async {
    final pos = await LocationService.getCurrentLocation();
    if (mounted) {
      setState(() {
        _miUbicacionActual = pos;
      });
    }
  }

  Widget _construirMapa() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: _miUbicacionActual ?? const LatLng(22.1565, -100.9855), // Centra en ti si ya cargó, si no por defecto
        initialZoom: 14.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.examen.mislugares',
        ),
        MarkerLayer(
          markers: [
            // 1. Tu marcador de ubicación actual (Punto azul)
            if (_miUbicacionActual != null)
              Marker(
                point: _miUbicacionActual!,
                width: 35,
                height: 35,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: const [
                      BoxShadow(blurRadius: 4, color: Colors.black26, offset: Offset(0, 2))
                    ],
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 8,
                      height: 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // 2. Los pines de tus lugares guardados de Supabase
            ..._lugaresProcesados.map((lugarItem) {
              return Marker(
                point: LatLng(lugarItem.latitud, lugarItem.longitud),
                width: 40,
                height: 40,
                child: const Icon(Icons.location_on, color: Colors.red, size: 40),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _construirLista() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Buscar lugar...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (valor) => setState(() => _terminoBusqueda = valor),
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: _filtroCategoria,
                items: ['Todas', 'Comida', 'Estudio', 'Diversión', 'Gym', 'Casa', 'Otro']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (valor) => setState(() => _filtroCategoria = valor!),
              ),
            ],
          ),
        ),
        Expanded(
          child: _lugaresProcesados.isEmpty
              ? const Center(child: Text('No tienes lugares aquí.'))
              : ListView.builder(
                  itemCount: _lugaresProcesados.length,
                  itemBuilder: (ctx, i) {
                    final lugar = _lugaresProcesados[i];
                    return LugarCard(
                      lugar: lugar,
                      onEdit: () async {
                        final recargar = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LugarFormScreen(lugar: lugar)),
                        );
                        if (recargar == true) _sincronizarDatos();
                      },
                      onDelete: () async {
                        await SupabaseService().deleteLugar(lugar.id);
                        _sincronizarDatos();
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Lugares'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _estaCargando
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _vistaActual,
              children: [
                _construirMapa(),
                _construirLista(),
                ProfileScreen(totalLugares: _listaLugares.length),
              ],
            ),
      floatingActionButton: _vistaActual != 2 // Oculta el botón en el perfil
          ? FloatingActionButton(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              onPressed: () async {
                final recargar = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LugarFormScreen()),
                );
                if (recargar == true) _sincronizarDatos();
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _vistaActual,
        selectedItemColor: Colors.indigo,
        onTap: (indice) => setState(() => _vistaActual = indice),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Lista'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}