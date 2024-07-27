// models/driver_model.dart
class DriverModel {
  final int id;
  final String name;
  final String carModel;
  final double rating;
  final double latitude;
  final double longitude;

  DriverModel({
    required this.id,
    required this.name,
    required this.carModel,
    required this.rating,
    required this.latitude,
    required this.longitude,
  });
}
