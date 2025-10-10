import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// User model
@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? role;
  final String? company;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.role,
    this.company,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? company,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      company: company ?? this.company,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
