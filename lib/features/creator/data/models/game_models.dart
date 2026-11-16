class Game {
  final String id;
  final String creatorId;
  final String name;
  final String description;
  final String category;
  final int gridRows;
  final int gridColumns;
  final List<String> cardIcons;
  final String cardBack;
  final int timeLimitSeconds;
  final int moveLimit;
  final int mismatchDelayMs;
  final bool allowHints;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Game({
    required this.id,
    required this.creatorId,
    required this.name,
    required this.description,
    required this.category,
    required this.gridRows,
    required this.gridColumns,
    required this.cardIcons,
    required this.cardBack,
    required this.timeLimitSeconds,
    required this.moveLimit,
    required this.mismatchDelayMs,
    required this.allowHints,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        id: json['id'] as String,
        creatorId: json['creator_id'] as String,
        name: json['name'] as String,
        description: (json['description'] as String?) ?? '',
        category: json['category'] as String,
        gridRows: json['grid_rows'] as int,
        gridColumns: json['grid_columns'] as int,
        cardIcons: (json['card_icons'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        cardBack: (json['card_back'] as String?) ?? 'classic',
        timeLimitSeconds: (json['time_limit_seconds'] as int?) ?? 120,
        moveLimit: (json['move_limit'] as int?) ?? 0,
        mismatchDelayMs: (json['mismatch_delay_ms'] as int?) ?? 1000,
        allowHints: (json['allow_hints'] as bool?) ?? true,
        status: json['status'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );
}
