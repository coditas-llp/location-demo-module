import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FlutterMapPackage extends StatefulWidget {
  const FlutterMapPackage({super.key});

  @override
  _FlutterMapPackageState createState() => _FlutterMapPackageState();
}

class _FlutterMapPackageState extends State<FlutterMapPackage> {
  double long = 73.9210;
  double lat = 18.5513;
  LatLng point = LatLng(73.9210, 18.5513);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            onTap: (p, l) async {
              // var data = await Geocoder2.getDataFromCoordinates(
              //   latitude: l.latitude,
              //   longitude: l.longitude,
              //   googleMapApiKey: '',
              // );

              setState(() {
                point = l;
                print(p);
              });

              // print("${data.country} - ${data.city}");
            },
            center: LatLng(73.9210, 18.5513),
            zoom: 5.0,
          ),
          children: [
            TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c']),
            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: point,
                  builder: (ctx) => const Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 34.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(16.0),
                    hintText: "Search for your localisation",
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Text(
                      //     "${location.first.countryName},${location.first.locality}, ${location.first.featureName}"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
