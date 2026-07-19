class Event {
  final int? id;
  final String name;
  final String? startDate;
  final String? endDate;
  final bool? active;
  
  Event({
    this.id,
    required this.name,
    this.startDate,
    this.endDate,
    this.active,
  });
  
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      active: json['active'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
      'active': active,
    };
  }
}
