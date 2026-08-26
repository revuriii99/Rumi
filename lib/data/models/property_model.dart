class PropertyModel {
  final String id;
  final String name;
  final String location;
  final double price;
  final double rating;
  final String imageUrl;
  final List<String> facilities;
  final String description;
  bool isSaved;

  PropertyModel({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.facilities,
    required this.description,
    this.isSaved = false,
  });
}
