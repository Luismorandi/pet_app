import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pets_app/firebase_options.dart';
import 'package:pets_app/screens/add_pet.dart';
import 'package:pets_app/screens/auth.dart';
import 'package:pets_app/screens/home.dart';
import 'package:pets_app/screens/map_screen.dart';
import 'package:pets_app/screens/pets_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
          '/': (context) => const Auth(),
          '/home': (context) => const Home(),
          '/add-pet': (context) => const AddPetScreen(),
          '/pet-details': (context) => const PetDetailsScreen(),
          '/maps': (context) => MapScreen()
        });
  }
  // This widget is the root of your application.
}
