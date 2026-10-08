class Team {
  final String id;
  final String name;
  final String abbreviation;
  final String logoUrl;
  final String score;
  final bool isHome;

  Team({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.logoUrl,
    required this.score,
    required this.isHome,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    final teamData = json['team'] ?? {};
    
    String logo = '';
    if (teamData['logo'] != null) {
      logo = teamData['logo'];
    } else if (teamData['logos'] != null && (teamData['logos'] as List).isNotEmpty) {
      logo = teamData['logos'][0]['href'] ?? '';
    }

    return Team(
      id: teamData['id']?.toString() ?? '',
      name: teamData['displayName'] ?? teamData['name'] ?? 'Equipo',
      abbreviation: teamData['abbreviation'] ?? '',
      logoUrl: logo,
      score: json['score']?.toString() ?? '0',
      isHome: json['homeAway'] == 'home',
    );
  }
}

class Game {
  final String id;
  final String name;
  final String shortName;
  final DateTime date;
  final String statusState; // "pre", "in", "post"
  final bool completed;
  final String statusDetail;
  final Team homeTeam;
  final Team awayTeam;

  Game({
    required this.id,
    required this.name,
    required this.shortName,
    required this.date,
    required this.statusState,
    required this.completed,
    required this.statusDetail,
    required this.homeTeam,
    required this.awayTeam,
  });

  bool get isCompleted => completed || statusState == 'post';
  bool get isInProgress => statusState == 'in';
  bool get isUpcoming => !completed && statusState == 'pre';

  factory Game.fromJson(Map<String, dynamic> json) {
    final competition = (json['competitions'] as List?)?.first;
    final competitors = (competition?['competitors'] as List?) ?? [];

    Team home = Team(id: '', name: 'Local', abbreviation: 'HOME', logoUrl: '', score: '0', isHome: true);
    Team away = Team(id: '', name: 'Visitante', abbreviation: 'AWAY', logoUrl: '', score: '0', isHome: false);

    for (var competitor in competitors) {
      final team = Team.fromJson(competitor);
      if (team.isHome) {
        home = team;
      } else {
        away = team;
      }
    }

    final statusObj = json['status']?['type'] ?? {};

    return Game(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      shortName: json['shortName'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      statusState: statusObj['state'] ?? 'pre',
      completed: statusObj['completed'] ?? false,
      statusDetail: statusObj['shortDetail'] ?? statusObj['description'] ?? 'Programado',
      homeTeam: home,
      awayTeam: away,
    );
  }
}