import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class ICard24Data{
  String image;
  String name;
  String currency;
  int count;
  double price;
  ICard24Data(this.currency, this.image, this.name, this.count, this.price);
}

class ICard24 extends StatefulWidget {
  final Color color;
  final Color colorProgressBar;

  final List<ICard24Data> data;

  final String text;
  final String text2;
  final String text3;
  final String text4;
  final String text5;
  final String text6;

  final TextStyle textStyle;
  final TextStyle text2Style;
  final TextStyle text3Style;
  final TextStyle text6Style;

  final int tax;
  final double fee;
  final String percent;
  
  ICard24({this.color = Colors.white,
    this.text = "", this.text2 = "", this.text3 = "", this.text4 = "", this.text5 = "", this.text6 = "",
    this.textStyle, this.text2Style, this.text3Style, this.text6Style,
    this.data, this.colorProgressBar,
    this.tax, this.fee, this.percent,
  });

  @override
  _ICard24State createState() => _ICard24State();
}

class _ICard24State extends State<ICard24>{

  var _textStyle = TextStyle(fontSize: 16);
  var _text2Style = TextStyle(fontSize: 14);

  var _text3Style = TextStyle(fontSize: 14);
  var _text6Style = TextStyle(fontSize: 14);

  @override
  Widget build(BuildContext context) {

    if (widget.textStyle != null)
      _textStyle = widget.textStyle;
    if (widget.text2Style != null)
      _text2Style = widget.text2Style;
    if (widget.text3Style != null)
      _text3Style = widget.text3Style;
    if (widget.text6Style != null)
      _text6Style = widget.text6Style;

    return InkWell(
        child: Container(
          margin: EdgeInsets.only(left: 5, top: 10, bottom: 10, right: 5),
          decoration: BoxDecoration(
              color: widget.color,
            border: Border.all(color: Colors.black.withOpacity(0.1)),
              borderRadius: new BorderRadius.circular(15),
//              boxShadow: [
//                BoxShadow(
//                  color: Colors.grey.withAlpha(100),
//                  spreadRadius: 2,
//                  blurRadius: 2,
//                  offset: Offset(2, 2), // changes position of shadow
//                ),
//              ]
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _body())

//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: [
//
//
//                  Container(
//                      margin: EdgeInsets.only(right: 12, top: 12),
//                      child: Column(
//                        mainAxisSize: MainAxisSize.max,
//                        crossAxisAlignment: CrossAxisAlignment.end,
//                        children: <Widget>[
//                          Text(widget.text3, style: _text3Style, overflow: TextOverflow.ellipsis,),
//                          SizedBox(height: 10,),
//                          Text(widget.text4, style: _text4Style, overflow: TextOverflow.ellipsis,),
//                        ],
//                      )
//                  ),
//
//                ],),
//
//              SizedBox(height: 10,),

          ),
        );
  }

  _body(){
    List<Widget> list = [];
    double _total = 0;
    String currency = "";

    list.add(Container(
        margin: EdgeInsets.only(left: 12, top: 12, right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.text, style: _textStyle, overflow: TextOverflow.ellipsis,),
//            SizedBox(height: 10,),
//            Text(widget.text2, style: _text2Style, overflow: TextOverflow.ellipsis,),
          ],
        )
    ));

    list.add(SizedBox(height: 10,));

    for (var item in widget.data){
      currency = item.currency;
      _total += (item.price*item.count);

      var text1 = (appSettings.rightSymbol == "false") ? "${item.currency}${item.price.toStringAsFixed(appSettings.symbolDigits)}" :
      "${item.price.toStringAsFixed(appSettings.symbolDigits)}${item.currency}";
      var text2 = (appSettings.rightSymbol == "false") ? "${item.currency}${(item.price*item.count).toStringAsFixed(appSettings.symbolDigits)}" :
      "${(item.price*item.count).toStringAsFixed(appSettings.symbolDigits)}${item.currency}";

      list.add(Container(
        height: 100,
        child: Row(
          children: [
            Container(
                margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child:Container(
                    child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          CircularProgressIndicator(backgroundColor: widget.colorProgressBar,),
                      imageUrl: item.image,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      errorWidget: (context,url,error) => new Icon(Icons.error),
                    ),
                  ),
                )
            ),

            Expanded(
              child: Container(
              margin: EdgeInsets.only(left: 10, top: 10, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(item.name, style: _text2Style,),
                  SizedBox(height: 10,),
                  Text("$text1 х ${item.count} = $text2", style: _text2Style,),
                ],)),
            )

          ],
        ),
      ));
    }

    list.add(SizedBox(height: 20,));

    var ff = widget.fee;
    if (widget.percent == "1")
      ff = widget.fee/100*_total;
    var _fee = (appSettings.rightSymbol == "false") ? "$currency${ff.toStringAsFixed(appSettings.symbolDigits)}" :
        "${ff.toStringAsFixed(appSettings.symbolDigits)}$currency";

    var text3 = (appSettings.rightSymbol == "false") ? "$currency${_total.toStringAsFixed(appSettings.symbolDigits)}" :
    "${_total.toStringAsFixed(appSettings.symbolDigits)}$currency";

    var textTaxes = (appSettings.rightSymbol == "false") ? "$currency${(_total*widget.tax/100).toStringAsFixed(appSettings.symbolDigits)}" :
        "${(_total*widget.tax/100).toStringAsFixed(appSettings.symbolDigits)}$currency";

    list.add(Container(
      width: double.infinity,
        margin: EdgeInsets.only(right: 20, left: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("${widget.text3} $text3", style: _text3Style,),
            SizedBox(height: 10,),
            Text("${widget.text4} $_fee", style: _text3Style,),
            SizedBox(height: 10,),
            Text("${widget.text5} $textTaxes", style: _text3Style,),
            SizedBox(height: 10,),
            Text(widget.text6, style: _text6Style,),
          ],
        )
    )
    );

    list.add(SizedBox(height: 10,));

    return list;
  }

}