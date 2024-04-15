import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/productCate_service.dart';

final categoriesProvider = FutureProvider((ref) => ProductService.getAllCate());