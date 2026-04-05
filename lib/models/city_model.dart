class City {
  final int id;
  final String name;

  const City({
    required this.id, 
    required this.name
  });

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}