class UserModel {
  final String username;
  final String password;

  UserModel({required this.username, required this.password});

  // Factory constructor to create an instance from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      password: json['password'],
    );
  }

  // Method to convert the instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
