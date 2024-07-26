class Driver {
  final int id;
  final String name;
  final String carModel;
  final double rating;
  final double latitude;
  final double longitude;

  Driver({
    required this.id,
    required this.name,
    required this.carModel,
    required this.rating,
    required this.latitude,
    required this.longitude,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      name: json['name'],
      carModel: json['car_model'],
      rating: json['rating'],
      latitude: json['location']['latitude'],
      longitude: json['location']['longitude'],
    );
  }
}
