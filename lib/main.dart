import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ubicación y Caminos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LocationScreen(),
    );
  }
}

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String _locationMessage = "Presiona el botón para obtener tu ubicación";
  late GoogleMapController _mapController;
  LatLng _currentPosition = LatLng(37.4219983, -122.084); // Coordenadas iniciales
  Set<Marker> _markers = {};

  Future<void> _getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Mostrar un diálogo o notificación para habilitar el servicio de ubicación
    return Future.error('El servicio de ubicación está deshabilitado.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Los permisos de ubicación están denegados.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Los permisos de ubicación están permanentemente denegados.');
  }

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  setState(() {
    _locationMessage = "Latitud: ${position.latitude}, Longitud: ${position.longitude}";
    _currentPosition = LatLng(position.latitude, position.longitude);
    _markers.clear();
    _markers.add(
      Marker(
        markerId: MarkerId('currentLocation'),
        position: _currentPosition,
        infoWindow: InfoWindow(title: 'Tu ubicación'),
      ),
    );
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 15));
  });
}


  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('initialPosition'),
          position: _currentPosition,
          infoWindow: InfoWindow(title: 'Posición Inicial'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubicación Actual en el Mapa"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 14.0,
              ),
              markers: _markers,
              myLocationEnabled: true, // Mostrar el botón de mi ubicación
              myLocationButtonEnabled: true,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_locationMessage),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _getCurrentLocation,
                    child: Text("Obtener Ubicación"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
