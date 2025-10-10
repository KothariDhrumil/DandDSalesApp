# Code Examples for Common Tasks

## Table of Contents
1. [Creating a New Feature](#creating-a-new-feature)
2. [Adding API Endpoints](#adding-api-endpoints)
3. [State Management](#state-management)
4. [Navigation](#navigation)
5. [Forms & Validation](#forms--validation)
6. [Lists & Pagination](#lists--pagination)
7. [Error Handling](#error-handling)
8. [Storage](#storage)

## Creating a New Feature

### Step 1: Create Folder Structure

```bash
mkdir -p lib/features/products/{data,domain,presentation}/{models,repositories,pages,widgets,providers}
```

### Step 2: Create Domain Model

```dart
// lib/features/products/domain/models/product_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String? imageUrl;
  final DateTime? createdAt;
  
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.createdAt,
  });
  
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
```

### Step 3: Create Repository Interface

```dart
// lib/features/products/domain/repositories/product_repository.dart
import '../models/product_model.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({int page = 1, int limit = 20});
  Future<Product> getProductById(String id);
  Future<Product> createProduct(Product product);
  Future<void> deleteProduct(String id);
}
```

### Step 4: Implement Repository

```dart
// lib/features/products/data/repositories/product_repository_impl.dart
import '../../../../core/network/dio_client.dart';
import '../../domain/models/product_model.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final DioClient _client;
  
  ProductRepositoryImpl(this._client);
  
  @override
  Future<List<Product>> getProducts({int page = 1, int limit = 20}) async {
    final response = await _client.get(
      '/products',
      queryParameters: {'page': page, 'limit': limit},
    );
    return (response.data['data'] as List)
        .map((json) => Product.fromJson(json))
        .toList();
  }
  
  @override
  Future<Product> getProductById(String id) async {
    final response = await _client.get('/products/$id');
    return Product.fromJson(response.data);
  }
  
  @override
  Future<Product> createProduct(Product product) async {
    final response = await _client.post(
      '/products',
      data: product.toJson(),
    );
    return Product.fromJson(response.data);
  }
  
  @override
  Future<void> deleteProduct(String id) async {
    await _client.delete('/products/$id');
  }
}
```

### Step 5: Create Providers

```dart
// lib/features/products/presentation/providers/product_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/models/product_model.dart';
import '../../domain/repositories/product_repository.dart';

// Repository provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(DioClient());
});

// Product list provider
final productListProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});

// Product detail provider
final productDetailProvider = FutureProvider.autoDispose
    .family<Product, String>((ref, id) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductById(id);
});
```

### Step 6: Create UI Page

```dart
// lib/features/products/presentation/pages/product_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_provider.dart';

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to add product
            },
          ),
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No products found'));
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: product.imageUrl != null
                    ? Image.network(product.imageUrl!, width: 50, height: 50)
                    : const Icon(Icons.inventory),
                title: Text(product.name),
                subtitle: Text('\$${product.price}'),
                trailing: Text('Stock: ${product.stock}'),
                onTap: () {
                  // Navigate to product detail
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(productListProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Adding API Endpoints

### GET Request

```dart
Future<List<Product>> getProducts() async {
  final response = await DioClient().get('/products');
  return (response.data as List)
      .map((json) => Product.fromJson(json))
      .toList();
}
```

### POST Request

```dart
Future<Product> createProduct(Product product) async {
  final response = await DioClient().post(
    '/products',
    data: product.toJson(),
  );
  return Product.fromJson(response.data);
}
```

### PUT Request

```dart
Future<Product> updateProduct(String id, Product product) async {
  final response = await DioClient().put(
    '/products/$id',
    data: product.toJson(),
  );
  return Product.fromJson(response.data);
}
```

### DELETE Request

```dart
Future<void> deleteProduct(String id) async {
  await DioClient().delete('/products/$id');
}
```

## State Management

### Simple State with StateNotifier

```dart
class ProductState {
  final List<Product> products;
  final bool isLoading;
  final String? error;
  
  ProductState({
    this.products = const [],
    this.isLoading = false,
    this.error,
  });
  
  ProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? error,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepository _repository;
  
  ProductNotifier(this._repository) : super(ProductState());
  
  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final products = await _repository.getProducts();
      state = state.copyWith(products: products, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  Future<void> addProduct(Product product) async {
    try {
      final newProduct = await _repository.createProduct(product);
      state = state.copyWith(
        products: [...state.products, newProduct],
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
  
  Future<void> deleteProduct(String id) async {
    try {
      await _repository.deleteProduct(id);
      state = state.copyWith(
        products: state.products.where((p) => p.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  return ProductNotifier(ref.watch(productRepositoryProvider));
});
```

## Navigation

### Navigate to a Page

```dart
// Using GoRouter
context.push('/products');
context.push('/products/123'); // With parameter

// With named routes
context.pushNamed('products');
context.pushNamed('productDetail', extra: {'id': '123'});
```

### Navigate and Remove Previous Routes

```dart
context.go('/dashboard'); // Replaces history
context.pushReplacement('/dashboard'); // Replaces current route
```

### Navigate Back

```dart
context.pop(); // Go back
context.pop(result); // Go back with result
```

### Pass Data Between Screens

```dart
// Method 1: Using extra parameter
context.push('/products/detail', extra: product);

// In target page
final product = GoRouterState.of(context).extra as Product;

// Method 2: Using path parameters
context.push('/products/${product.id}');

// In route definition
GoRoute(
  path: '/products/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return ProductDetailPage(id: id);
  },
)
```

## Forms & Validation

### Form with Validation

```dart
class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});
  
  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  
  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }
  
  void _submit() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: '',
        name: _nameController.text,
        description: '',
        price: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
      );
      
      // Save product
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                hintText: 'Enter product name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                hintText: 'Enter price',
                prefixText: '\$',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Stock',
                hintText: 'Enter stock quantity',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter stock';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Lists & Pagination

### Infinite Scroll List

```dart
class InfiniteListPage extends ConsumerStatefulWidget {
  const InfiniteListPage({super.key});
  
  @override
  ConsumerState<InfiniteListPage> createState() => _InfiniteListPageState();
}

class _InfiniteListPageState extends ConsumerState<InfiniteListPage> {
  final _scrollController = ScrollController();
  int _page = 1;
  List<Product> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  
  @override
  void initState() {
    super.initState();
    _loadProducts();
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!_isLoading && _hasMore) {
        _loadProducts();
      }
    }
  }
  
  Future<void> _loadProducts() async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    
    try {
      final repository = ref.read(productRepositoryProvider);
      final newProducts = await repository.getProducts(page: _page);
      
      setState(() {
        _page++;
        _products.addAll(newProducts);
        _hasMore = newProducts.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _products.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _products.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          final product = _products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price}'),
          );
        },
      ),
    );
  }
}
```

## Error Handling

### Try-Catch with User Feedback

```dart
Future<void> saveProduct(Product product) async {
  try {
    await repository.createProduct(product);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  } on DioException catch (e) {
    String message = 'An error occurred';
    
    if (e.response?.statusCode == 400) {
      message = 'Invalid product data';
    } else if (e.response?.statusCode == 401) {
      message = 'Please login again';
    } else if (e.type == DioExceptionType.connectionTimeout) {
      message = 'Connection timeout';
    }
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
```

## Storage

### Save/Read from Secure Storage

```dart
// Save token
await SecureStorageService().write('token', 'my-token');

// Read token
final token = await SecureStorageService().read('token');

// Delete token
await SecureStorageService().delete('token');

// Clear all
await SecureStorageService().clearAll();
```

### Save/Read from Local Storage

```dart
// Initialize first (in main.dart)
await LocalStorageService().init();

// Save string
await LocalStorageService().setString('theme', 'dark');

// Read string
final theme = LocalStorageService().getString('theme');

// Save bool
await LocalStorageService().setBool('firstLaunch', false);

// Read bool
final isFirstLaunch = LocalStorageService().getBool('firstLaunch');

// Save int
await LocalStorageService().setInt('counter', 10);

// Read int
final counter = LocalStorageService().getInt('counter');
```

## Additional Examples

Check the existing code in:
- `lib/features/auth/` for authentication examples
- `lib/features/dashboard/` for dashboard UI examples
- `lib/features/profile/` for profile management examples
- `lib/core/network/` for API client examples
- `lib/core/theme/` for theming examples