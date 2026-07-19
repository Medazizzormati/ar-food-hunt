class Collectible {
  final int? id;
  final String name;
  final String? model3D;
  final String? type;
  final int? xpReward;
  final int? coinReward;
  final double? latitude;
  final double? longitude;
  final bool? available;
  
  Collectible({
    this.id,
    required this.name,
    this.model3D,
    this.type,
    this.xpReward,
    this.coinReward,
    this.latitude,
    this.longitude,
    this.available,
  });
  
  factory Collectible.fromJson(Map<String, dynamic> json) {
    return Collectible(
      id: json['id'],
      name: json['name'],
      model3D: json['model3D'],
      type: json['type'],
      xpReward: json['xpReward'],
      coinReward: json['coinReward'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      available: json['available'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model3D': model3D,
      'type': type,
      'xpReward': xpReward,
      'coinReward': coinReward,
      'latitude': latitude,
      'longitude': longitude,
      'available': available,
    };
  }
}
