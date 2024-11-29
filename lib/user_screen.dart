import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = LatLng(37.4219983, -122.084); // Coordenadas iniciales
  Set<Marker> _markers = {};
  LatLng? _selectedPoint;
  double? _price;

  // Función para manejar cuando el usuario toca el mapa
  void _onTapMap(LatLng position) {
    setState(() {
      _selectedPoint = position;
      _markers.clear(); // Limpiar cualquier marcador previo
      _markers.add(Marker(
        markerId: MarkerId('selectedPoint'),
        position: position,
        infoWindow: InfoWindow(title: 'Punto Seleccionado'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuario - Marcar Punto"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 14.0,
              ),
              markers: _markers,
              onTap: _onTapMap, // Permitir al usuario tocar el mapa
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_selectedPoint != null)
                    Column(
                      children: [
                        Text(
                          "Latitud: ${_selectedPoint!.latitude}, Longitud: ${_selectedPoint!.longitude}",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Ingresa el precio deseado',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _price = double.tryParse(value);
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        if (_price != null)
                          Text(
                            'Precio seleccionado: \$${_price!.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  if (_selectedPoint == null)
                    Text(
                      "Toque el mapa para seleccionar un punto",
                      style: TextStyle(fontSize: 16),
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
