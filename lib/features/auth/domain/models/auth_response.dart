import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_response.g.dart';

/// Authentication response model
@JsonSerializable()
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final int expiresIn;
  
  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.expiresIn,
  });
  
  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

/// OTP send response
@JsonSerializable()
class OtpResponse {
  final bool success;
  final String message;
  final String? requestId;
  final int? expiresIn;
  
  OtpResponse({
    required this.success,
    required this.message,
    this.requestId,
    this.expiresIn,
  });
  
  factory OtpResponse.fromJson(Map<String, dynamic> json) => _$OtpResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$OtpResponseToJson(this);
}
