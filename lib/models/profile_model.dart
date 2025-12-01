class Profile {
  final String name;
  final String email;
  final String phone;
  final String profileImageUrl;

  Profile({
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
    };
  }
}
