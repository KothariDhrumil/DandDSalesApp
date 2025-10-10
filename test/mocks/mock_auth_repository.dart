import 'package:mockito/mockito.dart';
import 'package:dandd_sales_app/features/auth/domain/models/auth_response.dart';
import 'package:dandd_sales_app/features/auth/domain/models/user_model.dart';
import 'package:dandd_sales_app/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
