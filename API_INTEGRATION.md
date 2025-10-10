# API Integration Guide

## Overview

This document explains how to integrate your .NET backend API with the Flutter application.

## API Client Configuration

### Base Configuration

The app uses **Dio** HTTP client for API requests. Configuration is in `lib/core/network/dio_client.dart`.

```dart
// Default configuration
BaseOptions(
  baseUrl: AppConfig.baseUrl,  // From app_config.dart
  connectTimeout: 30 seconds,
  receiveTimeout: 30 seconds,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
)
```

### Setting API Base URL

**Option 1: Edit Configuration File**
```dart
// lib/core/config/app_config.dart
static const String baseUrl = 'https://your-api.com/v1';
```

**Option 2: Environment Variable**
```bash
flutter run --dart-define=BASE_URL=https://your-api.com/v1
```

**Option 3: Different URLs per Environment**
```dart
static String get baseUrl {
  if (kDebugMode) {
    return 'https://dev-api.example.com/v1';
  } else {
    return 'https://api.example.com/v1';
  }
}
```

## Authentication Flow

### 1. Send OTP

**API Endpoint**: `POST /auth/send-otp`

**Request:**
```json
{
  "phoneNumber": "1234567890"
}
```

**Response:**
```json
{
  "success": true,
  "message": "OTP sent successfully",
  "requestId": "550e8400-e29b-41d4-a716-446655440000",
  "expiresIn": 300
}
```

**Implementation:**
```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
@override
Future<OtpResponse> sendOtp(String phoneNumber) async {
  final response = await _dioClient.post(
    '/auth/send-otp',
    data: {'phoneNumber': phoneNumber},
  );
  return OtpResponse.fromJson(response.data);
}
```

### 2. Verify OTP

**API Endpoint**: `POST /auth/verify-otp`

**Request:**
```json
{
  "phoneNumber": "1234567890",
  "otp": "123456",
  "requestId": "550e8400-e29b-41d4-a716-446655440000"
}
```

**Response:**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": 3600,
  "user": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "1234567890",
    "role": "admin",
    "company": "ABC Corp",
    "profileImage": "https://example.com/image.jpg",
    "createdAt": "2024-01-01T00:00:00Z",
    "updatedAt": "2024-01-01T00:00:00Z"
  }
}
```

### 3. Refresh Token

**API Endpoint**: `POST /auth/refresh`

**Request:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response:** Same as Verify OTP response

**Auto-Refresh**: The app automatically refreshes tokens when receiving 401 Unauthorized using `AuthInterceptor`.

### 4. Logout

**API Endpoint**: `POST /auth/logout`

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:**
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

## Request Interceptors

### Authentication Interceptor

Automatically adds Bearer token to all requests:

```dart
// lib/core/network/interceptors/auth_interceptor.dart
@override
void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
  final token = await _storage.read(AppConfig.tokenKey);
  if (token != null) {
    options.headers['Authorization'] = 'Bearer $token';
  }
  super.onRequest(options, handler);
}
```

### Logging Interceptor

Logs all requests and responses for debugging:

```dart
// lib/core/network/interceptors/logging_interceptor.dart
@override
void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
  AppLogger.logRequest(options.method, options.uri.toString());
  super.onRequest(options, handler);
}
```

## Error Handling

### Standard Error Format

The app expects errors in this format:

```json
{
  "error": {
    "code": "INVALID_OTP",
    "message": "The OTP provided is invalid or expired",
    "details": {}
  }
}
```

### HTTP Status Codes

The app handles these status codes:

- **200**: Success
- **400**: Bad Request (validation errors)
- **401**: Unauthorized (token expired/invalid)
- **403**: Forbidden (insufficient permissions)
- **404**: Not Found
- **500**: Internal Server Error
- **502**: Bad Gateway
- **503**: Service Unavailable

### Error Handling in Code

```dart
try {
  final response = await _dioClient.post('/endpoint');
  return response.data;
} on DioException catch (e) {
  if (e.response?.statusCode == 401) {
    // Handle unauthorized - auto refresh triggered
  } else if (e.response?.statusCode == 400) {
    // Handle validation errors
    throw Exception(e.response?.data['error']['message']);
  }
  rethrow;
}
```

## Adding New Endpoints

### Step 1: Define in Repository Interface

```dart
// lib/features/products/domain/repositories/product_repository.dart
abstract class ProductRepository {
  Future<List<Product>> getProducts({int page, int limit});
  Future<Product> getProductById(String id);
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(String id, Product product);
  Future<void> deleteProduct(String id);
}
```

### Step 2: Implement Repository

```dart
// lib/features/products/data/repositories/product_repository_impl.dart
class ProductRepositoryImpl implements ProductRepository {
  final DioClient _dioClient;
  
  ProductRepositoryImpl(this._dioClient);
  
  @override
  Future<List<Product>> getProducts({int page = 1, int limit = 20}) async {
    final response = await _dioClient.get(
      '/products',
      queryParameters: {'page': page, 'limit': limit},
    );
    
    final List<dynamic> data = response.data['data'];
    return data.map((json) => Product.fromJson(json)).toList();
  }
  
