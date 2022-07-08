import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/stores.dart';

class SpecificMap extends StatefulWidget {
  final Stores store;
  SpecificMap({required this.store, Key? key}) : super(key: key);
  @override
  _SpecificMap createState() => _SpecificMap(store: store);
  /*latitude: double.parse(store.latitude!),
      longitude: double.parse(store.longitude!));*/
}

class _SpecificMap extends State<SpecificMap> {
  late GoogleMapController mapController; //contrller for Google map
  final Set<Marker> markers = new Set();
  final Stores store;
  double longitude = 0;
  double latitude = 0;
  double distance = 0.0;
  double currentlongitude = 0, currentlatitude = 0;
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;

  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    checkGps();
    super.initState();
  }

  _SpecificMap({required this.store}) {
    latitude = double.parse(store.latitude!);
    longitude = double.parse(store.longitude!);
  }
  //markers for google map
  //location to show in map
  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }
      if (haspermission) {
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }
    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    currentlongitude = position.longitude;
    currentlatitude = position.latitude;
    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      currentlongitude = position.longitude;
      currentlatitude = position.latitude;
      setState(() {
        //refresh UI on update
      });
    });
  }

  void coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    coordinateDistance(currentlatitude, currentlongitude, latitude, longitude);
    LatLng showLocation = LatLng(latitude, longitude);
    return Scaffold(
      appBar: AppBar(
        title: Text("Distance is:  $distance"),
        backgroundColor: Colors.blueAccent,
      ),
      body: GoogleMap(
        //Map widget from google_maps_flutter package
        zoomGesturesEnabled: true, //enable Zoom in, out on map
        initialCameraPosition: CameraPosition(
          //innital position in map
          target: showLocation, //initial position
          zoom: 10.0, //initial zoom level
        ),
        markers: getmarkers(), //markers to show on map
        mapType: MapType.normal, //map type
        onMapCreated: (controller) {
          //method called when map is created
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }

  Set<Marker> getmarkers() {
    //markers to place on map
    LatLng showLocation = LatLng(latitude, longitude);
    setState(() {
      markers.add(Marker(
        //add first marker
        markerId: MarkerId(showLocation.toString()),
        position: showLocation, //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: '${store.storeName} ',
          snippet: '${store.description} ',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker(
        //add second marker
        markerId: MarkerId(showLocation.toString()),
        position:
            LatLng(currentlatitude, currentlongitude), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Your Curret Location ',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      )); //add more markers here
    });

    return markers;
  }
}
