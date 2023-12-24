import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pets_app/screens/home.dart';

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
  final TextEditingController ownerIdController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<Map<String, dynamic>> types = [];
  List<Map<String, dynamic>> countries = [];

  // Método para obtener la lista de países
  Future<void> getCountries() async {
    try {
      final response = await Dio().get("https://restcountries.com/v3.1/all");
      setState(() {
        // Ajusta la lógica para adaptarse a la estructura de tus datos
        countries = List<Map<String, dynamic>>.from(response.data)
            .map((country) =>
                {"value": country["cca3"], "label": country["name"]["common"]})
            .toList();
        print("countries: $countries");
      });
    } catch (error) {
      print("Error al obtener datos de países: $error");
    }
  }

  // Define the getTypes method here
  Future<void> getTypes() async {
    try {
      final response = await Dio().get("http://172.18.160.1:8080/api/v1/types");
      setState(() {
        // Ajusta la lógica para adaptarse a la estructura de tus datos
        types = List<Map<String, dynamic>>.from(response.data)
            .map((type) => {"value": type["id"], "label": type["type"]})
            .toList();
        print("Types: $types");
      });
    } catch (error) {
      print("Error al obtener datos: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    getCountries();
    getTypes(); // Llama a la función para obtener los tipos al cargar la pantalla
  }

  Future<void> createPet() async {
    try {
      final response = await Dio().post(
        "http://172.18.160.1:8080/api/v1/pets",
        data: {
          "name": nameController.text,
          "type": typeController.text,
          "age": int.parse(ageController.text),
          "genre": genreController.text,
          "breed": breedController.text,
          "ownerId": ownerIdController.text,
          "address": addressController.text,
          "description": descriptionController.text,
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
                  Navigator.pushNamed(context, '/');
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
          DropdownButtonFormField<String>(
            value: typeController.text.isNotEmpty ? typeController.text : null,
            onChanged: (String? value) {
              setState(() {
                typeController.text = value ?? '';
              });
            },
            items: types
                    ?.where((type) =>
                        type['value'] is String && type['label'] is String)
                    .map<DropdownMenuItem<String>>(
                      (type) => DropdownMenuItem<String>(
                        value: type['label'],
                        child: Text(type['label']),
                      ),
                    )
                    .toList() ??
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
          TextFormField(
            controller: ownerIdController,
            decoration: const InputDecoration(labelText: 'ID del Propietario'),
          ),
          DropdownButtonFormField<String>(
            value: countries.isNotEmpty ? countries[0]['value'] : null,
            onChanged: (String? value) {
              setState(() {
                // Al seleccionar un país, actualiza el texto del controlador de dirección
                addressController.text = value ?? '';
              });
            },
            items: countries
                    ?.where((country) =>
                        country['value'] is String &&
                        country['label'] is String)
                    .map<DropdownMenuItem<String>>(
                      (country) => DropdownMenuItem<String>(
                        value: country['value'],
                        child: Text(country['label']),
                      ),
                    )
                    .toList() ??
                [],
            decoration: const InputDecoration(labelText: 'País'),
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
