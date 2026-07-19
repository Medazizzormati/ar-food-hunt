class FoodTruck {
  final int? id;
  final String name;
  final String? category;
  final double? latitude;
  final double? longitude;
  final String? description;
  
  FoodTruck({
    this.id,
    required this.name,
    this.category,
    this.latitude,
    this.longitude,
    this.description,
  });
  
  factory FoodTruck.fromJson(Map<String, dynamic> json) {
    return FoodTruck(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      description: json['description'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
    };
  }
}
