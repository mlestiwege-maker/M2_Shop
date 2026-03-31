import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Product> get products => _filteredProducts;
  List<String> get categories {
    final cats = _allProducts.map((p) => p.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  String get selectedCategory => _selectedCategory;

  Future<void> fetchProducts() async {
    try {
      _allProducts = await ApiService.fetchProducts();
      applyFilters();
    } catch (e) {
      rethrow;
    }
  }

  void applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      final matchesCategory = _selectedCategory == 'All' ||
          product.category.toLowerCase() ==
              _selectedCategory.toLowerCase();
      final matchesSearch = product.name
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    applyFilters();
  }

  void updateCategory(String category) {
    _selectedCategory = category;
    applyFilters();
  }
}
