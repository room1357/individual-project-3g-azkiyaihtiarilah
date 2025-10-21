class User {
  final String fullname;
  final String email;
  final String username;
  final String password;

  User({
    required this.fullname,
    required this.email,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'fullname': fullname,
        'email': email,
        'username': username,
        'password': password,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        fullname: json['fullname'],
        email: json['email'],
        username: json['username'],
        password: json['password'],
      );
}
