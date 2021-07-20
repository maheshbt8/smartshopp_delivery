import 'dart:io';

import 'package:delivery_template/model/location.dart';
import 'package:delivery_template/model/notification.dart';
import 'package:delivery_template/ui/main/statistics.dart';
import 'package:delivery_template/ui/widgets/easyDialog2.dart';
import 'package:delivery_template/ui/widgets/ibutton3.dart';
import 'package:flutter/material.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/ui/main/account.dart';
import 'package:delivery_template/ui/main/header.dart';
import 'package:delivery_template/ui/main/map.dart';
import 'package:delivery_template/ui/main/notification.dart';
import 'package:delivery_template/ui/main/orders.dart';
import 'package:delivery_template/ui/menu/help.dart';
import 'package:delivery_template/ui/menu/language.dart';
import 'package:delivery_template/ui/main/orderdetails.dart';
import 'package:delivery_template/ui/menu/menu.dart';
import 'package:flutter/services.dart';

LocationMonitor locationMonitor = LocationMonitor();

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //

  _openMenu(){
    print("Open menu");
    setState(() {
      _scaffoldKey.currentState.openDrawer();
    });
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _currentPage = "orders";
  Map<String, dynamic> _params = {};

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () async {
      await firebaseGetToken();
    });
    account.addCallback(this.hashCode.toString(), callback);
    account.addCallbackNotify(callbackNotify);
    _initGeolocating();
    super.initState();
  }

  // 2
  bool _ask = false;
  _initGeolocating() async{
    if (!await locationMonitor.checkPermissions()) {
      if (!_ask) {
        _ask = true;
        return _openDialog();
      }
    }
    // if (!await locationMonitor.requestPermission())
    //   return _openDialog();
    locationMonitor.init();
  }

  NotificationScreen notifyScreen;
  OrdersScreen ordersScreen;

  callbackNotify(){
    if (_currentPage == "notification")
      notifyScreen.refresh();
    if (_currentPage == "orders")
      ordersScreen.refresh();
  }

  callback(bool){
    setState(() {
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;

    var _headerText = strings.get(21); //
    switch(_currentPage){
      case "statistics":
        _headerText = strings.get(79); // "Statistics",
      break;
      case "orderDetails":
        _headerText = strings.get(56); // "Order Details",
      break;
      case "map":
        _headerText = strings.get(89); // "Map",
      break;
      case "language":
        _headerText = strings.get(28); // "Languages",
        break;
      case "account":
        _headerText = strings.get(27); // "Account",
        break;
      case "help":
        _headerText = strings.get(38); // "Help & support",
        break;
      case "notification":
        _headerText = strings.get(25); // "Notifications",
        break;
      case "orders":
        _headerText = strings.get(24); // "Orders",
        break;
    }

    return WillPopScope(
        onWillPop: () async {
      if (_currentPage == "statistics" || _currentPage == "orderDetails" || _currentPage == "map"
          || _currentPage == "language" || _currentPage == "account" || _currentPage == "help"
          || _currentPage == "notification") {
        _currentPage = "orders";
        setState(() {});
        return false;
      }
      _openDialogExit();
      return false;
    },
    child: Scaffold(
      key: _scaffoldKey,
      drawer: Menu(context: context, callback: routes,),
      backgroundColor: theme.colorBackground,
      body: Directionality(
      textDirection: strings.direction,
      child: Stack(
        children: <Widget>[

          if (_currentPage == "statistics")
            StatisticsScreen(callback: routes),
          if (_currentPage == "orderDetails")
            OrderDetailsScreen(callback: routes),
          if (_currentPage == "map")
            MapScreen(callback: routes, params: _params,),
          if (_currentPage == "language")
            LanguageScreen(callback: routes),
          if (_currentPage == "account")
            AccountScreen(callback: routes),
          if (_currentPage == "help")
            HelpScreen(callback: routes),
          if (_currentPage == "notification")
            notifyScreen = NotificationScreen(callback: routes),
          if (_currentPage == "orders")
            ordersScreen = OrdersScreen(callback: routes2),

          Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Header(title: _headerText, onMenuClick: _openMenu, callback: routes)
          ),

          IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
              body: _dialogBody, backgroundColor: theme.colorBackground),

        ],
      ),
    )));
  }

  routes(String route){
    if (route != "redraw")
      _currentPage = route;
    setState(() {
    });
  }

  routes2(String route, Map<String, dynamic> params){
    _params = params;
    if (route != "redraw")
      _currentPage = route;
    setState(() {
    });
  }

  double _show = 0;
  Widget _dialogBody = Container();

  _openDialog(){
    _dialogBody = Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              child: Text(strings.get(125), textAlign: TextAlign.center, style: theme.text18boldPrimary,) // This program require permission.
          ),
          SizedBox(height: 20,),
          Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: windowWidth/2-45,
                    child: IButton3(
                        color: theme.colorPrimary,
                        text: strings.get(126), // Ok
                        textStyle: theme.text14boldWhite,
                        pressButton: (){
                          setState(() {
                            _show = 0;
                          });
                          _initGeolocating();
                        }
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                      width: windowWidth/2-45,
                      child: IButton3(
                          color: theme.colorPrimary,
                          text: strings.get(66), // Cancel
                          textStyle: theme.text14boldWhite,
                          pressButton: (){
                            setState(() {
                              _show = 0;
                            });
                            // if (Platform.isAndroid) {
                            //   SystemNavigator.pop();
                            // } else if (Platform.isIOS) {
                            //   exit(0);
                            // }
                          }
                      )),
                ],
              )),

        ],
      ),
    );

    setState(() {
      _show = 1;
    });
  }

  _openDialogExit(){
    _dialogBody = Directionality(
        textDirection: strings.direction,
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  child: Text(strings.get(128), textAlign: TextAlign.center, style: theme.text18boldPrimary,) // Do you really want to exit?
              ), // "Reason to Reject",
              SizedBox(height: 20,),
              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: windowWidth/2-45,
                          child: IButton3(
                              color: Colors.redAccent,
                              text: strings.get(127),                  // Exit
                              textStyle: theme.text14boldWhite,
                              pressButton: (){
                                if (Platform.isAndroid) {
                                  SystemNavigator.pop();
                                } else if (Platform.isIOS) {
                                  exit(0);
                                }
                              }
                          )),
                      SizedBox(width: 10,),
                      Container(
                          width: windowWidth/2-45,
                          child: IButton3(
                              color: theme.colorPrimary,
                              text: strings.get(129),              // Back to shop
                              textStyle: theme.text14boldWhite,
                              pressButton: (){
                                setState(() {
                                  _show = 0;
                                });
                              }
                          )),
                    ],
                  )),

            ],
          ),
        ));

    setState(() {
      _show = 1;
    });
  }
}

