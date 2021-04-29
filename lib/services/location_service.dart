import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:toast/toast.dart';

class LocationService {
  BuildContext context;
  LocationService(this.context);
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  Future<LocationData> getCurrentLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        Toast.show("location is needed to continue, please turn on", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        Toast.show(
            "location permission is needed to continue, please allow", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return null;
      }
    }

    return await location.getLocation();
  }
}
