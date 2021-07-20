import 'package:delivery_template/config/api.dart';
import 'package:delivery_template/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

sendLocation(String uid, String lat, String lng, String speed) async {

  if (lat.isEmpty || lng.isEmpty)
    return;

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
      'Authorization' : "Bearer $uid",
    };

    var body = json.encoder.convert({
      'lat': lat,
      'lng': lng,
      'speed': speed,
    });

    var url = "${serverPath}sendLocation";
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint(url);
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

  } catch (ex) {
    dprint(ex.toString());
  }
}
