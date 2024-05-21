import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:postgres/postgres.dart';

class DatabaseHelper {
  Connection? connection;
  Future<void> connect() async {
    try {
      connection = await Connection.open(Endpoint(
        host: '10.0.2.16',
        database: 'saeed',
      ));

      print('connect success');
    } catch (e) {
      print('error connectio: $e');
    }
  }

  Future<List<LatLng>> getPoints() async {
    if (connection == null) return [];
    List<List<dynamic>> results = await connection!.execute(
      'SELECT geomtry FROM points',
    );

    return results.map((row) {
      final point = row[0] as String; // assuming 'geomtry' is a string
      final latLng = point.split(','); // assuming 'geomtry' format is "lat,lng"
      return LatLng(double.parse(latLng[0]), double.parse(latLng[1]));
    }).toList();
  }
}
