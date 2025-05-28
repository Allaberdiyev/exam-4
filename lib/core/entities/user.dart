import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String gender;
  final String birthday;
  final String phoneNumber;
  final String level;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.birthday,
    required this.phoneNumber,
    required this.level,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      birthday: json['birthday'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      level: json['level'] ?? 'Standard',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'birthday': birthday,
      'phoneNumber': phoneNumber,
      'level': level,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? gender,
    String? birthday,
    String? phoneNumber,
    String? level,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      level: level ?? this.level,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    gender,
    birthday,
    phoneNumber,
    level,
  ];
}
