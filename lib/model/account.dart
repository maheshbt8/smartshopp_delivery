import 'package:delivery_template/config/api.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/model/pref.dart';
import 'package:delivery_template/model/server/fcbToken.dart';
import 'package:delivery_template/model/server/login.dart';
import 'package:delivery_template/model/server/status.dart';

class Account{

  String _fcbToken;
  String userName = "";
  String userId = "";
  String email = "";
  String phone = "";
  String userAvatar = "";
  String token = "";

  int notifyCount = 0;
  String currentOrder = "";
  String openOrderOnMap = "";
  String backRoute = "";

  bool onLine = true;
  bool initUser = true;

  okUserEnter(String name, String password, String avatar, String _email, String _token, String _phone, int unreadNotify, String _userId){
    initUser = true;
    userName = name;
    userAvatar = avatar;
    if (userAvatar == null)
      userAvatar = serverImgNoUserPath;
    if (userAvatar.isEmpty)
      userAvatar = serverImgNoUserPath;
    email = _email;
    phone = _phone;
    if (phone == null)
      phone = "";
    token = _token;
    userId = _userId;
    notifyCount = unreadNotify;
    pref.set(Pref.userEmail, _email);
    pref.set(Pref.userPassword, password);
    pref.set(Pref.userAvatar, avatar);
    dprint("User Auth! Save email=$email pass=$password");
    _callAll(true);
    getStatus(token, _successGetStatus, (){});
    if (_fcbToken != null)
      addNotificationToken(account.token, _fcbToken);
  }

  _successGetStatus(int active){
    onLine = (active == 1);
  }

  setOnlineStatus(bool status){
    onLine = status;
    var _text = "0";
    if (status)
      _text = "1";
    setStatus(token, _text, (){});
  }

  redraw(){
    _callAll(initUser);
  }

  var callbacks = Map<String, Function(bool)>();

  _callAll(bool value){
    for (var callback in callbacks.values) {
      try {
        callback(value);
      } catch(ex){}
    }
  }

  logOut(){
    initUser = false;
    pref.clearUser();
    userName = "";
    userAvatar = "";
    email = "";
    token = "";
    _callAll(false);
  }

  addCallback(String name, Function(bool) callback){
    callbacks.addAll({name: callback});
  }

  removeCallback(String name){
    callbacks.remove(name);
  }


//  Function _redrawMainWindow;

//  setRedraw(Function callback){
//    _redrawMainWindow = callback;
//  }


  isAuth(Function(bool) callback){
    var email = pref.get(Pref.userEmail);
    var pass = pref.get(Pref.userPassword);
    dprint("Login: email=$email pass=$pass");
    if (email.isNotEmpty && pass.isNotEmpty) {
      login(email, pass, (String name, String password, String avatar, String email, String token, String phone, int unreadNotify, String userId){
        callback(true);
        okUserEnter(name, password, avatar, email, token, phone, unreadNotify, userId);
      }, (String err) {
        callback(false);
      });
    }else
      callback(false);
  }

  setFcbToken(String token){
    _fcbToken = token;
    addNotificationToken(account.token, _fcbToken);
  }

  addNotify(){
    notifyCount++;
    _callAll(true);
    _callbackNotify();
  }

  Function _callbackNotify;

  addCallbackNotify(Function callback){
    _callbackNotify = callback;
  }

}
