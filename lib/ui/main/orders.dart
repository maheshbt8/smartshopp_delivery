import 'package:delivery_template/model/server/accept.dart';
import 'package:delivery_template/model/server/complete.dart';
import 'package:delivery_template/model/server/getOrders.dart';
import 'package:delivery_template/model/server/reject.dart';
import 'package:delivery_template/model/utils.dart';
import 'package:delivery_template/ui/widgets/colorloader2.dart';
import 'package:delivery_template/ui/widgets/easyDialog2.dart';
import 'package:delivery_template/ui/widgets/ibutton3.dart';
import 'package:flutter/material.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/model/order.dart';
import 'package:delivery_template/ui/widgets/ICard22.dart';

// ignore: must_be_immutable
class OrdersScreen extends StatefulWidget {
  final Function(String, Map<String, dynamic>) callback;
  final Map<String, dynamic> params;
  OrdersScreen({Key key, this.callback, this.params}) : super(key: key);

  _OrdersScreenState state;

  refresh(){
    state.refresh();
  }

  @override
  _OrdersScreenState createState() {
    state = _OrdersScreenState();
    return state;
  }
}

int _currentTabIndex = 0;

class _OrdersScreenState extends State<OrdersScreen>  with TickerProviderStateMixin{

  ///////////////////////////////////////////////////////////////////////////////
  //
  //
  _onCallback(String id){
    print("User tap on order card with id: $id");
    account.currentOrder = id;
    account.backRoute = "orders";
    widget.callback("orderDetails", {});
  }

  _tabIndexChanged(){
    print("Tab index is changed. New index: ${_tabController.index}");
    setState(() {
    });
    _currentTabIndex = _tabController.index;
  }

  var rejectId = "";
  _onRejectClick(String id) {
    rejectId = id;
    print("User click Reject button with id: $id");
    _openRejectDialog();
  }

  _onAcceptClick(String id){
    print("User click Accept button with id: $id");
    _waits(true);
    accept(account.token, id, _acceptSuccess, _error);
  }

  _onCompleteClick(String id){
    print("User click Complete button with id: $id");
    _waits(true);
    complete(account.token, id, _completeSuccess, _error);
  }

  _completeSuccess(){
    getOrders(account.token, _success, _error);
    _tabController.animateTo(2);
  }

  _acceptSuccess(){
    getOrders(account.token, _success, _error);
    _tabController.animateTo(1);
  }

  _onMapClick(String id){
    print("User click On Map button with id: $id");
    account.openOrderOnMap = id;
    widget.callback("map", {"backRoute" : "orders"});
  }

  _callbackReject(){
    print("User click Send on Reject dialog");
    print("text=${editController.text}");
    _waits(true);
    reject(account.token, editController.text, rejectId, _rejectSuccess, _error);
  }

  _rejectSuccess(){
    getOrders(account.token, _success, _error);
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  TabController _tabController;
  final editController = TextEditingController();
  double _show = 0;
  Widget _dialogBody = Container();

  refresh(){
    getOrders(account.token, _success, _error);
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_tabIndexChanged);
    _tabController.animateTo(_currentTabIndex);
    if (firstRun) {
      firstRun = false;
      _waits(true);
    }
    getOrders(account.token, _success, _error);
    super.initState();
  }

  _success(List<DriverOrders> _orders) async {
    orders = _orders;
    ordersSetTabs();
    await ordersSetDistance();
    _waits(false);
  }

  _error(String error){
    _waits(false);
    openDialog("${strings.get(95)} $error"); // "Something went wrong. ",
  }

  bool _wait = false;

  _waits(bool value){
    if (mounted)
      setState(() {
        _wait = value;
      });
    _wait = value;
  }

