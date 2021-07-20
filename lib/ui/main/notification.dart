import 'package:delivery_template/config/api.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/model/server/getNotify.dart';
import 'package:delivery_template/model/server/notifyDelete.dart';
import 'package:delivery_template/ui/widgets/ICard29FileCaching.dart';
import 'package:delivery_template/ui/widgets/colorloader2.dart';
import 'package:delivery_template/ui/widgets/easyDialog2.dart';
import 'package:delivery_template/ui/widgets/ibutton3.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NotificationScreen extends StatefulWidget {
  final Function(String) callback;
  NotificationScreen({Key key, this.callback}) : super(key: key);

  refresh(){
    state.refresh();
  }

  _NotificationScreenState state;
  @override
  _NotificationScreenState createState(){
    state = _NotificationScreenState();
    return state;
  }
}

class _NotificationScreenState extends State<NotificationScreen> {

  ///////////////////////////////////////////////////////////////////////////////
  //
  //
  _dismissItem(String id){
    print("Dismiss item: $id");

    notifyDelete(account.token, id, (){
      Notifications _delete;
      for (var item in _this)
        if (item.id == id)
          _delete = item;

      if (_delete != null) {
        _this.remove(_delete);
        setState(() {
        });
      }
    }, _error);
  }

  _error(String error){
    _waits(false);
    openDialog("${strings.get(101)} $error"); // "Something went wrong. ",
  }

  //
  ///////////////////////////////////////////////////////////////////////////////
  double windowWidth = 0.0;
  double windowHeight = 0.0;
  bool _wait = true;
  List<Notifications> _this;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  Future<Null> _handleRefresh() async{
    getNotify(account.token, _success, _error);
    _refreshIndicatorKey.currentState.deactivate();
  }

  _waits(bool value){
    if (mounted)
      setState(() {
        _wait = value;
      });
    _wait = value;
  }

  refresh(){
    getNotify(account.token, _success, _error);
  }

  @override
  void initState() {
    account.notifyCount = 0;
    account.redraw();
    getNotify(account.token, _success, _error);
    account.addCallback(this.hashCode.toString(), callback);
    account.addCallbackNotify((){
      account.notifyCount = 0;
      account.redraw();
      getNotify(account.token, _success, _error);
    });
    super.initState();
  }

  _success(List<Notifications> _data) {
    _waits(false);
    _this = _data;
    setState(() {
    });
  }

  callback(bool reg){
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
    return WillPopScope(
        onWillPop: () async {
      if (_show != 0) {
        setState(() {
          _show = 0;
        });
        return false;
      }
      widget.callback("orders");
      return false;
    },
    child: RefreshIndicator(
    key: _refreshIndicatorKey,
    onRefresh: _handleRefresh,
    child: Stack(
      children: <Widget>[
        Container(
          width: windowWidth,
          height: windowHeight,
          color: theme.colorBackground,
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+30),
          child: _body(),
        ),

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
    )));
  }

  _body(){
    var size = 0;
    if (_this == null)
      return Container();
    for (var _ in _this)
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
              Text(strings.get(39),    // "Not Have Notifications",
                  overflow: TextOverflow.clip,
                  style: theme.text16bold
              ),
              SizedBox(height: 50,),
            ],
          )

      );
    return ListView(
      children: _body2(),
    );
  }

  _body2(){
    List<Widget> list = [];

    list.add(Container(
      color: theme.colorBackgroundDialog,
      child: ListTile(
        leading: UnconstrainedBox(
            child: Container(
                height: 35,
                width: 35,
                child: Image.asset("assets/notifyicon.png",
                  fit: BoxFit.contain,
                ))),
        title: Text(strings.get(25), style: theme.text20bold,),  // "Notifications",
        subtitle: Text(strings.get(40), style: theme.text14,),  // "This is very important information",
      ),
    ));

    list.add(SizedBox(height: 20,));

    for (var _data in _this) {
      list.add(
          ICard29FileCaching(
              key: UniqueKey(),
              id: _data.id,
              color: theme.colorGrey.withOpacity(0.1),
              title: _data.title,
              titleStyle: theme.text14bold,
              userAvatar: "$serverImages${_data.image}",
              colorProgressBar: theme.colorPrimary,
              text: _data.text,
              textStyle: theme.text14,
              balloonColor: theme.colorPrimary,
              date: _data.date,
              dateStyle: theme.text12grey,
              callback: _dismissItem
          )
      );
    }
    return list;
  }

  double _show = 0;
  Widget _dialogBody = Container();

  openDialog(String _text) {
    _dialogBody = Column(
      children: [
        Text(_text, style: theme.text14,),
        SizedBox(height: 40,),
        IButton3(
            color: theme.colorPrimary,
            text: strings.get(155),              // Cancel
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

