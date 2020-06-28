import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' show jsonEncode;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custos/utilities/constants.dart';
import 'package:custos/widgets/customised_bottom_navbar.dart';

class MapScreen extends StatefulWidget {
  static String id = 'MapScreen';

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  Firestore _firestore = Firestore.instance;

  Set<Circle> _redZones = {};

  double zoneLatitude, zoneLongitude;

  Timer timer;

  static double initialLat, initialLong;

  static final CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(initialLat, initialLong),
    zoom: 15.4746,
  );

  @override
  void initState() {
    super.initState();

    _getInitialLocation();
    _getDangerZones();
  }

  void _getInitialLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      initialLat = position.latitude;
      initialLong = position.longitude;
    });
  }

  void _getDangerZones() async {
    final dangerZones = await _firestore.collection('dangerZones').getDocuments();

    for (var zone in dangerZones.documents) {
      setState(() {
        zoneLatitude = zone.data['Latitude'];
        zoneLongitude = zone.data['Longitude'];
      });

      _redZones.add(Circle(
        circleId: CircleId('${_redZones.length}'),
        radius: 49,
        strokeWidth: 1,
        strokeColor: Colors.red,
        fillColor: Color(0xFFFFCDD2).withOpacity(0.56),
        center: LatLng(zoneLatitude, zoneLongitude),
      ));
    }
  }

  Circle yellowZone = Circle(
    circleId: CircleId('yellowZone'),
    radius: 50,
    strokeWidth: 1,
    strokeColor: Colors.amber,
    fillColor: Color(0xFFFFECB3).withOpacity(0.56),
    center: LatLng(29.992770, 31.163191),
  );

  Circle orangeZone = Circle(
    circleId: CircleId('orangeZone'),
    radius: 50,
    strokeWidth: 1,
    strokeColor: Colors.orange,
    fillColor: Color(0xFFFFB74D).withOpacity(0.56),
    center: LatLng(29.992770, 31.173191),
  );

/*  Circle redZone = Circle(
    circleId: CircleId('redZone'),
    radius: 50,
    strokeWidth: 1,
    strokeColor: Colors.red,
    fillColor: Color(0xFFFFCDD2).withOpacity(0.56),
    center: LatLng(29.992770, 31.183191),
  );*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: initialLat == null
            ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4682B4)), strokeWidth: 3))
            : GoogleMap(
                initialCameraPosition: _cameraPosition,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                circles: _redZones,
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(jsonEncode(kMapNightTheme));
                },
                //circles: Set.of(_circles.values),
              ),
      ),
      bottomNavigationBar: CustomisedBottomNavigationBar(
        index: 1,
        isBottomNavItem: true,
      ),
    );
  }
}
