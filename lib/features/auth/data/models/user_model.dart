class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.token,
  });

  final int id;
  final String name;
  final String role;
  final String token;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      token: json['token'] as String? ?? '',
    );
  }
}
