class CartItem {
  final int? id;
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final double salePrice;
  final int quantity;

  const CartItem({
    this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.salePrice,
    required this.quantity,
  });

  CartItem copyWith({
    int? id,
    String? productId,
    String? name,
    String? imageUrl,
    double? price,
    double? salePrice,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'salePrice': salePrice,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as int?,
      productId: map['productId'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      price: (map['price'] as num).toDouble(),
      salePrice: (map['salePrice'] as num).toDouble(),
      quantity: map['quantity'] as int,
    );
  }
}
