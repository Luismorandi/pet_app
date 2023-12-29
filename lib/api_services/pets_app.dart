import 'dart:io';

import 'package:dio/dio.dart';

import '../models/home.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Pet>> getPets() async {
    final response = await _dio
        .get("https://petappback-production.up.railway.app/api/v1/pets");
    return List<Pet>.from(response.data.map((pet) => Pet(
        name: pet['name'],
        age: pet['age'],
        type: pet['type'],
        genre: pet['genre'],
        breed: pet['breed'],
        description: pet['description'],
        imageUrl: pet['imageUrl'],
        address: pet['address'])));
  }

  Future<List<dynamic>> getTypes() async {
    try {
      final response = await Dio()
          .get("https://petappback-production.up.railway.app/api/v1/types");
      return response.data;
    } catch (error) {
      throw new HttpException("Error: get types not found");
    }
  }

  Future<List<dynamic>> getCountries() async {
    try {
      final response = await Dio().get("https://restcountries.com/v3.1/all");
      return response.data;
    } catch (error) {
      throw new HttpException("Error: get countries not found");
    }
  }
}
