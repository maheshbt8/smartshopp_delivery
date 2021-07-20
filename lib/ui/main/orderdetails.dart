import 'package:delivery_template/config/api.dart';
import 'package:delivery_template/model/utils.dart';
import 'package:delivery_template/ui/widgets/ICard22.dart';
import 'package:delivery_template/ui/widgets/ibackbutton.dart';
import 'package:flutter/material.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/model/order.dart';
import 'package:delivery_template/ui/widgets/ICard23.dart';
import 'package:delivery_template/ui/widgets/ICard24.dart';
import 'package:delivery_template/ui/widgets/ibutton3.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Function(String) callback;
  OrderDetailsScreen({Key key, this.callback}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  ///////////////////////////////////////////////////////////////////////////////
  //
  //

  _onBackPressed(){
    widget.callback(account.backRoute);
  }
  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: MediaQuery.of(context).padding.top+50),
          child: _body(),
        ),
        Container(
          margin: EdgeInsets.only(left: 5, top: 40),
          alignment: Alignment.topLeft,
          child: IBackButton(onBackClick: (){
            _onBackPressed();
          }, color: theme.colorPrimary, iconColor: Colors.white),
        ),


      ],
    );
  }

  _body(){
    return ListView(
      children: _body2(),
    );
  }

  _body2(){
    List<Widget> list = [];

    for (var _data in orders) {
      if (account.currentOrder == _data.id) {
        var distance = "${(_data.distance / 1000).toStringAsFixed(3)} ${appSettings.distanceUnit}"; // km or miles
        if (appSettings.distanceUnit == "mi")
          distance = "${(_data.distance / 1609).toStringAsFixed(3)} ${appSettings.distanceUnit}"; // km or miles
        list.add(
            ICard22(
              color: theme.colorBackgroundDialog,
              colorRoute: theme.colorPrimary,
              id: _data.id,
              text: "${strings.get(44)} #${_data.id}",      // Order ID122
              textStyle: theme.text18boldPrimary,
              text2: "${strings.get(45)}: ${_data.date}",   // Date: 2020-07-08 12:35
              text2Style: theme.text14,
              text3: (appSettings.rightSymbol == "false") ? "${_data.currency}${_data.summa.toStringAsFixed(appSettings.symbolDigits)}" :
              "${_data.summa.toStringAsFixed(appSettings.symbolDigits)}${_data.currency}",
              text3Style: theme.text18bold,
              text4: _data.method,      // cache on delivery
              text4Style: theme.text14,
              text5: "${strings.get(46)}:",     // Distance
              text5Style: theme.text16,
              text6: distance,
              text6Style: theme.text18boldPrimary,
              text7: _data.address1,
              text7Style: theme.text14,
              text8: _data.address2,
              text8Style: theme.text14,
              //button1Enable: (status == 0 || status == 1),
              button1Enable: false,
              button2Enable: false,
              button1Text: strings.get(47),   // On Map
              button1Style: theme.text14boldWhite,
              //button2Text: (status == 0) ? strings.get(48) : strings.get(51),
              // Accept or Complete
              button2Style: theme.text14boldWhite,
//              callbackButton1: _onAcceptClick,
//              callbackButton2: _onMapClick
              text9: "${strings.get(130)}:",     // Driver fee
              text9Style: theme.text16,
              text10: driverFee(_data),
              text10Style: theme.text18boldPrimary,
            ));

        list.add(
            ICard23(
              text: "${strings.get(52)}:", // Customer name
              textStyle: theme.text14,
              text2: "${strings.get(53)}:", // "Customer phone",
              text2Style: theme.text14,
              text3: "${_data.customerName}",
              text3Style: theme.text16bold,
              text4: _data.phone,
              text4Style: theme.text16bold,
            ));

        list.add(SizedBox(height: 10,));

        list.add(Container(
          alignment: Alignment.center,
          child: IButton3(
              color: theme.colorPrimary,
              text: strings.get(54), // "Call to Customer",
              textStyle: theme.text14boldWhite,
              pressButton: _onCallToCustomer
          ),
        ));

        list.add(SizedBox(height: 10,));

        List<ICard24Data> _dataDetails = [];
        for (var _details in _data.orderDetails) {
          if (_details.count != 0)
            _dataDetails.add(
                ICard24Data(_data.currency, "$serverImages${_details.image}", _details.foodName,
                    _details.count, _details.foodPrice)
            );
          else
          if (_details.extrasCount != 0)
              _dataDetails.add(
                  ICard24Data(_data.currency, "$serverImages${_details.image}", _details.extras,
                      _details.extrasCount, _details.extrasPrice)
              );
        }

        var textTotal = (appSettings.rightSymbol == "false") ? "${_data.currency}${_data.total.toStringAsFixed(appSettings.symbolDigits)}" :
            "${_data.total.toStringAsFixed(appSettings.symbolDigits)}${_data.currency}";

        list.add(
            ICard24(
              color: theme.colorBackgroundDialog,
              text: "${strings.get(56)}:", // Order Details
              textStyle: theme.text18boldPrimary,
              text2Style: theme.text16,
              colorProgressBar: theme.colorPrimary,
              data: _dataDetails,
              text3Style: theme.text16,
              text3: "${strings.get(57)}:", // Subtotal
              text4: "${strings.get(58)}:", // Shopping costs
              fee: _data.fee,
              percent: _data.percent,
              text5: "${strings.get(59)}:", // Taxes
              tax: _data.tax,
              text6: "${strings.get(60)}: $textTotal", // Total
              text6Style: theme.text16bold,
            ));

        list.add(SizedBox(height: 10,));

        var _text = strings.get(61); // "Back To Map",
        if (account.backRoute == "orders")
          _text = strings.get(55); // "Back To Orders",

        list.add(Container(
          alignment: Alignment.center,
          child: IButton3(
              color: theme.colorPrimary,
              text: _text,
              textStyle: theme.text14boldWhite,
              pressButton: (){
                widget.callback(account.backRoute);
              }
          ),
        ));

        list.add(SizedBox(height: 100,));

      }
    }
    return list;
  }

  _onCallToCustomer() async {
    for (var item in orders)
      if (item.id == account.currentOrder) {
        var uri = 'tel:${item.phone}';
        if (await canLaunch(uri))
          await launch(uri);
      }
  }


}

