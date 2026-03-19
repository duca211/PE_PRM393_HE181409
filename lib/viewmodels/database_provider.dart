import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/database_helper.dart';

final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});
