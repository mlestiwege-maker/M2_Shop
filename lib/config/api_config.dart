import 'package:flutter/foundation.dart';

/// API configuration for M2 Shop
/// This should be updated based on deployment environment
class ApiConfig {
  static String get _defaultApiBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      // Prefer localhost for Android physical devices when using:
      // adb reverse tcp:5000 tcp:5000
      //
      // If you're on an Android emulator, override with:
      // --dart-define=API_BASE_URL=http://10.0.2.2:5000/api
      return 'http://localhost:5000/api';
    }

    return 'http://localhost:5000/api';
  }

  /// Base API URL - configure based on environment
  /// - Development: http://localhost:5000/api
  /// - Android physical device (with adb reverse): http://localhost:5000/api
  /// - Android emulator: http://10.0.2.2:5000/api
  /// - Physical device via LAN: http://your-local-ip:5000/api
  ///
  /// You can override at build/run time:
  /// --dart-define=API_BASE_URL=http://your-host:5000/api
  static String get baseUrl {
    const envBaseUrl = String.fromEnvironment('API_BASE_URL');
    return envBaseUrl.isNotEmpty ? envBaseUrl : _defaultApiBaseUrl;
  }

  /// Request timeout duration in seconds
  static const int requestTimeoutSeconds = 30;

  /// Supported API endpoints
  static String get authEndpoint => '$baseUrl/auth';
  static String get productsEndpoint => '$baseUrl/products';
  static String get commentsEndpoint => '$baseUrl/comments';
  static String get complaintsEndpoint => '$baseUrl/complaints';
  static String get userEndpoint => '$baseUrl/user';

  /// File upload endpoint for images
  static String get uploadEndpoint => '$baseUrl/upload';

  /// Image serving baseURL
  /// You can override at build/run time:
  /// --dart-define=IMAGE_BASE_URL=http://your-host:5000/uploads
  static String get imageBaseUrl {
    const envImageBaseUrl = String.fromEnvironment('IMAGE_BASE_URL');
    if (envImageBaseUrl.isNotEmpty) return envImageBaseUrl;

    return baseUrl.replaceFirst('/api', '/uploads');
  }
}
