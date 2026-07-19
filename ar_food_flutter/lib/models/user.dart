class User {
  final int? id;
  final String username;
  final String email;
  final String? password;
  final int? level;
  final int? xp;
  final int? coins;
  final String? avatar;
  
  User({
    this.id,
    required this.username,
    required this.email,
    this.password,
    this.level,
    this.xp,
    this.coins,
    this.avatar,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      level: json['level'],
      xp: json['xp'],
      coins: json['coins'],
      avatar: json['avatar'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      if (password != null) 'password': password,
      'level': level,
      'xp': xp,
      'coins': coins,
      'avatar': avatar,
    };
  }
}
