import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import 'database_provider.dart';
import '../services/database_helper.dart';

final cartListNotifierProvider =
    StateNotifierProvider<CartListNotifier, AsyncValue<List<CartItem>>>((ref) {
      final databaseHelper = ref.watch(databaseHelperProvider);
      return CartListNotifier(databaseHelper);
    });

final cartTotalProvider = Provider<double>((ref) {
  final cartAsync = ref.watch(cartListNotifierProvider);
  return cartAsync.maybeWhen(
    data: (items) =>
        items.fold(0.0, (sum, item) => sum + (item.salePrice * item.quantity)),
    orElse: () => 0.0,
  );
});

final cartSubtotalProvider = Provider<double>((ref) {
  final cartAsync = ref.watch(cartListNotifierProvider);
  return cartAsync.maybeWhen(
    data: (items) =>
        items.fold(0.0, (sum, item) => sum + (item.price * item.quantity)),
    orElse: () => 0.0,
  );
});

class CartListNotifier extends StateNotifier<AsyncValue<List<CartItem>>> {
  final DatabaseHelper _databaseHelper;

  CartListNotifier(this._databaseHelper) : super(const AsyncValue.loading()) {
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    state = const AsyncValue.loading();
    try {
      final items = await _databaseHelper.getCartItems();
      state = AsyncValue.data(items);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> refreshCart() async {
    await _loadCartItems();
  }

  Future<void> addToCart(Product product) async {
    final salePrice = product.price * (1 - (product.discount / 100));
    final cartItem = CartItem(
      productId: product.id?.toString() ?? product.name,
      name: product.name,
      imageUrl: product.image ?? '',
      price: product.price,
      salePrice: salePrice,
      quantity: 1,
    );
    await _databaseHelper.addToCart(cartItem);
    await _loadCartItems();
  }

  Future<void> updateQuantity(CartItem item, int quantity) async {
    if (item.id == null) return;
    if (quantity <= 0) {
      await removeFromCart(item.id!);
      return;
    }
    await _databaseHelper.updateCartItem(item.copyWith(quantity: quantity));
    await _loadCartItems();
  }

  Future<void> removeFromCart(int id) async {
    await _databaseHelper.removeFromCart(id);
    await _loadCartItems();
  }

  Future<void> clearCart() async {
    await _databaseHelper.clearCart();
    await _loadCartItems();
  }
}
