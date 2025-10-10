import 'package:flutter_test/flutter_test.dart';
import 'package:dandd_sales_app/features/auth/domain/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('should create UserModel from valid JSON', () {
      // Arrange
      final json = {
        'id': 'user-123',
        'name': 'John Doe',
        'email': 'john@example.com',
        'phone': '1234567890',
        'role': 'Manager',
        'company': 'ABC Corp',
        'profileImage': 'https://example.com/image.jpg',
        'createdAt': '2024-01-01T00:00:00.000Z',
        'updatedAt': '2024-01-01T00:00:00.000Z',
      };

      // Act
      final user = UserModel.fromJson(json);

      // Assert
      expect(user.id, 'user-123');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.phone, '1234567890');
      expect(user.role, 'Manager');
      expect(user.company, 'ABC Corp');
      expect(user.profileImage, 'https://example.com/image.jpg');
      expect(user.createdAt, isNotNull);
      expect(user.updatedAt, isNotNull);
    });

    test('should create UserModel with required fields only', () {
      // Arrange
      final json = {
        'id': 'user-123',
        'name': 'John Doe',
        'email': 'john@example.com',
      };

      // Act
      final user = UserModel.fromJson(json);

      // Assert
      expect(user.id, 'user-123');
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.phone, isNull);
      expect(user.role, isNull);
      expect(user.company, isNull);
      expect(user.profileImage, isNull);
    });

    test('should convert UserModel to JSON', () {
      // Arrange
      final user = UserModel(
        id: 'user-123',
        name: 'John Doe',
        email: 'john@example.com',
        phone: '1234567890',
        role: 'Manager',
      );

      // Act
      final json = user.toJson();

      // Assert
      expect(json['id'], 'user-123');
      expect(json['name'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['phone'], '1234567890');
      expect(json['role'], 'Manager');
    });

    test('should create a copy with updated fields using copyWith', () {
      // Arrange
      final user = UserModel(
        id: 'user-123',
        name: 'John Doe',
        email: 'john@example.com',
      );

      // Act
      final updatedUser = user.copyWith(
        name: 'Jane Doe',
        phone: '0987654321',
      );

      // Assert
      expect(updatedUser.id, 'user-123'); // Unchanged
      expect(updatedUser.name, 'Jane Doe'); // Changed
      expect(updatedUser.email, 'john@example.com'); // Unchanged
      expect(updatedUser.phone, '0987654321'); // Changed
    });

    test('copyWith should preserve unchanged fields', () {
      // Arrange
      final user = UserModel(
        id: 'user-123',
        name: 'John Doe',
        email: 'john@example.com',
        phone: '1234567890',
        role: 'Manager',
        company: 'ABC Corp',
      );

      // Act
      final updatedUser = user.copyWith(name: 'Jane Doe');

      // Assert
      expect(updatedUser.id, user.id);
      expect(updatedUser.name, 'Jane Doe');
      expect(updatedUser.email, user.email);
      expect(updatedUser.phone, user.phone);
      expect(updatedUser.role, user.role);
      expect(updatedUser.company, user.company);
    });
  });
}
