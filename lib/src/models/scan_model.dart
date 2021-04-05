import 'dart:convert';
// Para @required
import 'package:meta/meta.dart';
// Maps
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

// Toma el JSon y crea una instancia del modelo
ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));
String scanModelToJson(ScanModel data) => json.encode(data.toJson());

class ScanModel {
  int id;
  String tipo;
  String valor;

  ScanModel({
    this.id,
    this.tipo,
    @required this.valor,
  }) {
    if (this.valor.contains('http')) {
      this.tipo = 'http';
    } else {
      this.tipo = 'geo';
    }
  }

  // TODO GEO Regresa la latitud y longitud de una coordenada
  LatLng getLagIng() {
    final latLng = this.valor.substring(4).split(',');
    final latitud = double.parse(latLng[0]);
    final longitud = double.parse(latLng[1]);

    return LatLng(latitud, longitud);
  }

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        tipo: json["tipo"],
        valor: json["valor"],
      );

  // Toma la instancia de la Class y la pasa a un JSON
  Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "valor": valor,
      };
}
