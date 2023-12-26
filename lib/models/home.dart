class Pet {
  final String name;
  final int age;
  final String type;
  final String genre;
  final String breed;
  final String description;
  final String imageUrl;

  Pet(
      {required this.name,
      required this.age,
      required this.type,
      required this.genre,
      required this.breed,
      required this.description,
      required this.imageUrl});
}

class PetType {
  final String type;

  PetType({required this.type});

  dynamic operator [](String key) {
    if (key == 'type') {
      return type;
    }
    throw ArgumentError('Invalid key: $key');
  }
}
