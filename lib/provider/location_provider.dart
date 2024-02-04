import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  Location? _location;
  Location? get location => _location;
  LatLng? _locationPosition;
  LatLng? get locationPosition => _locationPosition;
  bool? locationServiceActive = true;
  LocationData? _locationData;
  LocationData? get locationData => _locationData;

  LocationProvider() {
    _location =  Location();
  }

  initialization() async {
    await getUserLocation();
  }

  getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location!.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location!.requestService();

      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location!.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location!.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
     // for always getting user location
    // location!.onLocationChanged.listen((LocationData? currentLocation) {
    //   _locationPosition = LatLng(currentLocation!.latitude!, currentLocation.longitude!);
    //   print(_locationPosition);
    // });

    _locationData = await location!.getLocation();
    print("locationData  =>  " +_locationData.toString());
    _locationPosition = LatLng(_locationData!.latitude!, _locationData!.longitude!);
    notifyListeners();
  }
}
