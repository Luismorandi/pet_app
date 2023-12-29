import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:logger/logger.dart';

import '../api_services/pets_app.dart';
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
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  ApiService apiService = ApiService();

  List<Map<String, dynamic>> types = [];

  bool isAddressFound = false;

  @override
  void initState() {
    super.initState();
    getTypes();
  }

  Future<void> getTypes() async {
    try {
      final response = await apiService.getTypes();

      setState(() {
        types = response
            .map<Map<String, dynamic>>((type) => {
                  "label": type['type'],
                })
            .toList();
      });
    } catch (error) {
      logger.e("Error al obtener datos: $error");
    }
  }

  Future<bool> searchAddresses(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      return locations.isNotEmpty;
    } catch (error) {
      return false;
    }
  }

  Future<void> createPet() async {
    try {
      String result = AuthData
              .userCredential?.additionalUserInfo?.profile?['id']
              ?.toString() ??
          'N/A';

      bool isAddressValid = await searchAddresses(addressController.text);

      if (isAddressValid) {
        List<Location> locations =
            await locationFromAddress(addressController.text);
        Location location = locations.first;
        String coordinates = "${location.latitude}, ${location.longitude}";

        final response = await Dio().post(
          "https://petappback-production.up.railway.app/api/v1/pets",
          data: {
            "name": nameController.text,
            "type": typeController.text,
            "age": int.parse(ageController.text),
            "genre": genreController.text,
            "breed": breedController.text,
            "ownerId": result,
            "address": coordinates,
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
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('La dirección no es válida.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      logger.e("Error al agregar mascota: $error");
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
          TextFormField(
            controller: addressController,
            decoration: const InputDecoration(labelText: 'Dirección manual'),
            onChanged: (value) {
              searchAddresses(value).then((found) {
                setState(() {
                  isAddressFound = found;
                });
              });
            },
          ),
          Text(
            isAddressFound ? 'Dirección encontrada' : 'Dirección no encontrada',
            style: TextStyle(
              color: isAddressFound ? Colors.green : Colors.red,
              fontSize: 12,
            ),
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
                    .toSet()
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
            decoration: const InputDecoration(labelText: 'Sexo'),
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
