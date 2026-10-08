import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game_model.dart';

class EspnApiService {
  static const String _baseUrl =
      'https://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard';

  Future<List<Game>> fetchNflGames() async {
    try {
      // 1. Consultar la semana actual
      final currentResponse = await http.get(Uri.parse(_baseUrl));

      if (currentResponse.statusCode != 200) {
        throw Exception('Error en el servidor (${currentResponse.statusCode})');
      }

      final Map<String, dynamic> currentData = json.decode(currentResponse.body);
      final int currentWeek = currentData['week']?['number'] ?? 1;

      List<dynamic> allEvents = [];

      if (currentData['events'] != null) {
        allEvents.addAll(currentData['events']);
      }

      // 2. Si no estamos en la Semana 1, solicitar los partidos de la semana anterior (?week=N-1)
      if (currentWeek > 1) {
        final previousWeek = currentWeek - 1;
        final prevResponse = await http.get(Uri.parse('$_baseUrl?week=$previousWeek'));

        if (prevResponse.statusCode == 200) {
          final Map<String, dynamic> prevData = json.decode(prevResponse.body);
          if (prevData['events'] != null) {
            allEvents.addAll(prevData['events']);
          }
        }
      }

      // 3. Parsear juegos eliminando duplicados
      List<Game> games = [];
      Set<String> addedIds = {};

      for (var event in allEvents) {
        final game = Game.fromJson(event);
        if (!addedIds.contains(game.id)) {
          addedIds.add(game.id);
          games.add(game);
        }
      }

      return games;
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }
}