import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pets_app/screens/auth_static.dart';
import '../api_services/pets_app.dart';
import '../models/home.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Pet>? pets;
  List<PetType>? types;
  PetType? selectedType;
  List<Pet>? originalPets;

  TextEditingController searchController = TextEditingController();
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    getPets();
    fetchTypes();
    filterPetsByType(null);
    AuthData.authVerification(context);
  }

  Future<void> getPets() async {
    try {
      final petList = await apiService.getPets();
      setState(() {
        pets = petList;
        originalPets = List.from(pets!);
      });
    } catch (error) {
      print('Error fetching pets: $error');
      // Handle the error according to your needs
    }
  }

  Future<void> fetchTypes() async {
    try {
      final response = await apiService.getTypes();
      List<PetType> typeList = List<PetType>.from(response.map((type) {
        return PetType(
          type: type['type'],
        );
      }));

      setState(() {
        types = typeList;
      });
    } catch (error) {
      print('Error fetching types: $error');
      // Handle the error according to your needs
    }
  }

  void filterPetsByType(PetType? type) {
    setState(() {
      if (type == null) {
        pets = List.from(originalPets ?? []);
      } else {
        pets = originalPets?.where((pet) => pet.type == type.type).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pets App"),
        actions: [
          CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(
              "${AuthData.userCredential?.additionalUserInfo?.profile?['picture']}",
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 18.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    _showOptionsBottomSheet(context);
                  },
                  icon: const Icon(Icons.menu),
                ),
              ],
            ),
            const SizedBox(height: 18.0),
            Text(
              'Find a new friend',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Material(
              elevation: 2.0,
              borderRadius: BorderRadius.circular(30.0),
              child: TextField(
                controller: searchController,
                onChanged: filterPetsByNameOrType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0.0,
                    ),
                  ),
                  filled: true,
                  hintText: "Search",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  fillColor: Colors.grey[50],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: types?.length ?? 0,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: selectedType == types![index]
                        ? Colors.purple[800]
                        : Colors.purple[400],
                    child: InkWell(
                      onTap: () {
                        _onTypeTap(types![index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Center(
                          child: Text(
                            '${types![index].type[0].toUpperCase()}${types![index].type.substring(1)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: pets == null || pets!.isEmpty
                  ? Center(
                      child: Text(
                        'No hay mascotas por ahora',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: pets?.length ?? 0,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          _onPetTap(pets![index]);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white70,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                child: Image.network(
                                  "${pets![index].imageUrl}",
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${pets![index].name} - ${pets![index].age} año/s',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void filterPetsByNameOrType(String query) {
    setState(() {
      if (query.isEmpty) {
        pets = List.from(originalPets ?? []);
      } else {
        pets = originalPets
            ?.where((pet) =>
                pet.name
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                pet.name.toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _onTypeTap(PetType type) {
    setState(() {
      if (selectedType == type) {
        selectedType = null;
      } else {
        selectedType = type;
      }
    });
    filterPetsByType(selectedType);
  }

  void _onPetTap(dynamic pet) {
    Navigator.pushNamed(context, '/pet-details', arguments: pet);
  }

  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      User? user = FirebaseAuth.instance.currentUser;
      DefaultCacheManager().emptyCache();
      AuthData.userCredential = null;
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200.0,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.upload),
                  title: const Text('Upload Pet'),
                  onTap: () {
                    Navigator.pushNamed(context, '/add-pet');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.upload),
                  title: const Text('Cerrar sesion'),
                  onTap: signOut,
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
