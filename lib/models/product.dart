class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  Product({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    this.imageUrl = 'https://via.placeholder.com/150',
    this.category = 'General',
  });

  /// Create Product object from JSON (API → App)
  factory Product.fromJson(Map<String, dynamic> json) {
    final rawImageUrl = json['imageUrl']?.toString() ?? '';
    final bool isFullUrl = rawImageUrl.startsWith('http');

    final imageUrl = isFullUrl
        ? rawImageUrl
        : 'http://172.16.4.242:5000/$rawImageUrl';

    // Convert _id to int (if it's not an int, fallback to 0)
    int parsedId = 0;
    if (json['_id'] is int) {
      parsedId = json['_id'];
    } else {
      parsedId = int.tryParse(json['_id']?.toString() ?? '') ?? 0;
    }

    return Product(
      id: parsedId,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse('${json['price']}') ?? 0.0,
      imageUrl: imageUrl,
      category: json['category']?.toString() ?? 'General',
    );
  }

  /// Convert Product object to JSON (App → API)
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'category': category,
      };

  Product copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
    );
  }

  @override
  String toString() =>
      'Product(id: $id, name: $name, category: $category, price: $price)';
}