  @override
  Future<Product> getProductById(String id) async {
    final response = await _dioClient.get('/products/$id');
    return Product.fromJson(response.data);
  }
  
  @override
  Future<Product> createProduct(Product product) async {
    final response = await _dioClient.post(
      '/products',
      data: product.toJson(),
    );
    return Product.fromJson(response.data);
  }
  
  @override
  Future<Product> updateProduct(String id, Product product) async {
    final response = await _dioClient.put(
      '/products/$id',
      data: product.toJson(),
    );
    return Product.fromJson(response.data);
  }
  
  @override
  Future<void> deleteProduct(String id) async {
    await _dioClient.delete('/products/$id');
  }
}
```

### Step 3: Create Provider

```dart
// lib/features/products/presentation/providers/product_provider.dart
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(DioClient());
});

final productListProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});
```

### Step 4: Use in UI

```dart
class ProductListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);
    
    return productsAsync.when(
      data: (products) => ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) => ProductTile(products[index]),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

## .NET Backend Implementation Examples

### ASP.NET Core Controllers

```csharp
[ApiController]
[Route("api/v1/[controller]")]
public class AuthController : ControllerBase
{
    [HttpPost("send-otp")]
    public async Task<ActionResult<OtpResponse>> SendOtp([FromBody] SendOtpRequest request)
    {
        // Implementation
        return Ok(new OtpResponse
        {
            Success = true,
            Message = "OTP sent successfully",
            RequestId = Guid.NewGuid().ToString(),
            ExpiresIn = 300
        });
    }
    
    [HttpPost("verify-otp")]
    public async Task<ActionResult<AuthResponse>> VerifyOtp([FromBody] VerifyOtpRequest request)
    {
        // Verify OTP
        // Generate JWT tokens
        return Ok(new AuthResponse
        {
            AccessToken = "...",
            RefreshToken = "...",
            ExpiresIn = 3600,
            User = new UserDto { ... }
        });
    }
    
    [HttpPost("refresh")]
    public async Task<ActionResult<AuthResponse>> RefreshToken([FromBody] RefreshTokenRequest request)
    {
        // Validate refresh token
        // Generate new tokens
        return Ok(new AuthResponse { ... });
    }
    
    [Authorize]
    [HttpPost("logout")]
    public async Task<ActionResult> Logout()
    {
        // Invalidate tokens
        return Ok(new { Success = true, Message = "Logged out successfully" });
    }
}
```

### JWT Configuration in .NET

```csharp
// Startup.cs or Program.cs
services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = Configuration["Jwt:Issuer"],
            ValidAudience = Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(Configuration["Jwt:Key"]))
        };
    });
```

## Testing API Integration

### Using Postman/Insomnia

1. **Send OTP**
   ```
   POST https://your-api.com/v1/auth/send-otp
   Content-Type: application/json
   
   {
     "phoneNumber": "1234567890"
   }
   ```

2. **Verify OTP**
   ```
   POST https://your-api.com/v1/auth/verify-otp
   Content-Type: application/json
   
   {
     "phoneNumber": "1234567890",
     "otp": "123456",
     "requestId": "request-id-from-step-1"
   }
   ```

3. **Protected Endpoint**
   ```
   GET https://your-api.com/v1/products
   Authorization: Bearer {access-token-from-step-2}
   ```

### Using Flutter DevTools

1. Run app in debug mode
2. Check Network tab for all API calls
3. Inspect requests/responses
4. View error details

## Common Issues

### CORS (Cross-Origin Resource Sharing)

If testing on web, enable CORS in your .NET API:

```csharp
// Program.cs
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutterApp",
        policy => policy
            .WithOrigins("http://localhost:*")
            .AllowAnyHeader()
            .AllowAnyMethod());
});

app.UseCors("AllowFlutterApp");
```

### SSL Certificate Issues (Development)

For development with self-signed certificates:

```dart
// Only for development!
dio.httpClientAdapter = IOHttpClientAdapter(
  onHttpClientCreate: (client) {
    client.badCertificateCallback = (cert, host, port) => true;
    return client;
  },
);
```

### Timeout Configuration

Adjust timeouts based on your API performance:

```dart
// lib/core/config/app_config.dart
static const int connectTimeout = 30000;  // 30 seconds
static const int receiveTimeout = 30000;  // 30 seconds
```

## Best Practices

1. **Use DTOs**: Keep models synchronized between Flutter and .NET
2. **Version Your API**: Use `/v1/`, `/v2/` prefixes
3. **Consistent Response Format**: Use same structure for all endpoints
4. **Error Handling**: Return meaningful error messages
5. **Logging**: Log all requests on both client and server
6. **Security**: Always use HTTPS in production
7. **Rate Limiting**: Implement rate limiting to prevent abuse
8. **API Documentation**: Use Swagger/OpenAPI for .NET API

## Additional Resources

- [Dio Package Documentation](https://pub.dev/packages/dio)
- [JWT.io Debugger](https://jwt.io/)
- [ASP.NET Core API Documentation](https://docs.microsoft.com/en-us/aspnet/core/web-api/)
- [Flutter HTTP Guide](https://docs.flutter.dev/cookbook/networking/fetch-data)