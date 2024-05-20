class Contact {
  int? id;
  String firstName;
  String lastName;
  String phoneNumber;

  Contact({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      phoneNumber: map['phone_number'],
    );
  }

  @override
  String toString() {
    return 'Contact{id: $id, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber}';
  }
}
