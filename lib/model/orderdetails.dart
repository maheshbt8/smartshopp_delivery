import 'package:delivery_template/model/utils.dart';

class OrderDetails {
  String id;
  String date;
  String foodName;
  int count;
  double foodPrice;
  String extras;
  int extrasCount;
  double extrasPrice;
  String image;

  OrderDetails({this.id, this.date, this.foodName, this.count,
    this.foodPrice, this.extras,
    this.extrasCount, this.extrasPrice, this.image,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      id: json['id'].toString(),
      date: json['updated_at'].toString(),
      foodName: json['food'].toString(),
      count: toInt(json['count'].toString()),
      foodPrice: toDouble(json['foodprice'].toString()),
      extras: json['extras'].toString(),
      extrasCount: toInt(json['extrascount'].toString()),
      extrasPrice: toDouble(json['extrasprice'].toString()),
      image: json['image'].toString(),
    );
  }
}