import 'package:delivery_template/model/server/getOrders.dart';

import '../main.dart';

double toDouble(String str){
  double ret = 0;
  try {
    ret = double.parse(str);
  }catch(_){}
  return ret;
}

int toInt(String str){
  int ret = 0;
  try {
    ret = int.parse(str);
  }catch(_){}
  return ret;
}

bool toBool(String str){
  return  (str == "true") ? true : false;
}

driverFee(DriverOrders _data){
  double fee = _data.fee;
  if (_data.percent == '1')
    fee = fee/100*_data.summa;
  return (appSettings.rightSymbol == "false") ? "${_data.currency}${fee.toStringAsFixed(appSettings.symbolDigits)}" :
  "${fee.toStringAsFixed(appSettings.symbolDigits)}${_data.currency}";
}