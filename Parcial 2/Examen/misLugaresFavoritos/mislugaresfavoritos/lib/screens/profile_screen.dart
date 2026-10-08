import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final int totalLugares;

  const ProfileScreen({super.key, required this.totalLugares});

  @override
  Widget build(BuildContext context) {
    final user = SupabaseService().currentUser;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.indigo,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              user?.email ?? 'Usuario',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Column(
                  children: [
                    Text(
                      '$totalLugares',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                    const Text('Lugares Guardados', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red,
                minimumSize: const Size(200, 48),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar Sesión'),
              onPressed: () async {
                await SupabaseService().signOut();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
