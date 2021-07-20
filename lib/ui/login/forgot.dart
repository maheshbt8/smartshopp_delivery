import 'package:delivery_template/model/server/forgot.dart';
import 'package:delivery_template/ui/widgets/colorloader2.dart';
import 'package:delivery_template/ui/widgets/easyDialog2.dart';
import 'package:delivery_template/ui/widgets/ibutton2.dart';
import 'package:delivery_template/ui/widgets/ibutton3.dart';
import 'package:flutter/material.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/ui/widgets/iappBar.dart';
import 'package:delivery_template/ui/widgets/ibackground4.dart';
import 'package:delivery_template/ui/widgets/iinputField2.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen>
    with SingleTickerProviderStateMixin {

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  _pressSendButton(){
    print("User pressed \"SEND\" button");
    print("E-mail: ${editControllerEmail.text}");
    if (editControllerEmail.text.isEmpty)
      return openDialog(strings.get(97)); // "Enter your E-mail"
    if (!_validateEmail(editControllerEmail.text))
      return openDialog(strings.get(98)); // "You E-mail is incorrect"
    _waits(true);
    forgotPassword(editControllerEmail.text, _success, _error) ;
  }

  _success(){
    _waits(false);
    openDialog(strings.get(102)); // "A letter with a new password has been sent to the specified E-mail",
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    editControllerEmail.dispose();
    super.dispose();
  }

  bool _wait = false;

  _error(String error){
    _waits(false);
    if (error == "5000")
      return openDialog(strings.get(99)); //  "User with this Email was not found!",
    if (error == "5001")
      return openDialog(strings.get(100)); //  "Failed to send Email. Please try again later.",
    openDialog("${strings.get(101)} $error"); // "Something went wrong. ",
  }

  _waits(bool value){
    if (mounted)
      setState(() {
        _wait = value;
      });
    _wait = value;
  }


  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: theme.colorBackground,

      body: Directionality(
        textDirection: strings.direction,
        child: Stack(
        children: <Widget>[

           IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),

           IAppBar(context: context, text: "", color: Colors.white),

            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              width: windowWidth,
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
      ),
    ));
  }

  _body(){
    return Column(
      children: <Widget>[

        Expanded(
            child: Container(
              width: windowWidth*0.4,
              height: windowWidth*0.4,
              child: Image.asset("assets/logo.png", fit: BoxFit.contain),
            )
        ),

        Container(
          margin: EdgeInsets.only(left: 15, right: 20),
          child: Text(strings.get(17),                        // "Forgot password"
              style: theme.text20boldWhite
          ),
        ),

        SizedBox(height: 15,),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child:
            IInputField2(
              hint: strings.get(18),            // "E-mail address"
              icon: Icons.alternate_email,
              colorDefaultText: Colors.white,
              controller: editControllerEmail,
            )
        ),
        SizedBox(height: 5,),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        SizedBox(height: 25,),

        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: IButton3(pressButton: _pressSendButton, text: strings.get(19), // SEND
            color: theme.colorCompanion,
            textStyle: theme.text16boldWhite,),
        ),
        SizedBox(height: 25,),
      ],

    );
  }

  double _show = 0;
  Widget _dialogBody = Container();

  openDialog(String _text) {
    _dialogBody = Column(
      children: [
        Text(_text, style: theme.text14,),
        SizedBox(height: 40,),
        IButton2(
            color: theme.colorPrimary,
            text: strings.get(66),              // Cancel
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

  bool _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

}