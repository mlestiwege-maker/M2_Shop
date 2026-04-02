import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import '../config/api_config.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _fullName;
  String? _email;
  String? _profilePicUrl;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String? get token => _token;
  String? get userId => _userId;
  String? get fullName => _fullName;
  String? get email => _email;
  String? get profilePicUrl => _profilePicUrl;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    loadToken();
  }

  /// Register new user
  Future<bool> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String fullName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
        throw Exception('Email, password, and full name cannot be empty');
      }

      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      if (password != confirmPassword) {
        throw Exception('Passwords do not match');
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.authEndpoint}/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
          'confirmPassword': confirmPassword,
          'fullName': fullName.trim(),
        }),
      ).timeout(const Duration(seconds: ApiConfig.requestTimeoutSeconds));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _userId = data['user']['id'];
        _email = data['user']['email'];
        _fullName = data['user']['fullName'];
        _profilePicUrl = data['user']['profilePicUrl'];

        // Save to local storage
        await _saveToPreferences();
        notifyListeners();
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Registration failed');
      }
    } catch (e) {
      if (e is TimeoutException) {
        _errorMessage =
            'Registration timed out. Ensure backend is running at ${ApiConfig.baseUrl}.';
      } else {
        _errorMessage = 'Registration failed: ${e.toString()}';
      }
      debugPrint('❌ Register error: $_errorMessage');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password cannot be empty');
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.authEndpoint}/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
        }),
      ).timeout(const Duration(seconds: ApiConfig.requestTimeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _userId = data['user']['id'];
        _email = data['user']['email'];
        _fullName = data['user']['fullName'];
        _profilePicUrl = data['user']['profilePicUrl'];

        // Save to local storage
        await _saveToPreferences();
        notifyListeners();
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Login failed');
      }
    } catch (e) {
      if (e is TimeoutException) {
        _errorMessage =
            'Login timed out. Keep backend running and verify API URL: ${ApiConfig.baseUrl}';
      } else {
        _errorMessage = 'Login failed: ${e.toString()}';
      }
      debugPrint('❌ Login error: $_errorMessage');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logout user
  Future<void> logout() async {
    _token = null;
    _userId = null;
    _fullName = null;
    _email = null;
    _profilePicUrl = null;
    _errorMessage = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  /// Load saved token from local storage
  Future<void> loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
      _userId = prefs.getString('user_id');
      _fullName = prefs.getString('user_full_name');
      _email = prefs.getString('user_email');
      _profilePicUrl = prefs.getString('user_profile_pic');
      notifyListeners();
    } catch (e) {
      debugPrint('⚠️ Error loading token: $e');
    }
  }

  /// Save authentication data to local storage
  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_token != null) await prefs.setString('auth_token', _token!);
      if (_userId != null) await prefs.setString('user_id', _userId!);
      if (_email != null) await prefs.setString('user_email', _email!);
      if (_fullName != null) await prefs.setString('user_full_name', _fullName!);
      if (_profilePicUrl != null) {
        await prefs.setString('user_profile_pic', _profilePicUrl!);
      }
    } catch (e) {
      debugPrint('⚠️ Error saving preferences: $e');
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
