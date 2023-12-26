// pet_details_screen.dart
import 'package:flutter/material.dart';
import 'package:pets_app/models/home.dart';

class PetDetailsScreen extends StatelessWidget {
  const PetDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pet? arguments = ModalRoute.of(context)?.settings.arguments as Pet;
    if (arguments != null) {
      final Pet pet = arguments;

      // Ahora puedes acceder a los detalles del pet
      final String petName = pet.name;
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          "${pet.imageUrl}",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 10,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Su raza es ${pet.breed} - Tiene ${pet.age} años",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Tipo: ${pet.type}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Genero: ${pet.genre}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "${pet.description}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple[400],
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 100,
                    ),
                  ),
                  onPressed: () => print('Adopt'),
                  child: const Text('Adoptar'),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error en los argumentos'),
        ),
      );
    }
    return SizedBox.shrink();
  }
}
