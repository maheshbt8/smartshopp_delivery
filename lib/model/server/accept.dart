import 'package:delivery_template/config/api.dart';
import 'package:delivery_template/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

accept(String uid, String id,
    Function() callback, Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    String body = '{"id" : ${json.encode(id)}}';
    var url = "${serverPath}accept";
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint(url);
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 401)
      return callbackError("401");
    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"].toString() == "0") {
        callback();
      }else
        callbackError(jsonResult["error"].toString());
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}
