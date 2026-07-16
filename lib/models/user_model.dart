class UserModel {
  final String id;
  final String? token;
  final String email;
  final String username;
  final String? phone;
  final String role;
  const UserModel({
    required this.id,
    this.token,
    this.phone,
    required this.email,
    required this.username,
    required this.role,
  });

  factory UserModel.fromLoginJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['_id'] ?? json['user']['id'],
      token: json['token'] ?? '',
      email: json['user']['email'],
      username: json['user']['username'],
      phone: json['user']['phone'] ?? '-',
      role: json['user']['role'],
    );
  }
}
