import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework_api_simple_state_getx/models/product.dart';

class ProductController extends GetxController {
  final dio = Dio();
  var allProducts = <Product>[]; // Store the full list of products
  var filteredProducts = <Product>[]; // Store the filtered list to display
  var favorites = <int, bool>{}; // Map to track favorite products by index
  var isLoading = false;
  int selectedIndex = 0;
  var favCart = <Product>[];

  var cart = <Product>[].obs;
  var quantities = <int>[].obs;

  @override
  void onInit() {
    fetchProducts();
    quantities.value = List.generate(20, (index) => 1);
    print(allProducts.length);
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading = true;
      String url = "https://fakestoreapi.com/products";
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data as List;
        allProducts = data.map((e) => Product.fromJson(e)).toList();
        filteredProducts = allProducts; // Initially, show all products
      }
    } catch (e) {
      Get.defaultDialog(title: "Error", content: Text("$e"));
    } finally {
      isLoading = false;
      update();
    }
  }

  void changeIndex(int index) {
    selectedIndex = index;
    update();
  }

  void searchProducts(String? category) {
    if (category == null || category == 'All') {
      filteredProducts = allProducts;
    } else {
      filteredProducts = allProducts.where((product) {
        return product.category!.toLowerCase() == category.toLowerCase();
      }).toList();
    }
    update(); // Notify UI
  }

  void toggleFavorite(int index, Product product) {
    // Check if the product is already in the favorites map
    if (favorites.containsKey(index)) {
      // Toggle the favorite status in the map
      favorites[index] = !favorites[index]!;

      // Add or remove the product from favCart based on the new favorite status
      if (favorites[index] == true) {
        favCart.add(product);
      } else {
        favCart.remove(product);
      }
    } else {
      // If the product is not in the map, add it to favorites and favCart
      favorites[index] = true;
      favCart.add(product);
    }

    update(); // Notify the UI
  }

  // Check if a product is favorited
  bool isFavorited(int index) {
    return favorites[index] ?? false; // Return false if not found in map
  }

  void addToCart(Product product) {
    if (!cart.any((element) => element.id == product.id)) {
      cart.add(product);
    }
    Get.back();
  }

  // Get product quantity at a given index
  int productQty(int index) {
    return quantities[index];
  }

  // Increase product quantity
  void increaseQty(int index) {
    quantities[index]++;
  }

  // Decrease product quantity
  void decreaseQty(int index) {
    if (quantities[index] > 1) {
      quantities[index]--;
    }
  }

  double sumTotal() {
    double sum = 0;
    for (int i = 0; i < cart.length; i++) {
      sum += double.parse(cart[i].price.toString()) * quantities[i];
    }
    return sum;
  }

  void deleteProduct(int index) {
    cart.removeAt(index);
  }

  // void increaseCounter() {
  //   counter++;
  // }

  // void decreaseCounter() {
  //   if (counter > 1) {
  //     counter--;
  //   }
  // }
}
