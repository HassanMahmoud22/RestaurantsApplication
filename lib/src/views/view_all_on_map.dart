import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/stores.dart';

class ViewAllOnMap extends StatefulWidget {
  final List<Stores> stores;
  ViewAllOnMap({required this.stores, Key? key}) : super(key: key);
  @override
  _ViewAllOnMap createState() => _ViewAllOnMap(stores: stores);
  /*latitude: double.parse(store.latitude!),
      longitude: double.parse(store.longitude!));*/
}

class _ViewAllOnMap extends State<ViewAllOnMap> {
  late GoogleMapController mapController; //contrller for Google map
  final Set<Marker> markers = new Set();
  final List<Stores> stores;
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

  _ViewAllOnMap({required this.stores});
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
    setState(() {
      currentlongitude = position.longitude;
      currentlatitude = position.latitude;
    });
 
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      setState(() {
        currentlongitude = position.longitude;
        currentlatitude = position.latitude;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("currents");
    print(currentlatitude);
    print(currentlongitude);
    LatLng showLocation = LatLng(
        double.parse(stores[0].latitude!), double.parse(stores[0].longitude!));
    return Scaffold(
      appBar: AppBar(
        title: Text("All Stores On Map"),
        backgroundColor: Colors.blueAccent,
      ),
      body: GoogleMap(
        //Map widget from google_maps_flutter package
        zoomGesturesEnabled: true, //enable Zoom in, out on map
        initialCameraPosition: CameraPosition(
          //innital position in map
          target: showLocation,
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
    setState(() {
      for (int i = 0; i < stores.length; i++) {
        LatLng showLocation = LatLng(double.parse(stores[i].latitude!),
            double.parse(stores[i].longitude!));
        /*LatLng showLocation = LatLng(
          double.parse(stores[i].latitude!), double.parse(stores[i].longitude!));*/

        markers.add(Marker(
          markerId: MarkerId(showLocation.toString()),
          position: LatLng(double.parse(stores[i].latitude!),
              double.parse(stores[i].longitude!)), //position of marker
          infoWindow: InfoWindow(
            //popup info
            title: '${stores[i].storeName} ',
            snippet: '${stores[i].description} ',
          ),
          icon: BitmapDescriptor.defaultMarker, //Icon for Marker
        ));
      }
      LatLng showLocation = LatLng(currentlatitude, currentlongitude);
      markers.add(Marker(
        //add second marker
        markerId: MarkerId(showLocation.toString()),
        position:
            LatLng(currentlatitude, currentlongitude), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Your Current Location ',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      )); //add more markers here
    });
    //markers to place on map
    return markers;
  }
}
