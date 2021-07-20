import 'package:delivery_template/model/server/login.dart';
import 'package:delivery_template/ui/widgets/colorloader2.dart';
import 'package:delivery_template/ui/widgets/easyDialog2.dart';
import 'package:delivery_template/ui/widgets/ibutton2.dart';
import 'package:delivery_template/ui/widgets/ibutton3.dart';
import 'package:flutter/material.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/ui/widgets/ibackground4.dart';
import 'package:delivery_template/ui/widgets/iinputField2.dart';
import 'package:delivery_template/ui/widgets/iinputField2Password.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

  //////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  //
  //
  _pressLoginButton(){
    print("User pressed \"LOGIN\" button");
    print("Login: ${editControllerName.text}, password: ${editControllerPassword.text}");
    if (editControllerName.text.isEmpty)
      return openDialog(strings.get(90)); // "Enter Login",
    if (editControllerPassword.text.isEmpty)
      return openDialog(strings.get(91)); // "Enter Password",
    _waits(true);
    login(editControllerName.text, editControllerPassword.text, _okUserEnter, _error);
  }

  _error(String error){
    _waits(false);
    if (error == "1")
      return openDialog(strings.get(94)); // "Login or Password in incorrect"
    if (error == "2")
      return openDialog(strings.get(96)); // "Need user with role Driver"
    openDialog("${strings.get(95)} $error"); // "Something went wrong. ",
  }

  _pressDontHaveAccountButton(){
    print("User press \"Don't have account\" button");
    Navigator.pushNamed(context, "/createaccount");
  }

  _pressForgotPasswordButton(){
    print("User press \"Forgot password\" button");
    Navigator.pushNamed(context, "/forgot");
  }
  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerName = TextEditingController();
  final editControllerPassword = TextEditingController();
  bool _wait = false;

  _waits(bool value){
    if (mounted)
      setState(() {
        _wait = value;
      });
    _wait = value;
  }

  _okUserEnter(String name, String password, String avatar, String email, String token, String _phone, int i, String id){
    _waits(false);
    account.okUserEnter(name, password, avatar, email, token, _phone, i, id);
    Navigator.pushNamedAndRemoveUntil(context, "/main", (r) => false);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    editControllerName.dispose();
    editControllerPassword.dispose();
    super.dispose();
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

        ],
      ),
    ));
  }

  _body(){
    return ListView(
      shrinkWrap: true,
      children: <Widget>[

        Container(
            width: windowWidth*0.4,
            height: windowWidth*0.4,
            child: Image.asset("assets/logo.png", fit: BoxFit.contain),
        ),
        SizedBox(height: windowHeight*0.1,),

        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Text(strings.get(13),                        // "Let's start with LogIn!"
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
            child: IInputField2(
              hint: strings.get(14),            // "Login"
              icon: Icons.alternate_email,
              colorDefaultText: Colors.white,
              controller: editControllerName,
              type: TextInputType.emailAddress
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
              controller: editControllerPassword,
            )),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ),
        SizedBox(height: 30,),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: IButton3(pressButton: _pressLoginButton, text: strings.get(16), // LOGIN
            color: theme.colorCompanion,
            textStyle: theme.text16boldWhite,),
        ),
        SizedBox(height: 15,),
        InkWell(
            onTap: () {
              _pressDontHaveAccountButton();
            }, // needed
            child:Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
              child: Text(strings.get(11),                    // ""Don't have an account? Create",",
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: theme.text16boldWhite
              ),
            )),
        InkWell(
            onTap: () {
              _pressForgotPasswordButton();
            }, // needed
            child:Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 0),
              child: Text(strings.get(12),                    // "Forgot password",
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: theme.text16boldWhite
              ),
            ))

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
}