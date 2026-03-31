class User {
  final String id;
  final String fullName;
  final String email;
  final String? profilePicUrl;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.profilePicUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      profilePicUrl: json['profilePicUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'profilePicUrl': profilePicUrl,
    };
  }
}
