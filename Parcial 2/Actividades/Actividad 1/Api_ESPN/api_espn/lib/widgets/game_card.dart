import 'package:flutter/material.dart';
import '../models/game_model.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    // Definimos el texto y color del badge de la izquierda
    String statusText;
    Color statusColor;

    if (game.isInProgress) {
      statusText = 'EN VIVO';
      statusColor = Colors.red;
    } else if (game.isCompleted) {
      statusText = 'FINAL';
      statusColor = Colors.blueGrey;
    } else {
      // Si es un partido próximo, mostramos solo el estado base o "PROGRAMADO"
      statusText = 'PROGRAMADO';
      statusColor = Colors.teal;
    }

    // Formato simple de fecha para el lado derecho
    final String formattedDate =
        '${game.date.day.toString().padLeft(2, '0')}/${game.date.month.toString().padLeft(2, '0')}/${game.date.year}';

    // Formato de hora (ej: 20:15)
    final String formattedTime =
        '${game.date.hour.toString().padLeft(2, '0')}:${game.date.minute.toString().padLeft(2, '0')} hrs';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Encabezado de la tarjeta
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      game.isUpcoming ? '$formattedDate - $formattedTime' : formattedDate,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Marcador / Enfrentamiento
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _buildTeamColumn(game.awayTeam)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: game.isUpcoming
                      ? const Text(
                          'VS',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey),
                        )
                      : Column(
                          children: [
                            Text(
                              '${game.awayTeam.score} - ${game.homeTeam.score}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                            if (game.statusDetail.contains('OT'))
                              const Text(
                                'T. Extra',
                                style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                ),
                Expanded(child: _buildTeamColumn(game.homeTeam)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamColumn(Team team) {
    return Column(
      children: [
        team.logoUrl.isNotEmpty
            ? Image.network(
                team.logoUrl,
                height: 48,
                width: 48,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.sports_football, size: 48, color: Colors.grey),
              )
            : const Icon(Icons.sports_football, size: 48, color: Colors.grey),
        const SizedBox(height: 6),
        Text(
          team.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}