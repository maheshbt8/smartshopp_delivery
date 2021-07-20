import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:delivery_template/model/server/getOrders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/model/geolocator.dart';
import 'package:delivery_template/model/order.dart';
import 'package:delivery_template/ui/widgets/iboxCircle.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class MapScreen extends StatefulWidget {
  Function(String) callback;
  final Map<String, dynamic> params;
  MapScreen({this.callback, this.params});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  _onOrderDetails(){
    account.currentOrder = account.openOrderOnMap;
    account.backRoute = "map";
    widget.callback("orderDetails");
  }

  _backButtonPress(){
    widget.callback(_getStringParam("backRoute"));
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  String _currentDistance = "";
  String _mapStyle;
  var location = GeoLocation();
  double _currentZoom = 12;

  _initCameraPosition(DriverOrders item, LatLng coord) async{
    // calculate zoom
    LatLng latLng_1 = LatLng(item.address1Latitude, item.address1Longitude,);
    LatLng latLng_2 = LatLng(item.address2Latitude, item.address2Longitude);
    dprint("latLng_1 = $latLng_1");
    dprint("latLng_2 = $latLng_2");
//    LatLngBounds bound;
//    if (latLng_1.latitude >= latLng_2.latitude) {
//      if (latLng_1.longitude <= latLng_2.longitude){
//        latLng_1 = LatLng(item.address1Latitude, item.address2Longitude,);
//        latLng_2 = LatLng(item.address2Latitude, item.address1Longitude);
//      }
//      bound = LatLngBounds(southwest: latLng_2, northeast: latLng_1);
//    }else
//      bound = LatLngBounds(southwest: latLng_1, northeast: latLng_2); // юго-запад - северо-восток

    var lat1 = latLng_1.latitude; // широта
    var lat2 = latLng_2.latitude;
    if (latLng_1.latitude > latLng_2.latitude) {
      lat1 = latLng_2.latitude;
      lat2 = latLng_1.latitude;
    }
    var lng1 = latLng_1.longitude;
    var lng2 = latLng_2.longitude;
    if (latLng_1.longitude > latLng_2.longitude) {
      lng1 = latLng_2.longitude;
      lng2 = latLng_1.longitude;
    }
    dprint ("lat1 = $lat1, lat2 = $lat2");
    dprint ("lng1 = $lng1, lng2 = $lng2");
    LatLngBounds bound = LatLngBounds(southwest: LatLng(lat1, lng1), northeast: LatLng(lat2, lng2)); // юго-запад - северо-восток
    dprint(bound.toString());

    CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 50);
    if (_controller != null)
      _controller.animateCamera(u2).then((void v){
       // check(u2,_controller);
      });

    double distance = await location.distanceBetween(item.address1Latitude, item.address1Longitude,
        item.address2Latitude, item.address2Longitude);

    if (appSettings.distanceUnit == "mi") {
      if (distance<20000)
        _currentDistance = (distance / 1609).toStringAsFixed(3); // to mi
      else
        _currentDistance = (distance / 1609).toStringAsFixed(0); // to mi
    }else{
      if (distance<20000)
        _currentDistance = (distance/1000).toStringAsFixed(3); // to km
      else
        _currentDistance = (distance/1000).toStringAsFixed(0); // to km
    }
    setState(() {
    });
  }

  Map<PolylineId, Polyline> _mapPolylines = {};
  int _polylineIdCounter = 1;
  Future<void> _add() async {
    for (var item in orders)
      if (item.id == account.openOrderOnMap) {
        final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
        _polylineIdCounter++;
        final PolylineId polylineId = PolylineId(polylineIdVal);

        var polylinePoints = PolylinePoints();
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          appSettings.googleApi,
          PointLatLng(item.address1Latitude, item.address1Longitude),
          PointLatLng(item.address2Latitude, item.address2Longitude),
          travelMode: TravelMode.driving,
        );
        List<LatLng> polylineCoordinates = [];

        if (result.points.isNotEmpty) {
          result.points.forEach((PointLatLng point) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          });
        }

        final Polyline polyline = Polyline(
          polylineId: polylineId,
          consumeTapEvents: true,
          color: Colors.red,
          width: 4,
          points: polylineCoordinates,
        );

        setState(() {
          _mapPolylines[polylineId] = polyline;
        });
        LatLng coordinates = LatLng(item.address1Longitude, item.address1Latitude);
        if (polylineCoordinates.isNotEmpty)
          coordinates = polylineCoordinates[polylineCoordinates.length~/2];
        _initCameraPosition(item, coordinates);
        _addMarker(item);
      }
  }

  _callUser() async {
    for (var item in orders)
      if (item.id == account.openOrderOnMap) {
        var uri = 'tel:${item.phone}';
        if (await canLaunch(uri))
          await launch(uri);
      }
  }

  @override
  void initState() {
    _add();
    if (account.openOrderOnMap != "")
    for (var item in orders)
      if (item.id == account.openOrderOnMap)
        _kGooglePlex = CameraPosition(target: LatLng(item.address1Latitude, item.address1Longitude), zoom: _currentZoom,); // paris coordinates

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    _initIcons();
    super.initState();
  }

  _initIcons() async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/marker1.png', 80);
    _iconHome = BitmapDescriptor.fromBytes(markerIcon);
    final Uint8List markerIcon2 = await getBytesFromAsset('assets/marker2.png', 80);
    _iconDest = BitmapDescriptor.fromBytes(markerIcon2);
  }


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(48.895605, 2.087823), zoom: 12,); // paris coordinates
  Set<Marker> markers = {};
  GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    if (_controller != null)
      if (theme.darkMode)
        _controller.setMapStyle(_mapStyle);
      else
        _controller.setMapStyle(null);

    return WillPopScope(
        onWillPop: () async {
      _backButtonPress();
      return false;
    },
    child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+40),
        child: Stack(children: <Widget>[

          _map(),

          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15,),
                  _buttonPlus(),
                  _buttonMinus(),
                  _buttonMyLocation(),
                ],
              )
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15,),
                    _buttonBack(),
                    _buttonCall(),
                    _buttonOrder(),
                  ],
                )
            ),
          ),

          if (_currentDistance.isNotEmpty)
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: theme.colorBackgroundDialog,
                      borderRadius: new BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(40),
                        spreadRadius: 6,
                        blurRadius: 6,
                        offset: Offset(2, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child:
                    Text("${strings.get(46)}: $_currentDistance ${appSettings.distanceUnit}", style: theme.text14bold) // Distance 4 km
                )
            ),
          ),


      ]
        )
    ));
  }

  _map(){
    return GoogleMap(
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false, // Whether to show zoom controls (only applicable for Android).
        myLocationEnabled: true,  // For showing your current location on the map with a blue dot.
        myLocationButtonEnabled: false, // This button is used to bring the user location to the center of the camera view.
        initialCameraPosition: _kGooglePlex,
        polylines: Set<Polyline>.of(_mapPolylines.values),
        onCameraMove:(CameraPosition cameraPosition){
          _currentZoom = cameraPosition.zoom;
        },
        onTap: (LatLng pos) {

        },
        onLongPress: (LatLng pos) {

        },
        markers: markers != null ? Set<Marker>.from(markers) : null,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          if (theme.darkMode)
            _controller.setMapStyle(_mapStyle);
        });
  }

  _buttonPlus(){
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(child: Icon(Icons.add, size: 30, color: Colors.black.withOpacity(0.5),)),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  _controller.animateCamera(
                    CameraUpdate.zoomIn(),
                  );
                }, // needed
              )),
        )
      ],
    );
  }

  _buttonMinus(){
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(child: Icon(Icons.remove, size: 30, color: Colors.black.withOpacity(0.5),)),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  _controller.animateCamera(
                    CameraUpdate.zoomOut(),
                  );
                }, // needed
              )),
        )
      ],
    );
  }

  _buttonCall(){
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(child: Icon(Icons.phone, size: 30, color: Colors.black.withOpacity(0.5),)),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  _callUser();
                }, // needed
              )),
        )
      ],
    );
  }

  _buttonOrder(){
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(child: Icon(Icons.assignment, size: 30, color: Colors.black.withOpacity(0.5),)),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  _onOrderDetails();
                }, // needed
              )),
        )
      ],
    );
  }

  _buttonMyLocation(){
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(child: Icon(Icons.my_location, size: 30, color: Colors.black.withOpacity(0.5),)),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  _getCurrentLocation();
                }, // needed
              )),
        )
      ],
    );
  }

  _getCurrentLocation() async {
    var position = await location.getCurrent();
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: _currentZoom,
        ),
      ),
    );
  }

  MarkerId _lastMarkerId;

  var _iconHome;
  var _iconDest;

  _addMarker(DriverOrders item){
    print("add marker ${item.id}");
    _lastMarkerId = MarkerId("addr1${item.id}");
    final marker = Marker(
        markerId: _lastMarkerId,
        icon: _iconDest,
        position: LatLng(
            item.address1Latitude, item.address1Longitude
        ),
        onTap: () {
        }
    );
    markers.add(marker);
    _lastMarkerId = MarkerId("addr2${item.id}");
    final marker2 = Marker(
        markerId: _lastMarkerId,
        icon: _iconHome,
        position: LatLng(
            item.address2Latitude, item.address2Longitude
        ),
        onTap: () {

        }
    );
    markers.add(marker2);
  }

  _buttonBack(){
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(child: Container(
            margin: EdgeInsets.only(left: 10),
            child: Icon(Icons.arrow_back_ios, size: 30, color: Colors.black.withOpacity(0.5),))),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  _backButtonPress();
                }, // needed
              )),
        )
      ],
    );
  }

  String _getStringParam(String name){
    if (widget.params != null){
      var _ret = widget.params[name];
      if (_ret == null)
        _ret = "";
      return _ret;
    }
    return "";
  }

}