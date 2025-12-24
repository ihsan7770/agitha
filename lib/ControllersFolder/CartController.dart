import 'dart:async';
import 'dart:convert';
import 'package:agitha/ModelsFoder/CartModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends ChangeNotifier {
  final Map<String, List<CartItem>> _userCarts = {};

  // StreamController for total items (broadcast allows multiple listeners)
  final _itemCountController = StreamController<int>.broadcast();

  // 🔥 New variable to control bottom cart bar visibility globally
  bool showCartBar = false;

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  CartController() {
    _loadCartFromPrefs();
  }


//for unique items count
  int get uniqueItemsCount {
  final userId = _currentUserId;
  if (userId == null) return 0;
  final cart = _userCarts[userId] ?? [];
  return cart.length;   // Count distinct food items
}


  // Expose the stream
  Stream<int> get totalItemsStream => _itemCountController.stream;

  // Get current user's cart
  List<CartItem> get cart {
    final userId = _currentUserId;
    if (userId == null) return [];
    _userCarts.putIfAbsent(userId, () => []);
    return _userCarts[userId]!;
  }

int addToCart(CartItem item, {VoidCallback? onDifferentRestaurant}) {
  final userId = _currentUserId;
  if (userId == null) return 0;

  final cart = _userCarts.putIfAbsent(userId, () => []);

  // 🔹 Check if the cart already has items from a different restaurant
  if (cart.isNotEmpty) {
    final existingRestaurantId = cart.first.restaurantId;
    if (existingRestaurantId != item.restaurantId) {
      // Call callback to show alert in UI
      if (onDifferentRestaurant != null) onDifferentRestaurant();
      return 0; // Don't add item
    }
  }

  // Check for existing item
  final index = cart.indexWhere(
    (x) => x.dishName == item.dishName &&
           x.companyName == item.companyName &&
           x.restaurantId == item.restaurantId,
  );

  if (index != -1) {
    cart[index].quantity++;
  } else {
    cart.add(item);
  }

  _saveCartToPrefs();
  notifyListeners();
  _updateItemCount();

  return item.quantity;
}



  // Remove item
  void removeFromCart(CartItem item) {
    final userId = _currentUserId;
    if (userId == null) return;

    _userCarts[userId]?.remove(item);
    _saveCartToPrefs();
    notifyListeners();
    _updateItemCount();
  }

  // Increment qty
  void incrementQty(CartItem item) {
    item.quantity++;
    _saveCartToPrefs();
    notifyListeners();
    _updateItemCount();
  }

  // Decrement qty
  void decrementQty(CartItem item) {
    final userId = _currentUserId;
    if (userId == null) return;

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _userCarts[userId]?.remove(item);
    }

    _saveCartToPrefs();
    notifyListeners();
    _updateItemCount();
  }

  // Total items
  int get totalItems {
    final userId = _currentUserId;
    if (userId == null) return 0;
    final cart = _userCarts[userId] ?? [];
    return cart.fold(0, (sum, item) => sum + item.quantity);
  }

  // Total price
  double get totalPrice => cart.fold(0, (sum, item) => sum + item.totalPrice);

  // Clear cart
  void clearCart() {
    final userId = _currentUserId;
    if (userId == null) return;

    _userCarts[userId] = [];
    _saveCartToPrefs();
    notifyListeners();
    _updateItemCount();
  }

  // ------------------ LOCAL STORAGE ------------------
  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = _currentUserId;
    if (userId == null) return;

    final cartJson = cart.map((item) => item.toMap()).toList();
    prefs.setString('cart_$userId', jsonEncode(cartJson));
  }

  Future<void> _loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = _currentUserId;
    if (userId == null) return;

    final cartString = prefs.getString('cart_$userId');
    if (cartString != null) {
      final List decoded = jsonDecode(cartString);
      _userCarts[userId] =
          decoded.map((item) => CartItem.fromMap(item)).toList();
      notifyListeners();
      _updateItemCount();
    }
  }

  // ------------------ VISIBILITY LOGIC ------------------

  // 🔥 Controls when cart bar appears or hides
  void updateCartBarVisibility(int count) {
    if (count > 0 && !showCartBar) {
      showCartBar = true;
      notifyListeners();
    }

    if (count == 0 && showCartBar) {
      showCartBar = false;
      notifyListeners();
    }
  }

  // ------------------ STREAM HELPER ------------------
void _updateItemCount() {
  final count = totalItems;

  // Emit stream value
  _itemCountController.sink.add(count);

  // 🔥 Delay visibility update until after build
  WidgetsBinding.instance.addPostFrameCallback((_) {
    updateCartBarVisibility(count);
  });
}



// clear cart when log out
Future<void> clearCartOnLogout() async {
  final userId = _currentUserId;
  final prefs = await SharedPreferences.getInstance();

  if (userId != null) {
    _userCarts[userId] = [];                // Clear in-memory cart
    prefs.remove('cart_$userId');           // Remove stored cart
  }

  showCartBar = false;                      // Hide cart bar
  notifyListeners();
  _updateItemCount();
}



  @override
  void dispose() {
    _itemCountController.close();
    super.dispose();
  }
}
