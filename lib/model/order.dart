import 'package:delivery_template/main.dart';
import 'package:delivery_template/model/server/getOrders.dart';

import 'geolocator.dart';

ordersSetTabs() {
  for (var _data in orders) {
    if (_data.status == "1")
      _data.tab = 0;
    if (_data.status == "2")
      _data.tab = 0;
    if (_data.status == "3")
      _data.tab = 0;
    if (_data.status == "4")
      _data.tab = 0;
    if (_data.status == "5")
      _data.tab = 2;
    if (_data.status == "6")
      _data.tab = 2;
    if (isRejected(_data))
      _data.tab = 2;
    if (isActive(_data))
      _data.tab = 1;
    if (isComplete(_data))
      _data.tab = 2;
  }
}

bool isComplete(DriverOrders data){
  for (var item in data.ordertimes)
    if (item.status == 10 && item.driver == account.userId)
      return true;
  return false;
}

bool isRejected(DriverOrders data){
  for (var item in data.ordertimes)
    if (item.status == 8 && item.driver == account.userId)
      return true;
  return false;
}

bool isActive(DriverOrders data){
  for (var item in data.ordertimes)
    if (item.status == 9 && item.driver == account.userId)
      return true;
  return false;
}


ordersSetDistance() async {
  var location = GeoLocation();
  for (var item in orders){
    double distance = await location.distanceBetween(item.address1Latitude, item.address1Longitude,
        item.address2Latitude, item.address2Longitude);
    item.distance = distance.toInt();
  }
}

bool firstRun = true;
List<DriverOrders> orders = [];