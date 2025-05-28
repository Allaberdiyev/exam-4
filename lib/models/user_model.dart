class UserModel {
  final String id;
  final String name;
  final String email;
  final String gender;
  final String birthday;
  final String phoneNumber;
  final String level;
  final Map<String, dynamic>? notifications;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.birthday,
    required this.phoneNumber,
    required this.level,
    this.notifications,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      birthday: json['birthday'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      level: json['level'] ?? 'Standard',
      notifications: json['notifications'],
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
      'notifications': notifications,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? gender,
    String? birthday,
    String? phoneNumber,
    String? level,
    Map<String, dynamic>? notifications,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      level: level ?? this.level,
      notifications: notifications ?? this.notifications,
    );
  }
} 