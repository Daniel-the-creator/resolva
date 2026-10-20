/// Model representing an examination e-pin product.
class ExamProduct {
  final String id;
  final String provider;
  final String name;
  final String description;
  final double price;
  final String category;
  final bool isAvailable;
  final int? maxQuantity;

  const ExamProduct({
    required this.id,
    required this.provider,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.isAvailable = true,
    this.maxQuantity,
  });
}
