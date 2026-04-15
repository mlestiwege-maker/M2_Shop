import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../config/api_config.dart';

class ApiService {
  /// HTTP client instance with custom timeout
  static final http.Client _client = http.Client();

  /// Generic error handler
  static String _handleError(dynamic error) {
    if (error is http.ClientException) {
      return 'Network error: Unable to reach the server. Please check your connection.';
    }
    return error.toString();
  }

  /// Fetch products from backend with optional category & search filter
  static Future<List<Product>> fetchProducts({String? category, String? search}) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{};
      if (category != null && category != 'All') queryParams['category'] = category;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final uri = Uri.parse(ApiConfig.productsEndpoint).replace(queryParameters: queryParams);

      final response = await _client
          .get(uri)
          .timeout(Duration(seconds: ApiConfig.requestTimeoutSeconds))
          .catchError((error) {
        debugPrint('❌ Network error fetching products: $error');
        throw Exception(_handleError(error));
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        debugPrint('✅ Fetched ${data.length} products');

        // Map JSON to Product model (includes category-based image fallback)
        final products = data.map((item) => Product.fromJson(item)).toList();

        return products;
      } else if (response.statusCode == 404) {
        debugPrint('⚠️ Products endpoint not found');
        return [];
      } else {
        throw Exception('Failed to load products. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching products: $e');
      return [];
    }
  }

  /// Get all unique categories from products
  static Future<List<String>> fetchCategories() async {
    try {
      final products = await fetchProducts();
      final categories = <String>{};

      for (var product in products) {
        if (product.category.isNotEmpty) {
          categories.add(product.category);
        }
      }

      final categoryList = categories.toList()..sort();
      categoryList.insert(0, 'All'); // default option
      return categoryList;
    } catch (e) {
      debugPrint('⚠️ Error fetching categories: $e');
      return ['All'];
    }
  }

  /// Create a new product on the backend
  static Future<bool> createProduct(Product product, String token) async {
    try {
      final response = await _client
          .post(
            Uri.parse(ApiConfig.productsEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(product.toJson()),
          )
          .timeout(Duration(seconds: ApiConfig.requestTimeoutSeconds))
          .catchError((error) {
            throw Exception(_handleError(error));
          });

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint('✅ Product created: ${product.name}');
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        throw Exception(
            'Failed to create product. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('⚠️ Error creating product: $e');
      return false;
    }
  }

  /// Update product
  static Future<bool> updateProduct(String productId, Product product, String token) async {
    try {
      final response = await _client
          .put(
            Uri.parse('${ApiConfig.productsEndpoint}/$productId'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(product.toJson()),
          )
          .timeout(Duration(seconds: ApiConfig.requestTimeoutSeconds))
          .catchError((error) {
            throw Exception(_handleError(error));
          });

      if (response.statusCode == 200) {
        debugPrint('✅ Product updated: ${product.name}');
        return true;
      } else {
        throw Exception('Failed to update product. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('⚠️ Error updating product: $e');
      return false;
    }
  }

  /// Delete product
  static Future<bool> deleteProduct(String productId, String token) async {
    try {
      final response = await _client
          .delete(
            Uri.parse('${ApiConfig.productsEndpoint}/$productId'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(Duration(seconds: ApiConfig.requestTimeoutSeconds))
          .catchError((error) {
            throw Exception(_handleError(error));
          });

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('✅ Product deleted: $productId');
        return true;
      } else {
        throw Exception('Failed to delete product. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('⚠️ Error deleting product: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchSuppliers() async {
    try {
      final response = await _client
          .get(Uri.parse(ApiConfig.suppliersEndpoint))
          .timeout(Duration(seconds: ApiConfig.requestTimeoutSeconds));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('⚠️ Error fetching suppliers: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchRfqs() async {
    try {
      final response = await _client
          .get(Uri.parse(ApiConfig.rfqEndpoint))
          .timeout(Duration(seconds: ApiConfig.requestTimeoutSeconds));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('⚠️ Error fetching RFQs: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchOrders() async {
    try {
      final response = await _client
          .get(Uri.parse(ApiConfig.ordersEndpoint))
          .timeout(Duration(seconds: ApiConfig.requestTimeoutSeconds));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('⚠️ Error fetching orders: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> fetchMessages() async {
    try {
      final response = await _client
          .get(Uri.parse(ApiConfig.messagesEndpoint))
          .timeout(Duration(seconds: ApiConfig.requestTimeoutSeconds));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('⚠️ Error fetching messages: $e');
      return [];
    }
  }

  static Future<bool> submitContact(Map<String, dynamic> payload) async {
    try {
      final response = await _client
          .post(
            Uri.parse(ApiConfig.contactEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(Duration(seconds: ApiConfig.requestTimeoutSeconds));

      return response.statusCode == 201;
    } catch (e) {
      debugPrint('⚠️ Error submitting contact form: $e');
      return false;
    }
  }

  static Future<bool> submitRfq(Map<String, dynamic> payload) async {
    try {
      final response = await _client
          .post(
            Uri.parse(ApiConfig.rfqEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(Duration(seconds: ApiConfig.requestTimeoutSeconds));

      return response.statusCode == 201;
    } catch (e) {
      debugPrint('⚠️ Error submitting RFQ: $e');
      return false;
    }
  }

  static Future<bool> sendMessage(Map<String, dynamic> payload) async {
    try {
      final response = await _client
          .post(
            Uri.parse(ApiConfig.messagesEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(Duration(seconds: ApiConfig.requestTimeoutSeconds));

      return response.statusCode == 201;
    } catch (e) {
      debugPrint('⚠️ Error sending message: $e');
      return false;
    }
  }
}
