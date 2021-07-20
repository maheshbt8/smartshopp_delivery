import 'package:delivery_template/model/server/changeProfile.dart';
import 'package:delivery_template/model/server/register.dart';
import 'package:delivery_template/ui/widgets/colorloader2.dart';
import 'package:delivery_template/ui/widgets/easyDialog2.dart';
import 'package:delivery_template/ui/widgets/iVerifySMS.dart';
import 'package:delivery_template/ui/widgets/iappBar.dart';
import 'package:delivery_template/ui/widgets/ibackground4.dart';
import 'package:delivery_template/ui/widgets/ibutton3.dart';
import 'package:delivery_template/ui/widgets/iinputField2a.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class OTPScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;

  const OTPScreen({Key key, this.email, this.password, this.name}) : super(key: key);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen>
    with SingleTickerProviderStateMixin {

  _onCodeChange(String code){
    if (code.length == 6)
      _signInWithPhoneNumber(code, (bool ret){
        if (ret){
          _waits(true);
          register(widget.email, widget.password,
              widget.name, _okUserEnter, _error);
        }else
          _error(strings.get(116)); // Failed to sign in
      });
  }

  _pressCreateAccountButton(){
    switch (step){
      case 1:
        if (editControllerPhone.text.isEmpty)
          return openDialog(strings.get(117)); // To continue enter your phone number
        _waits(true);
        setState(() {
        });
        _verifyPhoneNumber(editControllerPhone.text, (){
          step = 2;
          _waits(false);
        }, (String str){
          dprint(str); // error
          openDialog(str);
        });
      break;
    }
  }

  String _verificationId;

  Future<void> _verifyPhoneNumber(_phoneText, Function() callbackok, Function(String) callbackError) async {
    String phone = "";
    for (int i = 0; i < _phoneText.length; i++) {
      int c = _phoneText.codeUnitAt(i);
      if ((c == "1".codeUnitAt(0)) || (c == "2".codeUnitAt(0)) || (c == "3".codeUnitAt(0)) ||
          (c == "4".codeUnitAt(0)) || (c == "5".codeUnitAt(0)) || (c == "6".codeUnitAt(0)) ||
          (c == "7".codeUnitAt(0)) || (c == "8".codeUnitAt(0)) || (c == "9".codeUnitAt(0)) ||
          (c == "0".codeUnitAt(0)) || (c == "+".codeUnitAt(0))) {
        String h = String.fromCharCode(c);
        phone = "$phone$h";
      }
    }
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      callbackok();
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      setState(() {
        callbackError('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      });
    };
    PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      callbackok();
    };
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: const Duration(seconds: 30),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      callbackError(strings.get(118)); // Failed to Verify Phone Number
    }
  }

  Future<void> _signInWithPhoneNumber(String code, Function(bool) callback) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: code,
      );
      final User _ = (await _auth.signInWithCredential(credential)).user;

      callback(true);
      // 'Successfully signed in UID: ${user.uid}'
    } catch (e) {
      print(e);
      callback(false);
    }
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  final editControllerPhone = TextEditingController();
  ScrollController _scrollController = ScrollController();

  _okUserEnter(String name, String password, String avatar, String email, String token, String typeReg){
    _waits(false);
    account.okUserEnter(name, password, avatar, email, token, editControllerPhone.text, 0, typeReg);
    changeProfile(token, name, email, editControllerPhone.text, (){}, (String _){});
    Navigator.pushNamedAndRemoveUntil(context, "/main", (r) => false);
  }

  bool _wait = false;

  _waits(bool value){
    _wait = value;
    if (mounted)
      setState(() {
      });
  }

  _error(String error){
    _waits(false);
    if (error == "login_canceled")
      return;
    if (error == "3")
      return openDialog(strings.get(119)); // This email is busy
    openDialog("${strings.get(101)} $error"); // "Something went wrong. ",
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    editControllerPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent,);
    });
    return WillPopScope(
        onWillPop: () async {
      if (_show != 0){
        setState(() {
          _show = 0;
        });
        return false;
      }
      return true;
    },
    child: Scaffold(
      backgroundColor: theme.colorBackground,

      body: Directionality(
        textDirection: strings.direction,
        child: Stack(
        children: <Widget>[

          IBackground4(width: windowWidth, colorsGradient: theme.colorsGradient),

          Container(
            alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              width: windowWidth,
              child: ListView(
                shrinkWrap: true,
                controller: _scrollController,
                children: _body(),
           )),

          if (_wait)
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
              ),

          IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: theme.colorGrey,
            body: _dialogBody, backgroundColor: theme.colorBackground,),

          IAppBar(context: context, text: "", color: Colors.white),

        ],
      ),
    )));
  }

  var step = 1;

  _body(){
    List<Widget> list = [];

    list.add(Container(
      width: windowWidth*0.4,
      height: windowWidth*0.4,
      child: Image.asset("assets/logo.png", fit: BoxFit.contain),
    ));

    list.add(SizedBox(height: windowHeight*0.05,));

    if (step == 1){
      list.add(Container(
          width: windowWidth,
          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Text(strings.get(120),                        // "Verify phone number"
            style: theme.text20boldWhite, textAlign: TextAlign.start,
          ),
        ));
      list.add(SizedBox(height: 15,));
      list.add(Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),
        ));
      list.add(Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child:
            IInputField2a(
              hint: strings.get(121),            // Phone number
              icon: Icons.account_circle,
              colorDefaultText: Colors.white,
              controller: editControllerPhone,
                type: TextInputType.phone
            )
        ));
      list.add(SizedBox(height: 5,));
      list.add(Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 0.5,
          color: Colors.white.withAlpha(200),               // line
        ));

      list.add(SizedBox(height: 20,));
      list.add(Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: IButton3(
                color: theme.colorCompanion, text: strings.get(122), textStyle: theme.text14boldWhite,  // CONTINUE
                pressButton: (){
                  _pressCreateAccountButton();
      })));
    }
    if (step == 2){
      list.add(Container(
        width: windowWidth,
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Text("${strings.get(124)} ${editControllerPhone.text} ${strings.get(123)}",   // On phone number send SMS with code. Enter code
          style: theme.text20boldWhite, textAlign: TextAlign.start,
        ),
      ));
      list.add(SizedBox(height: 15,));
      list.add(Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: IVerifySMS(color: Colors.white,
          callback: _onCodeChange),
      ),);
    }
    list.add(SizedBox(height: 30,));

    return list;
  }

  double _show = 0;
  Widget _dialogBody = Container();

  openDialog(String _text) {
    _waits(false);
    _dialogBody = Column(
      children: [
        Text(_text, style: theme.text14,),
        SizedBox(height: 40,),
        IButton3(
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
}