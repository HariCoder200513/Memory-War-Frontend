class CreatorApplication {
  final String id;
  final String userId;
  final String? username;
  final String avatar;
  final String role;
  final String reason;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  CreatorApplication({
    required this.id,
    required this.userId,
    this.username,
    this.avatar = 'orbit',
    this.role = 'player',
    required this.reason,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CreatorApplication.fromJson(Map<String, dynamic> json) {
    return CreatorApplication(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      username: json['username'] as String?,
      avatar: json['avatar'] as String? ?? 'orbit',
      role: json['role'] as String? ?? 'player',
      reason: json['reason'] as String? ?? '',
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
