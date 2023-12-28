import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/home.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  List<Marker> markers = [];
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        print(_currentPosition?.longitude);
      });
    } catch (e) {
      print("Error al obtener la ubicación: $e");
      // Puedes manejar el caso en el que no se pueda obtener la ubicación
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Pet>? arguments =
        ModalRoute.of(context)?.settings.arguments as List<Pet>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
      ),
      body: _currentPosition != null
          ? GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentPosition?.latitude ?? 0.0,
                  _currentPosition?.longitude ?? 0.0,
                ),
                zoom: 12.0,
              ),
              markers: Set.from(markers),
            )
          : Center(
              child:
                  CircularProgressIndicator(), // o algún otro indicador de carga
            ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;

      // Agrega marcadores para las ubicaciones deseadas
      _addMarker(LatLng(37.7749, -122.4194), 'Ubicación 1');
      _addMarker(LatLng(37.7897, -122.4057), 'Ubicación 2');
      // Agrega más marcadores según sea necesario
    });
  }

  void _addMarker(LatLng position, String markerId) {
    markers.add(
      Marker(
        markerId: MarkerId(markerId),
        position: position,
        infoWindow: InfoWindow(title: markerId),
      ),
    );
  }
}
