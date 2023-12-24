import 'package:flutter/material.dart';
import 'package:pets_app/screens/add_pet.dart';
import 'package:pets_app/screens/home.dart';
import 'package:pets_app/screens/pets_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const Home(),
          '/add-pet': (context) => const AddPetScreen(),
          '/pet-details': (context) => const PetDetailsScreen()
        });
  }
  // This widget is the root of your application.
}
