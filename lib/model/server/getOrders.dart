import 'package:delivery_template/config/api.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/model/orderdetails.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils.dart';


getOrders(String uid, Function(List<DriverOrders>) callback, Function(String) callbackError) async {

  try {
    var url = "${serverPath}getDriverOrders";
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $uid',
      'Content-type': 'application/json',
      'Accept': "application/json",
      'X-CSRF-TOKEN': uid,
    }).timeout(const Duration(seconds: 30));

    dprint("api/getDriverOrders");
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      Response ret = Response.fromJson(jsonResult);
      // appSettings = ret.settings;
      callback(ret.data);
    } else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}


class Response {
  String error;
  List<DriverOrders> data;
  Response({this.error, this.data});
  factory Response.fromJson(Map<String, dynamic> json){
    var m;
    if (json['data'] != null) {
      var items = json['data'];
      var t = items.map((f)=> DriverOrders.fromJson(f)).toList();
      m = t.cast<DriverOrders>().toList();
    }
    return Response(
      error: json['error'],
      data: m,
    );
  }
}

class DriverOrders {
  String id;
  String date;
  String status;
  String method; // status in text
  double summa;
  String restaurant;
  String name;
  String image;
  String currency;

  //
  String address1;
  String address2;
  double address1Latitude;
  double address1Longitude;
  double address2Latitude;
  double address2Longitude;
  String customerName;
  String phone;
  double fee;
  int tax;
  double total;
  String percent;
  List<OrderDetails> orderDetails;

  List<OrderTimes> ordertimes;
  //
  //
  //
  int distance; // in meters
  int tab = 0;

  DriverOrders({this.id, this.date, this.status, this.summa, this.restaurant, this.name, this.image, this.method,
    this.ordertimes, this.currency, this.distance, this.tab, this.orderDetails,
    this.phone, this.customerName, this.fee, this.tax, this.total, this.percent,
    this.address1, this.address1Longitude, this.address1Latitude,
    this.address2, this.address2Longitude, this.address2Latitude,
  });
  factory DriverOrders.fromJson(Map<String, dynamic> json) {
    var _ordertimes;
    if (json['ordertimes'] != null){
      var items = json['ordertimes'];
      var t = items.map((f)=> OrderTimes.fromJson(f)).toList();
      _ordertimes = t.cast<OrderTimes>().toList();
    }
    var _orderDetails;
    if (json['orderdetails'] != null){
      var items = json['orderdetails'];
      var t = items.map((f)=> OrderDetails.fromJson(f)).toList();
      _orderDetails = t.cast<OrderDetails>().toList();
    }
    //
    return DriverOrders(
        currency : json['currency'].toString(),
        id : json['orderid'].toString(),
        date: json['date'].toString(),
        status: json['status'].toString(),
        method: json['statusName'].toString(),
        summa: toDouble(json['total'].toString()),
        restaurant: json['restaurant'].toString(),
        name: json['name'].toString(),
        image: json['image'].toString(),
        ordertimes: _ordertimes,
        address1: json['address1'].toString(),
        address1Latitude: toDouble(json['address1Latitude'].toString()),
        address1Longitude: toDouble(json['address1Longitude'].toString()),
        address2: json['address2'].toString(),
        address2Latitude: toDouble(json['address2Latitude'].toString()),
        address2Longitude: toDouble(json['address2Longitude'].toString()),
        orderDetails: _orderDetails,
        phone: json['phone'].toString(),
        customerName: json['customerName'].toString(),
        fee: toDouble(json['fee'].toString()),
        tax: toInt(json['tax'].toString()),
        total: toDouble(json['total'].toString()),
        percent: json['percent'].toString(),
      );
    }
}

class OrderTimes {
  String createdAt;
  int status;
  String driver;
  String comment;
  OrderTimes({this.createdAt, this.status, this.driver, this.comment});
  factory OrderTimes.fromJson(Map<String, dynamic> json) {
    return OrderTimes(
      createdAt : json['created_at'].toString(),
      status: toInt(json['status'].toString()),
      driver: json['driver'].toString(),
      comment: json['comment'].toString(),
    );
  }
}
