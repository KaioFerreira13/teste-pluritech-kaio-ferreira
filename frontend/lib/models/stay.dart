class Stay {
  final String id;
  final String code;
  final String tutorName;
  final String tutorContact;
  final String species;
  final String breed;
  final DateTime entryDate;
  final DateTime? expectedExitDate;
  final int currentDays;
  final int? expectedTotalDays;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Stay({
    required this.id,
    required this.code,
    required this.tutorName,
    required this.tutorContact,
    required this.species,
    required this.breed,
    required this.entryDate,
    required this.expectedExitDate,
    required this.currentDays,
    required this.expectedTotalDays,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Stay.fromJson(Map<String, dynamic> json) {
    return Stay(
      id: json['id'] as String,
      code: json['code'] as String,
      tutorName: json['tutorName'] as String,
      tutorContact: json['tutorContact'] as String,
      species: json['species'] as String,
      breed: json['breed'] as String,
      entryDate: DateTime.parse(json['entryDate'] as String),
      expectedExitDate: json['expectedExitDate'] == null
          ? null
          : DateTime.parse(json['expectedExitDate'] as String),
      currentDays: json['currentDays'] as int,
      expectedTotalDays: json['expectedTotalDays'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
