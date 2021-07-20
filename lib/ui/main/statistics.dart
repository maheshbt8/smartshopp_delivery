import 'package:delivery_template/main.dart';
import 'package:delivery_template/model/server/getStatistics.dart';
import 'package:delivery_template/ui/widgets/ICard25.dart';
import 'package:delivery_template/ui/widgets/ICard26.dart';
import 'package:delivery_template/ui/widgets/IList1.dart';
import 'package:delivery_template/ui/widgets/colorloader2.dart';
import 'package:delivery_template/ui/widgets/easyDialog2.dart';
import 'package:delivery_template/ui/widgets/ibutton3.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  final Function(String) callback;
  StatisticsScreen({Key key, this.callback}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {

  double windowWidth = 0.0;
  double windowHeight = 0.0;

  List<DataStatistics> _stat;

  @override
  void initState() {
    if (_stat == null)
      _waits(true);
    getStatistics(account.token, _success, _error);
    super.initState();
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
  
  String _currency = "";

  _success(List<DataStatistics> stat, String currency){
    _waits(false);
    _stat = stat;
    try {
      for (var i in _stat)
        i.updatedAt = i.updatedAt.substring(0, 10);
    }catch(_){}
    _currency = currency;
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
    child: Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: MediaQuery.of(context).padding.top+30),
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
          body: _dialogBody, backgroundColor: theme.colorBackground,),
      ],
    ));
  }

  _body(){
    return ListView(
      children: _body2(),
    );
  }

  _body2(){
    List<Widget> list = [];

    if (_stat == null)
      return list;

    List<double> dataEarning = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    var dataIndex = 9;
    List<double> dataOrders = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    String lastDate = "";

    bool need = false;

    var summa = 0.0;
    for (var item in _stat){
      var t;
      if (item.percent == '1')
        t = item.total*item.fee/100;
      else
        t = item.fee;
      summa += t;
      if (item.updatedAt == lastDate){
        dataOrders[dataIndex] ++;
        dataEarning[dataIndex] += t;
      }else {
        if (need){
          need = false;
          dataIndex--;
        }
        if (dataIndex >= 0) {
          dataEarning[dataIndex] += t;
          dataOrders[dataIndex] ++;
          need = true;
          lastDate = item.updatedAt;
        }
      }
    }

    list.add(
        ICard26(
          color: theme.colorBackgroundDialog,
          text: _stat.length.toString(),
          text2: strings.get(24), // "Orders",
//          text3: "78",
//          text4: strings.get(49), // "km",
          text5: (appSettings.rightSymbol == "false") ? "$_currency${summa.toStringAsFixed(appSettings.symbolDigits)}" :
              "${summa.toStringAsFixed(appSettings.symbolDigits)}$_currency",
          //"$_currency${summa.toStringAsFixed(2)}",
          text6: strings.get(83), // "Earning",
          textStyle: theme.text18bold,
          text2Style: theme.text16,
        )
    );

    list.add(SizedBox(height: 10,));

    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: IList1(imageAsset: "assets/earning.png", text: strings.get(83),        // "Earning",
          textStyle: theme.text16bold, imageColor: theme.colorDefaultText),
    ));

    list.add(
        ICard25(
          bottomTexts: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
          bottomTexts2: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
          bottomTextStyle: theme.text14,

          width: windowWidth,
          height: windowWidth * 0.45,

          color: theme.colorPrimary.withOpacity(0.1),
          colorTimeIcon: theme.colorGrey,

          colorAction: theme.colorPrimary,
          actionText: strings.get(115), // "Last 10 days",
          actionText2: strings.get(115), // "Last 10 days",
          action: theme.text12white,

          data: dataEarning,
          data2: dataEarning,
          colorLine: theme.colorPrimary,
          shadowColor: Colors.white,
        )
    );
    list.add(SizedBox(height: 10,));

    list.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: IList1(imageAsset: "assets/statistics.png", text: strings.get(24),        // "Orders",
          textStyle: theme.text16bold, imageColor: theme.colorDefaultText),
    ));

    list.add(
        ICard25(
          bottomTexts: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
          bottomTexts2: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
          bottomTextStyle: theme.text14,

          width: windowWidth,
          height: windowWidth * 0.45,

          color: theme.colorPrimary.withOpacity(0.1),
          colorTimeIcon: theme.colorGrey,

          colorAction: theme.colorPrimary,
          actionText: strings.get(115), // "Last 10 days",
          actionText2: strings.get(115), // "Last 10 days",
          action: theme.text12white,

          data: dataOrders,
          data2: dataOrders,
          colorLine: theme.colorPrimary,
          shadowColor: Colors.white,
        )
    );

    list.add(SizedBox(height: 100,));
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

