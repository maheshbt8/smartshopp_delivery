import 'package:delivery_template/model/server/sendlocation.dart';
import 'package:location/location.dart';
import '../main.dart';

class LocationMonitor{

  init() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    await location.getLocation();
    location.enableBackgroundMode(enable: true);
    location.onLocationChanged.listen((LocationData currentLocation) {
      dprint("Location ${currentLocation.latitude} ${currentLocation.longitude} ${currentLocation.speed} ${DateTime.fromMillisecondsSinceEpoch(currentLocation.time.toInt()).toString()}");
      if (prevCurrentLocationLatitude != currentLocation.latitude || prevCurrentLocationLongitude != currentLocation.longitude) {
        dprint("Send");
        prevCurrentLocationLatitude = currentLocation.latitude;
        prevCurrentLocationLongitude = currentLocation.longitude;
        sendLocation(account.token, currentLocation.latitude.toString(),
            currentLocation.longitude.toString(),
            currentLocation.speed.toString());
      }
    });
  }

  double prevCurrentLocationLatitude = 0;
  double prevCurrentLocationLongitude = 0;

  bool _serviceEnabled;
  final Location location = Location();
  PermissionStatus _permissionGranted;

  // 1
  Future<bool> checkPermissions() async {
    final PermissionStatus permissionGrantedResult = await location.hasPermission();
    _permissionGranted = permissionGrantedResult;
    return (_permissionGranted == PermissionStatus.granted);
  }

  Future<bool> requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult = await location.requestPermission();
      _permissionGranted = permissionRequestedResult;
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
}