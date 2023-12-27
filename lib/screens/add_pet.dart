import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pets_app/screens/home.dart';

import '../api_services/pets_app.dart';
import '../models/home.dart';
import 'auth_static.dart';

class AddPetScreen extends StatelessWidget {
  const AddPetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pet'),
      ),
      body: AddPetForm(),
    );
  }
}

class AddPetForm extends StatefulWidget {
  const AddPetForm({Key? key}) : super(key: key);

  @override
  _AddPetFormState createState() => _AddPetFormState();
}

class _AddPetFormState extends State<AddPetForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  ApiService apiService = ApiService();
  Position? _currentPosition;

  List<Map<String, dynamic>> types = [];
  List<Map<String, dynamic>> pets = [];

  List<Map<String, dynamic>> countries = [];

  Future<void> getCountries() async {
    try {
      final response = await apiService.getCountries();
      setState(() {
        countries = List<Map<String, dynamic>>.from(response)
            .map((country) =>
                {"value": country["cca3"], "label": country["name"]["common"]})
            .toList();
      });
    } catch (error) {
      print("Error al obtener datos de países: $error");
    }
  }

  // Define the getTypes method here
  Future<void> getTypes() async {
    try {
      final response = await apiService.getTypes();
      print("antes");
      print(response);

      setState(() {
        types = response
            .map<Map<String, dynamic>>((type) => {
                  "label": type['type'],
                })
            .toList();
      });
    } catch (error) {
      print("Error al obtener datos: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    getCountries();
    getTypes();
    _getCurrentLocation();
  }

  Future<void> createPet() async {
    try {
      String result = AuthData
              .userCredential?.additionalUserInfo?.profile?['id']
              ?.toString() ??
          'N/A';
      final response = await Dio().post(
        "http://172.18.160.1:8080/api/v1/pets",
        data: {
          "name": nameController.text,
          "type": typeController.text,
          "age": int.parse(ageController.text),
          "genre": genreController.text,
          "breed": breedController.text,
          "ownerId": result,
          "address": addressController.text,
          "description": descriptionController.text,
          "imageUrl": imageUrlController.text,
        },
      );

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Éxito'),
            content: const Text('La mascota se ha agregado exitosamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/home');
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print("Error al agregar mascota: $error");
      // Puedes mostrar un mensaje de error aquí si es necesario
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print(position);

      setState(() {
        _currentPosition = position;
        addressController.text = "${position.latitude}, ${position.longitude}";
      });
    } catch (e) {
      print("Error al obtener la ubicación: $e");
      // Puedes manejar el caso en el que no se pueda obtener la ubicación
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Descripción'),
          ),
          TextFormField(
            controller: imageUrlController,
            decoration: const InputDecoration(labelText: 'Imagen'),
          ),
          DropdownButtonFormField<String>(
            value: typeController.text.isNotEmpty ? typeController.text : null,
            onChanged: (String? value) {
              setState(() {
                typeController.text = value ?? '';
              });
            },
            items: types
                    ?.where((type) => type['label'] is String)
                    .toSet() // Eliminar duplicados
                    .map<DropdownMenuItem<String>>(
                  (type) {
                    final label = type['label'] as String?;
                    return DropdownMenuItem<String>(
                      value: label,
                      child: Text(label ?? ''),
                    );
                  },
                ).toList() ??
                [],
            decoration: const InputDecoration(labelText: 'Tipo'),
          ),
          TextFormField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Edad'),
          ),
          DropdownButtonFormField<String>(
            value:
                genreController.text.isNotEmpty ? genreController.text : null,
            onChanged: (String? value) {
              setState(() {
                genreController.text = value ?? '';
              });
            },
            items: [
              DropdownMenuItem<String>(
                value: 'M',
                child: const Text('Masculino'),
              ),
              DropdownMenuItem<String>(
                value: 'F',
                child: const Text('Femenino'),
              ),
            ],
            decoration: const InputDecoration(labelText: 'Género'),
          ),
          TextFormField(
            controller: breedController,
            decoration: const InputDecoration(labelText: 'Raza'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: createPet,
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
