class Discussion {
  int? id;
  String name;

  Discussion({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      if (id != null) 'id': id,
      'name': name,
    };
  }

  factory Discussion.fromMap(Map<String, dynamic> map) {
    return Discussion(
      id: map['id'],
      name: map['name'],
    );
  }

  @override
  String toString() {
    return 'Discussion{id: $id, name: $name}';
  }
}
