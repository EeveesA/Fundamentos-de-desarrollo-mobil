import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Curso Movil Hibrido',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _gender = 'Masculino';
  final Map<String, bool> _interests = {
    'Deporte': false,
    'Musica': false,
    'Cine': false,
    'Lectura': false,
  };
  String _selectedCountry = 'Mexico';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Preferencias'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Sección 1: Información General
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF3FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.info_outline, color: Color(0xFF1E6091)),
                      SizedBox(width: 8),
                      Text(
                        'Seccion 1: Informacion General',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E6091),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Completa los siguientes datos personales basicos',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Sección 2: Datos Personales
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF7EE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.person, color: Color(0xFF2D6A4F)),
                      SizedBox(width: 8),
                      Text(
                        'Seccion 2: Datos Personales',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D6A4F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Nombre completo',
                      prefixIcon: Icon(Icons.person),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Edad',
                      prefixIcon: Icon(Icons.calendar_today),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Sección 3: Distribución en Filas
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7EB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.view_module, color: Color(0xFFD97706)),
                      SizedBox(width: 8),
                      Text(
                        'Seccion 3: Distribucion en Filas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD6D6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.circle, color: Colors.red, size: 20),
                        SizedBox(width: 10),
                        Text('Fila 1 - Color Rojo', style: TextStyle(color: Color(0xFF7F1D1D))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: Colors.yellow.shade700, size: 20),
                        const SizedBox(width: 10),
                        const Text('Fila 2 - Color Amarillo', style: TextStyle(color: Color(0xFF78350F))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFBFDBFE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.circle, color: Colors.blue, size: 20),
                        SizedBox(width: 10),
                        Text('Fila 3 - Color Azul', style: TextStyle(color: Color(0xFF1E3A8A))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Sección 4: Cuatro Hijos en Colores
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.grid_on, color: Color(0xFF6B21A8)),
                      SizedBox(width: 8),
                      Text(
                        'Seccion 4: Cuatro Hijos en Colores',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B21A8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBCFE8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Text('Hijo 1', style: TextStyle(color: Color(0xFF9D174D), fontSize: 13)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDE68A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Text('Hijo 2', style: TextStyle(color: Color(0xFF92400E), fontSize: 13)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFA7F3D0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Text('Hijo 3', style: TextStyle(color: Color(0xFF065F46), fontSize: 13)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDDD6FE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Text('Hijo 4', style: TextStyle(color: Color(0xFF5B21B6), fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Sección 5: Controles UI
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.add_circle_outline, color: Color(0xFF334155)),
                      SizedBox(width: 8),
                      Text(
                        'Seccion 5: Controles UI',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Genero:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),

                  _buildRadioOption('Masculino'),
                  _buildRadioOption('Femenino'),
                  _buildRadioOption('Otro'),

                  const SizedBox(height: 12),
                  const Text('Intereses:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),

                  _buildCheckboxOption('Deporte'),
                  _buildCheckboxOption('Musica'),
                  _buildCheckboxOption('Cine'),
                  _buildCheckboxOption('Lectura'),

                  const SizedBox(height: 12),
                  const Text('Pais:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    initialValue: _selectedCountry,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.public),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Mexico', child: Text('Mexico')),
                      DropdownMenuItem(value: 'Estados Unidos', child: Text('Estados Unidos')),
                      DropdownMenuItem(value: 'Espana', child: Text('Espana')),
                      DropdownMenuItem(value: 'Argentina', child: Text('Argentina')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCountry = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.visibility, size: 18),
                          label: const Text('Mostrar Preferencias', style: TextStyle(fontSize: 11)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.check_circle, size: 18),
                          label: const Text('Guardar Registro', style: TextStyle(fontSize: 11)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Radio<String>(
            value: label,
            groupValue: _gender,
            onChanged: (value) {
              if (value != null) setState(() => _gender = value);
            },
            visualDensity: VisualDensity.compact,
          ),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildCheckboxOption(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Checkbox(
            value: _interests[label] ?? false,
            onChanged: (value) {
              if (value != null) setState(() => _interests[label] = value);
            },
            visualDensity: VisualDensity.compact,
          ),
          Text(label),
        ],
      ),
    );
  }
}