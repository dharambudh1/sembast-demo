class Details {
  final int? id;
  final String firstName;
  final String lastName;
  final String gender;
  final int age;

  const Details({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'age': age,
    };
  }

  Details copy({
    int? id,
    String? firstName,
    String? lastName,
    String? gender,
    int? age,
  }) =>
      Details(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        gender: gender ?? this.gender,
        age: age ?? this.age,
      );

  factory Details.fromMap(int id, Map<String, dynamic> map) {
    return Details(
      id: id,
      firstName: map['firstName'],
      lastName: map['lastName'],
      gender: map['gender'],
      age: map['age'],
    );
  }
}
