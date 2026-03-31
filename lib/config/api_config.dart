/// API configuration for M2 Shop
/// This should be updated based on deployment environment
class ApiConfig {
  /// Base API URL - configure based on environment
  /// - Development: http://localhost:5000/api
  /// - Production: https://your-api-domain.com/api
  static const String baseUrl = 'http://localhost:5000/api';

  /// Request timeout duration in seconds
  static const int requestTimeoutSeconds = 30;

  /// Supported API endpoints
  static const String authEndpoint = '$baseUrl/auth';
  static const String productsEndpoint = '$baseUrl/products';
  static const String commentsEndpoint = '$baseUrl/comments';
  static const String complaintsEndpoint = '$baseUrl/complaints';
  static const String userEndpoint = '$baseUrl/user';

  /// File upload endpoint for images
  static const String uploadEndpoint = '$baseUrl/upload';

  /// Image serving baseURL
  static const String imageBaseUrl = 'http://localhost:5000/uploads';
}
