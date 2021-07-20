import 'package:delivery_template/model/server/register.dart';
import 'package:delivery_template/ui/widgets/colorloader2.dart';
import 'package:delivery_template/ui/widgets/easyDialog2.dart';
import 'package:delivery_template/ui/widgets/ibutton2.dart';
import 'package:delivery_template/ui/widgets/ibutton3.dart';
import 'package:flutter/material.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/ui/widgets/iappBar.dart';
import 'package:delivery_template/ui/widgets/ibackground4.dart';
import 'package:delivery_template/ui/widgets/iinputField2.dart';
import 'package:delivery_template/ui/widgets/iinputField2Password.dart';

import 'otp.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen>
    with SingleTickerProviderStateMixin {

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  _pressCreateAccountButton(){
    print("User pressed \"CREATE ACCOUNT\" button");
    print("Login: ${editControllerName.text}, E-mail: ${editControllerEmail.text}, "
        "password1: ${editControllerPassword1.text}, password2: ${editControllerPassword2.text}");
    if (editControllerName.text.isEmpty)
      return openDialog(strings.get(103)); // "Enter your Login"
    if (editControllerEmail.text.isEmpty)
      return openDialog(strings.get(104)); // "Enter your E-mail"
    if (!_validateEmail(editControllerEmail.text))
      return openDialog(strings.get(105)); // "You E-mail is incorrect"
    if (editControllerPassword1.text.isEmpty || editControllerPassword2.text.isEmpty)
      return openDialog(strings.get(106)); // "Enter your password"
    if (editControllerPassword1.text != editControllerPassword2.text)
      return openDialog(strings.get(107)); // "Passwords are different.",
    if (appSettings.otp == "true")
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(
            name: editControllerName.text,
            email: editControllerEmail.text,
            password: editControllerPassword1.text,
          ),
        ),
      );
    _waits(true);
    register(editControllerEmail.text, editControllerPassword1.text,
        editControllerName.text, _okUserEnter, _error);
  }

  _okUserEnter(String name, String password, String avatar, String email, String token, String id){
    _waits(false);
    account.okUserEnter(name, password, avatar, email, token, "", 0, id);
    Navigator.pushNamedAndRemoveUntil(context, "/main", (r) => false);
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerName = TextEditingController();
  final editControllerEmail = TextEditingController();
  final editControllerPassword1 = TextEditingController();
  final editControllerPassword2 = TextEditingController();

  bool _wait = false;

  _waits(bool value){
    if (mounted)
      setState(() {
        _wait = value;
      });
    _wait = value;
  }

  _error(String error){
    _waits(false);
    openDialog("${strings.get(101)} $error"); // "Something went wrong. ",
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    editControllerName.dispose();
    editControllerEmail.dispose();
    editControllerPassword1.dispose();
    editControllerPassword2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent,);
    });
    return Scaffold(
      backgroundColor: theme.colorBackground,

      body: Directionality(
        textDirection: strings.direction,
        child: Stack(
        children: <Widget>[

          IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),

          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            width: windowWidth,
            alignment: Alignment.bottomCenter,
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

          IAppBar(context: context, text: "", color: Colors.white),

        ],
      ),
    ));
  }

  ScrollController _scrollController = ScrollController();

  _body(){
    return ListView(
      shrinkWrap: true,
      controller: _scrollController,
      children: <Widget>[

        Container(
              width: windowWidth*0.4,
              height: windowWidth*0.4,
              child: Image.asset("assets/logo.png", fit: BoxFit.contain),
        ),
        SizedBox(height: windowHeight*0.1,),

        Container(
          margin: EdgeInsets.only(left: 15, right: 20),
          child: Text(strings.get(20),                        // "Create an Account!"
              style: theme.text20boldWhite
          ),
        ),
        SizedBox(height: 15,),
        SizedBox(height: 5,),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        SizedBox(height: 5,),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child:
            IInputField2(
              hint: strings.get(21),            // "Login"
              icon: Icons.account_circle,
              colorDefaultText: Colors.white,
              colorBackground: theme.colorBackgroundDialog,
              controller: editControllerName,
            )
        ),
        SizedBox(height: 5,),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        SizedBox(height: 5,),

        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child:
            IInputField2(
              hint: strings.get(18),            // "E-mail address",
              icon: Icons.alternate_email,
              colorDefaultText: Colors.white,
              colorBackground: theme.colorBackgroundDialog,
              type: TextInputType.emailAddress,
              controller: editControllerEmail,
            )
        ),
        SizedBox(height: 5,),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        SizedBox(height: 5,),

        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2Password(
              hint: strings.get(15),            // "Password"
              icon: Icons.vpn_key,
              colorDefaultText: Colors.white,
              colorBackground: theme.colorBackgroundDialog,
              controller: editControllerPassword1,
            )),
        SizedBox(height: 5,),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        SizedBox(height: 5,),

        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: IInputField2Password(
              hint: strings.get(22),            // "Confirm Password"
              icon: Icons.vpn_key,
              colorDefaultText: Colors.white,
              colorBackground: theme.colorBackgroundDialog,
              controller: editControllerPassword2,
            )),
        SizedBox(height: 5,),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),

        SizedBox(height: 20,),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: IButton3(pressButton: _pressCreateAccountButton, text: strings.get(23), // CREATE ACCOUNT
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