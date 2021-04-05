import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_reader/src/models/scan_model.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  Completer<GoogleMapController> _controller = Completer();
  MapType mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    // TODO Leer argumentos de routes
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    final CameraPosition puntoInicial = CameraPosition(
      target: scan.getLagIng(),
      zoom: 18,
      tilt: 45.0,
    );

    // Marcadores
    Set<Marker> markers = new Set<Marker>();
    markers.add(
      Marker(
        markerId: MarkerId('geo-location-inicial'),
        position: scan.getLagIng(),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        centerTitle: true,
        actions: [
          // ** Boton para cambiar tipo de mapa
          IconButton(
            icon: Icon(Icons.map_outlined),
            onPressed: () async {
              if (mapType == MapType.normal) {
                mapType = MapType.hybrid;
              } else {
                mapType = MapType.normal;
              }
              setState(() {});
            },
          )
        ],
      ),

      // TODO Google Maps
      body: GoogleMap(
        myLocationButtonEnabled: true,
        mapType: mapType,
        zoomControlsEnabled: true,
        padding: EdgeInsets.all(15.0),
        markers: markers,
        initialCameraPosition: puntoInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.gps_fixed),
        elevation: 20.0,
        onPressed: () async {
          // ** Boton para volver a la ubicacion inicial
          final GoogleMapController controller = await _controller.future;
          controller
              .animateCamera(CameraUpdate.newCameraPosition(puntoInicial));
        },
      ),
    );
  }
}
