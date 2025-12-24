class CartItem {
  final String id; // optional unique id (e.g., doc id)
  final String userId; // current user
  final String restaurantId; // new field for restaurant
  final String companyName;
  final String dishPhoto; // url or local path
  final String dishName;
  final double price;
  int quantity;

  CartItem({
    this.id = '',
    this.userId = '', // default empty
    required this.restaurantId, // default empty
    required this.companyName,
    required this.dishPhoto,
    required this.dishName,
    required this.price,
    this.quantity = 1,
  });

  // computed property
  double get totalPrice => price * quantity;

  // copyWith for immutability updates
  CartItem copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? companyName,
    String? dishPhoto,
    String? dishName,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      companyName: companyName ?? this.companyName,
      dishPhoto: dishPhoto ?? this.dishPhoto,
      dishName: dishName ?? this.dishName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  // simple helpers
  CartItem incrementQty([int delta = 1]) => copyWith(quantity: quantity + delta);
  CartItem decrementQty([int delta = 1]) => copyWith(quantity: (quantity - delta).clamp(0, 1 << 30));

  // serialization (for Firestore / JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      'companyName': companyName,
      'dishPhoto': dishPhoto,
      'dishName': dishName,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      restaurantId: map['restaurantId'] ?? '',
      companyName: map['companyName'] ?? '',
      dishPhoto: map['dishPhoto'] ?? '',
      dishName: map['dishName'] ?? '',
      price: (map['price'] is num) ? (map['price'] as num).toDouble() : double.tryParse('${map['price']}') ?? 0.0,
      quantity: (map['quantity'] is int) ? map['quantity'] as int : int.tryParse('${map['quantity']}') ?? 1,
    );
  }

  @override
  String toString() {
    return 'CartItem(userId: $userId, restaurantId: $restaurantId, companyName: $companyName, dishName: $dishName, price: $price, quantity: $quantity)';
  }
}
