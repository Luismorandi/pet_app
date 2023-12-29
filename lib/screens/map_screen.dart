import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

import '../models/home.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var logger = Logger(
    printer: PrettyPrinter(),
  );
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
      });
    } catch (e) {
      logger.e("Error al obtener la ubicación: $e");
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
              onMapCreated: (controller) =>
                  _onMapCreated(controller, arguments),
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
              child: CircularProgressIndicator(),
            ),
    );
  }

  void _onMapCreated(GoogleMapController controller, List<Pet>? pets) {
    setState(() {
      mapController = controller;
      if (pets != null) {
        for (var elemento in pets) {
          if (elemento != null && elemento.address != null) {
            List<String> coordenadas = elemento.address.split(', ');
            if (coordenadas.length == 2) {
              try {
                double latitud = double.parse(coordenadas[0]);
                double longitud = double.parse(coordenadas[1]);

                _addMarker(
                    LatLng(latitud, longitud), 'Ubicación ${elemento.name}');
                Marker marker = Marker(
                  markerId: MarkerId('Ubicación ${elemento.name}'),
                  position: LatLng(latitud, longitud),
                  onTap: () {
                    Navigator.pushNamed(context, '/pet-details',
                        arguments: elemento);
                  },
                );

                markers.add(marker);
              } catch (e) {
                logger.e(
                    "Error al convertir coordenadas para ${elemento.name}: $e");
              }
            } else {
              logger.e(
                  "Formato de coordenadas incorrecto para ${elemento.name}: ${elemento.address}");
            }
          }
        }
      }
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