  @override
  void dispose() {
    editController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Stack(
        children: <Widget>[

          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+50),
            height: 30,
            child: TabBar(
              indicatorColor: theme.colorPrimary,
              labelColor: Colors.black,
              tabs: [
                Text(strings.get(41),     // "New",
                    textAlign: TextAlign.center,
                    style: theme.text14
                ),
                Text(strings.get(42),     // "Active",
                    textAlign: TextAlign.center,
                    style: theme.text14
                ),
                Text(strings.get(43),     // "History",
                    textAlign: TextAlign.center,
                    style: theme.text14
                ),
              ],
              controller: _tabController,
            ),
          ),

          Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+90),
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[

                  Container(
                    child: _body(0),
                  ),

                  Container(
                    child: _body(1),
                  ),

                  Container(
                    child:_body(2),
                  ),

                ],

              )  ),


          if (_wait)(
              Container(
                color: Color(0x80000000),
                width: windowWidth,
                height: windowHeight,
                child: Center(
                  child: ColorLoader2(
                    color1: theme.colorPrimary,
                    color2: theme.colorCompanion,
                    color3: theme.colorPrimary,
                  ),
                ),
              ))else(Container()),

          IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
            body: _dialogBody, backgroundColor: theme.colorBackground),

        ],
    );
  }

  _body(int status){
    if (firstRun)
      return;
    int size = 0;

    for (var _data in orders)
      if (_data.tab == status)
          size++;

    if (size == 0)
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UnconstrainedBox(
                  child: Container(
                      height: windowHeight/3,
                      width: windowWidth/2,
                      child: Container(
                        child: Image.asset("assets/nonotify.png",
                            fit: BoxFit.contain,
                        ),
                      )
                  )),
              SizedBox(height: 20,),
              Text(strings.get(50),    // "Not Have Orders",
                  overflow: TextOverflow.clip,
                  style: theme.text16bold
                  ),
              SizedBox(height: 50,),
            ],
          )

      );
    return ListView(
      padding: EdgeInsets.only(top: 0, left: 5, right: 5),
      children: _body2(status),
    );
  }

  _body2(int status){
    List<Widget> list = [];

    for (var _data in orders) {
      if (_data.tab == status) { // history
        var dist = (_data.distance != null) ? _data.distance : 0;
        var distance = "${(dist / 1000).toStringAsFixed(3)} ${appSettings.distanceUnit}"; // km or miles
        if (appSettings.distanceUnit == "mi")
          distance = "${(dist / 1609).toStringAsFixed(3)} ${appSettings.distanceUnit}"; // km or miles
        list.add(ICard22(
                color: theme.colorBackgroundDialog,
                colorRoute: theme.colorPrimary,
                id: _data.id,
                text: "${strings.get(44)} #${_data.id}",    // Order ID122
                textStyle: theme.text18boldPrimary,
                text2: "${strings.get(45)}: ${_data.date}",   // Date: 2020-07-08 12:35
                text2Style: theme.text14,
                text3: (appSettings.rightSymbol == "false") ? "${_data.currency}${_data.summa.toStringAsFixed(appSettings.symbolDigits)}" :
                "${_data.summa.toStringAsFixed(appSettings.symbolDigits)}${_data.currency}",
                text3Style: theme.text18bold,
                text4: _data.method,            // cache on delivery
                text4Style: theme.text14,
                text5: "${strings.get(46)}:", // Distance
                text5Style: theme.text16,
                text6: distance,
                text6Style: theme.text18boldPrimary,
                text7: _data.address1,
                text7Style: theme.text14,
                text8: _data.address2,
                text8Style: theme.text14,
                button1Enable: (status == 1 || status == 1),
                button2Enable: true,
                button1Text: strings.get(47),     // On Map
                button1Style: theme.text14boldWhite,
                button2Text: (status == 0) ? strings.get(48) : strings.get(51),     // Accept or Complete
                button2Style: theme.text14boldWhite,
                callbackButton1: (status == 0) ? _onAcceptClick : _onCompleteClick,
                callbackButton2: _onMapClick,
                callback: _onCallback,
                //
                //
                //
                button34Enable: (status == 0),
                button3Text: strings.get(84),     // Rejection
                button3Style: theme.text14boldWhite,
                button3Color: Colors.red,
                callbackButton3: _onRejectClick,
                button4Text: strings.get(48),     // Accept
                button4Style: theme.text14boldWhite,
                button4Color: theme.colorPrimary,
                callbackButton4: _onAcceptClick,
                //
                text9: "${strings.get(130)}: ",     // Driver fee
                text9Style: theme.text16,
                text10: driverFee(_data),
                text10Style: theme.text18boldPrimary,
            ));
      }
    }
    list.add(SizedBox(height: 100));

    return list;
  }

  slideRightBackground(){
    return Container(
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          UnconstrainedBox(
              child: Container(
                  height: 25,
                  width: 25,
                  child: Image.asset("assets/delete.png",
                      fit: BoxFit.contain, color: Colors.white
                  ))),
          SizedBox(width: 20,),
        ],
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 20,),
            UnconstrainedBox(
                child: Container(
                height: 25,
                width: 25,
                child: Image.asset("assets/delete.png",
                fit: BoxFit.contain, color: Colors.white
            )))
          ],
        ),
    );
  }

  _openRejectDialog(){
    _dialogBody = Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Text(strings.get(85), textAlign: TextAlign.center, style: theme.text18boldPrimary,)
          ), // "Reason to Reject",
          SizedBox(height: 20,),
          Text("${strings.get(87)}:", style: theme.text12bold,),  // "Enter Reason",
          _edit(editController, strings.get(88), false),                //  "here",
          SizedBox(height: 30,),
          Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: windowWidth/2-45,
                    child: IButton3(
                        color: theme.colorPrimary,
                        text: strings.get(86), // Send
                        textStyle: theme.text14boldWhite,
                        pressButton: (){
                          setState(() {
                            _show = 0;
                          });
                          _callbackReject();
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

  _edit(TextEditingController _controller, String _hint, bool _obscure){
    return Container(
      height: 30,
      child: TextField(
        controller: _controller,
        onChanged: (String value) async {
        },
        cursorColor: theme.colorDefaultText,
        cursorWidth: 1,
        obscureText: _obscure,
        textAlign: TextAlign.left,
        maxLines: 1,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: _hint,
            hintStyle: theme.text14
        ),
      ),
    );
  }

  openDialog(String _text) {
    _dialogBody = Column(
      children: [
        Text(_text, style: theme.text14,),
        SizedBox(height: 40,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(92),              // Cancel
            textStyle: theme.text14boldWhite,
            pressButton: (){
              setState(() {
                _show = 0;
              });
            }
        ),
      ],
    );

    setState(() {
      _show = 1;
    });
  }
}

