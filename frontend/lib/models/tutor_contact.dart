class TutorContact {
  final String email;
  final String phone;

  const TutorContact({required this.email, required this.phone});

  factory TutorContact.fromJson(Map<String, dynamic> json) {
    return TutorContact(
      email: json['email'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'phone': phone};
  }
}
