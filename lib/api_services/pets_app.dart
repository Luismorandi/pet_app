import 'package:dio/dio.dart';

import '../models/home.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Pet>> getPets() async {
    final response = await _dio.get("http://172.18.160.1:8080/api/v1/pets");
    return List<Pet>.from(response.data.map((pet) => Pet(
        name: pet['name'],
        age: pet['age'],
        type: pet['type'],
        genre: pet['genre'],
        breed: pet['breed'])));
  }

  Future<List<PetType>> getTypes() async {
    final response = await _dio.get("http://172.18.160.1:8080/api/v1/types");
    print(response.data);
    return List<PetType>.from(response.data.map((type) => PetType(
          type: type['type'],
        )));
  }
}
