import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import 'database_provider.dart';
import '../services/database_helper.dart';

final productListNotifierProvider =
    StateNotifierProvider<ProductListNotifier, AsyncValue<List<Product>>>((
      ref,
    ) {
      final databaseHelper = ref.watch(databaseHelperProvider);
      return ProductListNotifier(databaseHelper, ref);
    });

final currentProductProvider = StateProvider<Product?>((ref) => null);

final totalAmountProvider = Provider<double>((ref) {
  final productsAsync = ref.watch(productListNotifierProvider);
  return productsAsync.maybeWhen(
    data: (products) =>
        products.fold(0.0, (sum, product) => sum + product.total),
    orElse: () => 0.0,
  );
});

class ProductListNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final DatabaseHelper _databaseHelper;
  final Ref _ref;

  ProductListNotifier(this._databaseHelper, this._ref)
    : super(const AsyncValue.loading()) {
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    state = const AsyncValue.loading();
    try {
      final products = await _databaseHelper.getAllProducts();
      state = AsyncValue.data(products);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> refreshProducts() async {
    await _loadProducts();
  }
}
