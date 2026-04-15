import '../config/api_config.dart';

class CategoryImageResolver {
  static const String _defaultAsset =
      'assets/images/categories/general.svg';

  static const Map<String, String> _categoryAssets = {
    'electronics': 'assets/images/categories/electronics.svg',
    'clothing': 'assets/images/categories/clothing.svg',
    'books': 'assets/images/categories/books.svg',
    'toys': 'assets/images/categories/toys.svg',
    'furniture': 'assets/images/categories/furniture.svg',
    'beauty': 'assets/images/categories/beauty.svg',
    'sports': 'assets/images/categories/sports.svg',
    'food': 'assets/images/categories/food.svg',
    'general': 'assets/images/categories/general.svg',
  };

  static String byCategoryAsset(String? category) {
    final key = (category ?? '').trim().toLowerCase();
    return _categoryAssets[key] ?? _defaultAsset;
  }

  static String resolveProductImage({
    required String? rawImageUrl,
    required String? category,
  }) {
    final raw = (rawImageUrl ?? '').trim();
    final hasImage = raw.isNotEmpty && raw.toLowerCase() != 'null';

    if (!hasImage) {
      return '';
    }

    final isFullUrl = raw.startsWith('http://') || raw.startsWith('https://');
    if (isFullUrl) return raw;

    return '${ApiConfig.imageBaseUrl}/$raw';
  }
}
