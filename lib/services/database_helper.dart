import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'products.db');

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // tao db lan dau
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        discount REAL NOT NULL,
        subtotal REAL NOT NULL,
        total REAL NOT NULL,
        image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cart(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId TEXT,
        name TEXT,
        imageUrl TEXT,
        price REAL,
        salePrice REAL,
        quantity INTEGER
      )
    ''');

    await _insertSampleProducts(db);
  }

  Future<void> _insertSampleProducts(Database db) async {
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM products'),
    );
    if (count! > 0) return;

    final sampleProducts = [
      {
        'name': 'Iphone 15',
        'price': 1999.99,
        'quantity': 10,
        'discount': 10.0,
        'image': 'assets/images/avatar7.jpg',
      },
      {
        'name': 'Iphone 14 Pro Max',
        'price': 1299.99,
        'quantity': 10,
        'discount': 8.0,
        'image': 'assets/images/avatar7.jpg',
      },
      {
        'name': 'Samsung Galaxy S22 Ultra',
        'price': 199.99,
        'quantity': 5,
        'discount': 12.0,
        'image': 'assets/images/avatar7.jpg',
      },
      {
        'name': 'Ipad Pro 12.9 inch',
        'price': 699.99,
        'quantity': 2,
        'discount': 5.0,
        'image': 'assets/images/avatar7.jpg',
      },
      {
        'name': 'Macbook Air M2',
        'price': 299.99,
        'quantity': 1,
        'discount': 15.0,
        'image': 'assets/images/avatar7.jpg',
      },
    ];

    for (var product in sampleProducts) {
      final price = product['price'] as double;
      final quantity = product['quantity'] as int;
      final discount = product['discount'] as double;
      final subtotal = price * quantity;
      final total = subtotal - (subtotal * (discount / 100));

      await db.insert('products', {
        'name': product['name'],
        'price': price,
        'quantity': quantity,
        'discount': discount,
        'subtotal': subtotal,
        'total': total,
        'image': product['image'],
      });
    }
  }

  // Product methods
  Future<List<Product>> getAllProducts() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    print("Dữ liệu trong DB: $maps");
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<Product?> getProductById(int id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertProduct(Product product) async {
    final db = await database;
    return db.insert('products', product.toMap());
  }

  Future<double> getTotalAmount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(total) as total FROM products',
    );
    final value = result.first['total'];
    if (value == null) return 0.0;
    return (value as num).toDouble();
  }

  // Cart methods
  Future<List<CartItem>> getCartItems() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cart');
    return List.generate(maps.length, (i) => CartItem.fromMap(maps[i]));
  }

  Future<int> addToCart(CartItem cartItem) async {
    Database db = await database;

    // check xem sp co trong gio hang chua
    final List<Map<String, dynamic>> existing = await db.query(
      'cart',
      where: 'productId = ?',
      whereArgs: [cartItem.productId],
    );

    if (existing.isNotEmpty) {
      // neu da co, update so luong
      final existingItem = CartItem.fromMap(existing.first);
      final newQuantity = existingItem.quantity + 1;

      return await db.update(
        'cart',
        {'quantity': newQuantity},
        where: 'id = ?',
        whereArgs: [existingItem.id],
      );
    } else {
      // neu chua co, them moi
      return await db.insert('cart', cartItem.toMap());
    }
  }

  Future<int> updateCartItem(CartItem cartItem) async {
    Database db = await database;
    return await db.update(
      'cart',
      cartItem.toMap(),
      where: 'id = ?',
      whereArgs: [cartItem.id],
    );
  }

  Future<int> removeFromCart(int id) async {
    Database db = await database;
    return await db.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> clearCart() async {
    Database db = await database;
    return await db.delete('cart');
  }
}
