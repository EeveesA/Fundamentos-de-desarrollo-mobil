import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/lugar_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;

  // --- AUTENTICACIÓN ---
  Future<AuthResponse> signUp(String email, String password) async {
    return await _client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // --- CRUD DE LUGARES ---
  Future<List<Lugar>> fetchLugares() async {
    final response = await _client
        .from('lugares')
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((json) => Lugar.fromMap(json)).toList();
  }

  Future<void> createLugar(Lugar lugar) async {
    await _client.from('lugares').insert({
      ...lugar.toMap(),
      'user_id': currentUser!.id,
    });
  }

  Future<void> updateLugar(String id, Map<String, dynamic> data) async {
    await _client.from('lugares').update(data).eq('id', id);
  }

  Future<void> deleteLugar(String id) async {
    await _client.from('lugares').delete().eq('id', id);
  }

  // --- STORAGE (FOTOS) ---
  Future<String?> uploadFoto(XFile file) async {
    try {
      final bytes = await file.readAsBytes();
      final fileExt = file.name.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = '${currentUser!.id}/$fileName';

      await _client.storage.from('lugares_fotos').uploadBinary(
            filePath,
            bytes,
          );

      final imageUrl = _client.storage.from('lugares_fotos').getPublicUrl(filePath);
      return imageUrl;
    } catch (e) {
      return null;
    }
  }
}