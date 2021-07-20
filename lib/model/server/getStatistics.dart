import 'package:delivery_template/config/api.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/model/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

getStatistics(String uid, Function(List<DataStatistics>, String) callback, Function(String) callbackError) async {

  try {
    var url = "${serverPath}getStatistics";
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $uid',
    }).timeout(const Duration(seconds: 30));

    dprint("api/getStatistics");
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      Response ret = Response.fromJson(jsonResult);
      callback(ret.data, ret.currencies);
    } else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

class Response {
  String error;
  String currencies;
  List<DataStatistics> data;
  Response({this.error, this.data, this.currencies});
  factory Response.fromJson(Map<String, dynamic> json){
    var m;
    if (json['data'] != null) {
      var items = json['data'];
      var t = items.map((f)=> DataStatistics.fromJson(f)).toList();
      m = t.cast<DataStatistics>().toList();
    }
    return Response(
      error: json['error'],
      currencies: json['currencies'],
      data: m,
    );
  }
}

class DataStatistics {
  double fee;
  double total;
  String percent;
  String updatedAt;

  DataStatistics({this.fee, this.total, this.percent, this.updatedAt});
  factory DataStatistics.fromJson(Map<String, dynamic> json) {
    return DataStatistics(
      updatedAt : json['updated_at'].toString(),
      fee : toDouble(json['fee'].toString()),
      total : toDouble(json['total'].toString()),
      percent : json['percent'].toString(),
    );
  }
}
