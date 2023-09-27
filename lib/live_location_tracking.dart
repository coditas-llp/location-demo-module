import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LiveLocationTrackingPage extends StatefulWidget {
  const LiveLocationTrackingPage({Key? key}) : super(key: key);
  @override
  State<LiveLocationTrackingPage> createState() =>
      LiveLocationTrackingPageState();
}

class LiveLocationTrackingPageState extends State<LiveLocationTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);

  // final Set<Marker> _markers = <Marker>{};
  // final Set<Polygon> _polygons = <Polygon>{};
  // final Set<Polyline> _polylines = <Polyline>{};
  List<LatLng> polylineCoordinates = [];

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty,
      "assets/Pin_source.jpg",
    ).then(
      (icon) {
        sourceIcon = icon;
      },
    );
    // BitmapDescriptor.fromAssetImage(
    //         ImageConfiguration.empty, "assets/Pin_destination.png")
    //     .then(
    //   (icon) {
    //     destinationIcon = icon;
    //   },
    // );
    // BitmapDescriptor.fromAssetImage(
    //         ImageConfiguration.empty, "assets/Badge.png")
    //     .then(
    //   (icon) {
    //     currentLocationIcon = icon;
    //   },
    // );
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCfCt2TuIpUMvJ4eDhmh6-p1pwowQJNzyw',
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      // print(polylineCoordinates);
      setState(() {});
    }
  }

  LocationData? currentLocation;
  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    getPolyPoints();
    setCustomMarkerIcon();
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? const Center(child: Text("Loading"))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 13.5,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("currentLocation"),
                  icon: sourceIcon,
                  position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                ),
                Marker(
                  markerId: const MarkerId("source"),
                  // icon: sourceIcon,
                  position: sourceLocation,
                ),
                Marker(
                  markerId: const MarkerId("destination"),
                  // icon: destinationIcon,
                  position: destination,
                ),
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
              polylines: {
                Polyline(
                  visible: true,
                  polylineId: const PolylineId("route"),
                  points: polylineCoordinates,
                  color: Colors.blue,
                  width: 6,
                ),
              },
            ),
    );
  }
}
