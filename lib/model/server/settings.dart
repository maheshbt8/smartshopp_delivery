import 'package:delivery_template/config/api.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/model/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

settings(Function(AppSettings) callback, Function(String) callbackError) async {

  try {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': "application/json",
    };

    var body = json.encoder.convert({
    });

    var url = "${serverPath}settings";
    var response = await http.post(url, headers: requestHeaders, body: body).timeout(const Duration(seconds: 30));

    dprint(url);
    dprint('Response status: ${response.statusCode}');
    dprint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResult = json.decode(response.body);
      if (jsonResult["error"] == "0") {
        AppSettings ret = AppSettings.fromJson(jsonResult);
        callback(ret);
      }else
        callbackError(jsonResult["error"]);
    }else
      callbackError("statusCode=${response.statusCode}");
  } catch (ex) {
    callbackError(ex.toString());
  }
}

class AppSettings {
  int appLanguage;
  String googleApi;
  String distanceUnit;
  String otp;
  String rightSymbol;
  int symbolDigits;
  AppSettings({this.appLanguage, this.googleApi, this.distanceUnit, this.otp = "true", this.rightSymbol = "false", this.symbolDigits = 2});
  factory AppSettings.fromJson(Map<String, dynamic> json){
    return AppSettings(
      appLanguage: toInt(json['appLanguage'].toString()),
      googleApi: json['key'],
      distanceUnit: json['distanceUnit'],
      otp : (json['otp'] == null) ? "false" : json['otp'],
      rightSymbol : json['rightSymbol'].toString(),
      symbolDigits : toInt(json['symbolDigits'].toString()),
    );
  }
}

