class Group {
  int? id;
  String name;

  Group({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'],
      name: map['name'],
    );
  }

  @override
  String toString() {
    return 'Group{id: $id, name: $name}';
  }
}
