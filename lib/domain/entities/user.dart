class User {
  final String id;
  final String name;
  final String email;
  final String username;
  final List<String> roles;
  final String state;
  final DateTime registrationDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.roles,
    required this.state,
    required this.registrationDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      roles: List<String>.from(json['roles'] as List),
      state: json['state'] as String,
      registrationDate: DateTime.parse(json['registrationDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'roles': roles,
      'state': state,
      'registrationDate': registrationDate.toIso8601String(),
    };
  }
} 