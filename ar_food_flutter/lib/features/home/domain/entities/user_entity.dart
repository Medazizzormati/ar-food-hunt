class UserEntity {
  final int id;
  final String username;
  final String email;
  final String role;
  final int coins;
  final int xp;
  final int level;
  final bool accountEnabled;
  final bool accountNonLocked;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.coins,
    required this.xp,
    required this.level,
    required this.accountEnabled,
    required this.accountNonLocked,
    required this.createdAt,
    required this.updatedAt,
  });

  UserEntity copyWith({
    int? id,
    String? username,
    String? email,
    String? role,
    int? coins,
    int? xp,
    int? level,
    bool? accountEnabled,
    bool? accountNonLocked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      coins: coins ?? this.coins,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      accountEnabled: accountEnabled ?? this.accountEnabled,
      accountNonLocked: accountNonLocked ?? this.accountNonLocked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
