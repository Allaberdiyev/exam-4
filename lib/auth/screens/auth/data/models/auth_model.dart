class AuthModel {
  String? id;
  final String login;
  final String password;

  AuthModel({required this.login, required this.password, this.id = ''});
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json["id"],
      login: json['login'].toString(),
      password: json['password'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'login': login, 'password': password};
  }
}
