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
      title: 'Reserva de Viaje',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal.shade700,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F6F6),
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
  // Controladores de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Variables de estado
  String _selectedDestination = 'Playa';
  String _selectedTransport = 'Avión';
  bool _hotelExtra = false;
  bool _tourExtra = false;
  bool _insuranceExtra = false;
  bool _notifications = true;
  double _budget = 3000;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Limpiar formulario (Boton AppBar)
  void _clearForm() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _selectedDestination = 'Playa';
      _selectedTransport = 'Avión';
      _hotelExtra = false;
      _tourExtra = false;
      _insuranceExtra = false;
      _notifications = true;
      _budget = 3000;
      _selectedDate = null;
    });
    _showSnackBar('Formulario limpiado');
  }

  // Validación de campos obligatorios
  bool _isFormValid() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    return name.isNotEmpty && email.isNotEmpty && email.contains('@') && _selectedDate != null;
  }

  // Mostrar mensaje emergente
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Formatear fecha
  String _formatDate(DateTime? date) {
    if (date == null) return 'Toca para elegir fecha';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }

  // Obtener texto de extras seleccionados
  String _getExtrasString() {
    List<String> extras = [];
    if (_hotelExtra) extras.add('Hotel');
    if (_tourExtra) extras.add('Tour');
    if (_insuranceExtra) extras.add('Seguro');
    return extras.isEmpty ? 'Ninguno' : extras.join(', ');
  }

  // Modal de advertencia si faltan datos
  void _showMissingDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            CircleAvatar(
              backgroundColor: Color(0xFFFEE2E2),
              child: Icon(Icons.error_outline, color: Colors.red),
            ),
            SizedBox(width: 10),
            Text('Faltan datos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Completa nombre, correo válido (@) y selecciona la fecha del viaje.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Diálogo de Resumen
  void _showSummaryDialog() {
    if (!_isFormValid()) {
      _showMissingDataDialog();
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            CircleAvatar(
              backgroundColor: Color(0xFFE0F2FE),
              child: Icon(Icons.cleaning_services_outlined, color: Colors.teal),
            ),
            SizedBox(width: 10),
            Text('Resumen del Viaje', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSummaryRow(Icons.person, 'Nombre', _nameController.text),
            _buildSummaryRow(Icons.email, 'Correo', _emailController.text),
            _buildSummaryRow(Icons.location_on, 'Destino', _selectedDestination),
            _buildSummaryRow(Icons.directions_bus, 'Transporte', _selectedTransport),
            _buildSummaryRow(Icons.star, 'Extras', _getExtrasString()),
            _buildSummaryRow(Icons.notifications, 'Notificaciones', _notifications ? 'Activadas' : 'Desactivadas'),
            _buildSummaryRow(Icons.attach_money, 'Presupuesto', '\$${_budget.round()}'),
            _buildSummaryRow(Icons.calendar_today, 'Fecha', _formatDate(_selectedDate)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToTicketScreen();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.teal),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  // Navegar a Pantalla 2 (Mi Boleto)
  void _navigateToTicketScreen() {
    if (!_isFormValid()) {
      _showMissingDataDialog();
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketScreen(
          name: _nameController.text,
          email: _emailController.text,
          destination: _selectedDestination,
          transport: _selectedTransport,
          extras: _getExtrasString(),
          notifications: _notifications,
          budget: _budget.round(),
          date: _formatDate(_selectedDate),
        ),
      ),
    );
  }

  // Selector de fecha
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal.shade700,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      _showSnackBar('Fecha seleccionada: ${_formatDate(picked)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserva de Viaje', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            tooltip: 'Limpiar campos',
            onPressed: _clearForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // SECCIÓN 1: Información general
            _buildSectionContainer(
              color: const Color(0xFFE6F4F1),
              borderColor: const Color(0xFFB2DFDB),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFFB2DFDB),
                        child: Icon(Icons.info_outline, color: Colors.teal, size: 20),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sección 1 · Información general',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.teal),
                            ),
                            Text(
                              'Completa tu reserva paso a paso',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  const Text(
                    'Llena tus datos, elige destino y confirma tu viaje.',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // SECCIÓN 2: Datos del viajero
            _buildSectionContainer(
              color: const Color(0xFFF1F8F5),
              borderColor: const Color(0xFFC8E6C9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFFC8E6C9),
                        child: Icon(Icons.person, color: Colors.green, size: 20),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sección 2 · Datos del viajero',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                          Text(
                            '¿Quién se va de viaje?',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Ej: Ana Garcia',
                      labelText: 'Nombre completo',
                      prefixIcon: const Icon(Icons.person, color: Colors.green),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Ej: ana@correo.com',
                      labelText: 'Correo electrónico',
                      prefixIcon: const Icon(Icons.email, color: Colors.green),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // SECCIÓN 3: Destino y transporte
            _buildSectionContainer(
              color: const Color(0xFFFFF8E1),
              borderColor: const Color(0xFFFFECB3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFFFFECB3),
                        child: Icon(Icons.location_on, color: Colors.orange, size: 20),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sección 3 · Destino y transporte',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange),
                          ),
                          Text(
                            'Elige tu aventura',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDestinationCard('Playa', Icons.beach_access, Colors.blue),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDestinationCard('Ciudad', Icons.location_city, Colors.orange),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDestinationCard('Montaña', Icons.landscape, Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text('Transporte:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedTransport,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.flight, color: Colors.amber),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Avión', child: Text('Avión')),
                      DropdownMenuItem(value: 'Autobús', child: Text('Autobús')),
                      DropdownMenuItem(value: 'Tren', child: Text('Tren')),
                      DropdownMenuItem(value: 'Barco', child: Text('Barco')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedTransport = val);
                        _showSnackBar('Transporte seleccionado: $val');
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // SECCIÓN 4: Extras y preferencias
            _buildSectionContainer(
              color: const Color(0xFFF3E5F5),
              borderColor: const Color(0xFFE1BEE7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFFE1BEE7),
                        child: Icon(Icons.tune, color: Colors.purple, size: 20),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sección 4 · Extras y preferencias',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.purple),
                          ),
                          Text(
                            'Personaliza tu experiencia',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Hotel incluido
                  _buildCheckboxContainer(
                    title: 'Hotel incluido',
                    subtitle: '+ \$1200',
                    icon: Icons.hotel,
                    value: _hotelExtra,
                    onChanged: (val) {
                      setState(() => _hotelExtra = val ?? false);
                      _showSnackBar('Hotel: ${_hotelExtra ? "Añadido" : "Removido"}');
                    },
                  ),
                  const SizedBox(height: 8),

                  // Tour guiado
                  _buildCheckboxContainer(
                    title: 'Tour guiado',
                    subtitle: '+ \$600',
                    icon: Icons.tour,
                    value: _tourExtra,
                    onChanged: (val) {
                      setState(() => _tourExtra = val ?? false);
                      _showSnackBar('Tour guiado: ${_tourExtra ? "Añadido" : "Removido"}');
                    },
                  ),
                  const SizedBox(height: 8),

                  // Seguro de viaje
                  _buildCheckboxContainer(
                    title: 'Seguro de viaje',
                    subtitle: '+ \$400',
                    icon: Icons.health_and_safety,
                    value: _insuranceExtra,
                    onChanged: (val) {
                      setState(() => _insuranceExtra = val ?? false);
                      _showSnackBar('Seguro de viaje: ${_insuranceExtra ? "Añadido" : "Removido"}');
                    },
                  ),
                  const SizedBox(height: 12),

                  // Switch Notificaciones
                  Container(
                    decoration: BoxDecoration(
                      color: _notifications ? const Color(0xFFF3E8FF) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.purple.shade100),
                    ),
                    child: SwitchListTile(
                      title: const Text('Recibir notificaciones', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        _notifications ? 'Activadas' : 'Desactivadas',
                        style: TextStyle(
                          color: _notifications ? Colors.purple : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      value: _notifications,
                      activeColor: Colors.purple,
                      onChanged: (val) {
                        setState(() => _notifications = val);
                        _showSnackBar('Notificaciones: ${_notifications ? "Activadas" : "Desactivadas"}');
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Presupuesto Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Presupuesto:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '\$${_budget.round()}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _budget,
                    min: 500,
                    max: 10000,
                    divisions: 20,
                    activeColor: Colors.purple,
                    onChanged: (val) {
                      setState(() => _budget = val);
                    },
                  ),

                  const SizedBox(height: 8),

                  // Selector de Fecha
                  InkWell(
                    onTap: _selectDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.calendar_month, color: Colors.purple),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Fecha del viaje', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                Text(
                                  _formatDate(_selectedDate),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // SECCIÓN 5: Confirmar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade800,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.check_circle_outline, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Sección 5 · Confirmar',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Revisa tus datos antes de despegar 🚀',
                    style: TextStyle(fontSize: 12, color: Colors.teal.shade100),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _showSummaryDialog,
                          icon: const Icon(Icons.visibility, size: 16),
                          label: const Text('Ver Resumen', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.teal.shade900,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _navigateToTicketScreen,
                          icon: const Icon(Icons.flight_takeoff, size: 16),
                          label: const Text('Confirmar', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade600,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper para contenedor de secciones
  Widget _buildSectionContainer({required Color color, required Color borderColor, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }

  // Tarjeta de selección de destino (Playa, Ciudad, Montaña)
  Widget _buildDestinationCard(String label, IconData icon, Color activeColor) {
    bool isSelected = _selectedDestination == label;
    return InkWell(
      onTap: () {
        setState(() => _selectedDestination = label);
        _showSnackBar('Destino seleccionado: $label');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? activeColor : Colors.grey, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? activeColor : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CheckboxListTile dentro de Contenedor
  Widget _buildCheckboxContainer({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: value ? Colors.purple.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: value ? Colors.purple.shade300 : Colors.grey.shade300),
      ),
      child: CheckboxListTile(
        title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        secondary: Icon(icon, color: Colors.purple.shade400),
        value: value,
        activeColor: Colors.purple,
        onChanged: onChanged,
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }
}

// ==========================================
// PANTALLA 2: MI BOLETO
// ==========================================
class TicketScreen extends StatelessWidget {
  final String name;
  final String email;
  final String destination;
  final String transport;
  final String extras;
  final bool notifications;
  final int budget;
  final String date;

  const TicketScreen({
    super.key,
    required this.name,
    required this.email,
    required this.destination,
    required this.transport,
    required this.extras,
    required this.notifications,
    required this.budget,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Boleto', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  // Encabezado del boleto
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.teal.shade700, Colors.teal.shade500],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.flight_takeoff, color: Colors.white, size: 24),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade600,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                date,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const Icon(Icons.flight, color: Colors.white, size: 30),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '¡Buen viaje, $name!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          destination.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Imagen decorativa del boleto
                  Image.network(
                    'https://picsum.photos/id/1015/500/200',
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  // Contenido de detalles del boleto
                  Container(
                    color: const Color(0xFFF1F8F6),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Correo
                        _buildTicketDetailRow(
                          icon: Icons.email,
                          label: 'Correo',
                          value: email,
                        ),
                        const SizedBox(height: 12),

                        // Destino y Transporte
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.amber.shade100,
                              child: Icon(Icons.location_on, size: 16, color: Colors.amber.shade800),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Destino', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  Text(destination, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(transport, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Extras
                        _buildTicketDetailRow(
                          icon: Icons.star,
                          label: 'Extras',
                          value: extras,
                        ),
                        const SizedBox(height: 12),

                        // Notificaciones y Presupuesto
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.blue.shade100,
                              child: Icon(Icons.notifications, size: 16, color: Colors.blue.shade800),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Notificaciones', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  Text(
                                    notifications ? 'Activadas' : 'Desactivadas',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '\$$budget',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade700,
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

            const SizedBox(height: 20),

            // Botón de regresar y editar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Regresar y editar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade800,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketDetailRow({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: Colors.teal.shade100,
          child: Icon(icon, size: 16, color: Colors.teal.shade800),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ],
    );
  }
}