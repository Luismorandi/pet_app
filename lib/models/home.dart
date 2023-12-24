class Pet {
  final String name;
  final int age;
  final String type;
  final String genre;
  final String breed;
  Pet(
      {required this.name,
      required this.age,
      required this.type,
      required this.genre,
      required this.breed});
}

class PetType {
  final String type;

  PetType({required this.type});
}
