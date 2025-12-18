import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String? profileImageUrl;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  String? phoneNumber;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.createdAt,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'phoneNumber': phoneNumber,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt']),
      phoneNumber: json['phoneNumber'] as String?,
    );
  }
}

