class Product {
  final int? id;
  final String name;
  final double price;
  final int quantity;
  final double discount;
  final double subtotal;
  final double total;
  final String? image;

  const Product({
    this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.discount,
    required this.subtotal,
    required this.total,
    this.image,
  });

  double get discountAmount => subtotal * (discount / 100);

  Product copyWith({
    int? id,
    String? name,
    double? price,
    int? quantity,
    double? discount,
    double? subtotal,
    double? total,
    String? image,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
      subtotal: subtotal ?? this.subtotal,
      total: total ?? this.total,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'discount': discount,
      'subtotal': subtotal,
      'total': total,
      'image': image,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
      discount: (map['discount'] as num).toDouble(),
      subtotal: (map['subtotal'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
      image: map['image'] as String?,
    );
  }
}
