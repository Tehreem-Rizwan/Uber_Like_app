class User {
  final int id;
  final String name;
  final String email;
  final double latitude;
  final double longitude;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.latitude,
    required this.longitude,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      latitude: json['location']['latitude'],
      longitude: json['location']['longitude'],
    );
  }
}
