import 'package:delivery_template/main.dart';
import 'package:delivery_template/model/server/faq.dart';
import 'package:delivery_template/ui/widgets/colorloader2.dart';
import 'package:delivery_template/ui/widgets/ibackground4.dart';
import 'package:delivery_template/ui/widgets/icard7.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  final Function(String) callback;
  HelpScreen({Key key, this.callback}) : super(key: key);
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

Faq faq = Faq();
List<Data> _faqList;

class _HelpScreenState extends State<HelpScreen> with TickerProviderStateMixin{

  var windowWidth;
  var windowHeight;

  error(String error){
    _waits(false);
    dprint(error);
  }

  faqLoad(List<Data> _data){
    _faqList = _data;
    _waits(false);
  }

  bool _wait = false;

  _waits(bool value){
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  @override
  void initState() {
    if (_faqList != null)
      faqLoad(_faqList);
    else {
      _waits(true);
      faq.get(faqLoad, error);
    }
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

    return WillPopScope(
        onWillPop: () async {
          widget.callback("orders");
        return false;
    },
    child: Scaffold(
        backgroundColor: theme.colorBackground,

        body: Directionality(
          textDirection: strings.direction,
          child: Stack(
            children: <Widget>[

              Container(
                  width: windowWidth,
                  height: windowHeight*0.2,
                  child: IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient)
              ),

              Container(
                margin: EdgeInsets.only(top: windowHeight*0.2),
                child: ListView(
                  children: _getList(),
                ),
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

            ],
          ),
        )));
  }


  List<Widget> _getList(){
    List<Widget> list = [];

    list.add(Row(
      children: <Widget>[
        SizedBox(width: 20,),
        Icon(Icons.help_outline),
        SizedBox(width: 10,),
        Text(strings.get(114), style: theme.text20bold),   // "Help & support",
      ],
    ));

    list.add(SizedBox(height: 25,));
    if (_faqList != null)
      for (var item in _faqList)
        list.add(_item(item.question, item.answer));

    return list;
  }

  _item(String _title, String _body){
    return ICard7(
      color: theme.colorPrimary,
      title: _title, titleStyle: theme.text14,
      body: _body, bodyStyle: theme.text14,
    );
  }

}
