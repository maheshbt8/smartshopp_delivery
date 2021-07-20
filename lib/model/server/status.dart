import 'package:delivery_template/config/api.dart';
import 'package:delivery_template/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils.dart';

setStatus(String uid, String active, Function callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'X-CSRF-TOKEN': uid,
      'Authorization' : "Bearer $uid",
    };

    String body = '{"active": "$active"}';

    dprint('body: $body');
    var url = "${serverPath}setStatus";
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint(url);
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');
    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] != "0")
        callbackError("error=${jsonResult["error"]}");
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());

  }
}

getStatus(String uid, Function(int active) callback, Function callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'X-CSRF-TOKEN': uid,
      'Authorization' : "Bearer $uid",
    };

    String body = '{}';

    dprint('body: $body');
    var url = "${serverPath}getStatus";
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint(url);
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');
    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] != "0")
        callbackError("error=${jsonResult["error"]}");
      else{
        callback(toInt(jsonResult["active"].toString()));
      }
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}
