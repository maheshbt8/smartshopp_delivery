import 'package:delivery_template/main.dart';
import 'package:delivery_template/model/pref.dart';
import 'package:flutter/material.dart';

import 'language/langArabic.dart';
import 'language/langDeu.dart';
import 'language/langEsp.dart';
import 'language/langFrench.dart';
import 'language/langKorean.dart';
import 'language/langPort.dart';
import 'language/langRus.dart';

class LangData{
  String name;
  String engName;
  String image;
  bool current;
  int id;
  TextDirection direction;
  LangData({this.name, this.engName, this.image, this.current, this.id, this.direction});
}

class Lang {

  static var english = 1;
  static var german = 2;
  static var espanol = 3;
  static var french = 4;
  static var korean = 5;
  static var arabic = 6;
  static var portugal = 7;
  static var rus = 8;

  var direction = TextDirection.ltr;

  List<LangData> langData = [
    LangData(name: "English", engName: "English", image: "assets/usa.png", current: false, id: english, direction: TextDirection.ltr),
    LangData(name: "Deutsh", engName: "German", image: "assets/ger.png", current: false, id: german, direction: TextDirection.ltr),
    LangData(name: "Spana", engName: "Spanish", image: "assets/esp.png", current: false, id: espanol, direction: TextDirection.ltr),
    LangData(name: "Français", engName: "French", image: "assets/fra.png", current: false, id: french, direction: TextDirection.ltr),
    LangData(name: "한국어", engName: "Korean", image: "assets/kor.png", current: false, id: korean, direction: TextDirection.ltr),
    LangData(name: "عربى", engName: "Arabic", image: "assets/arabic.png", current: false, id: arabic, direction: TextDirection.rtl),
    LangData(name: "Português", engName: "Portuguese", image: "assets/portugal.png", current: false, id: portugal, direction: TextDirection.ltr),
    LangData(name: "Русский", engName: "Russian", image: "assets/rus.jpg", current: false, id: rus, direction: TextDirection.ltr),
  ];

  Map<int, String> langEng = {
    10 : "Delivery Boy App",
    11 : "Don't have an account? Create",
    12 : "Forgot password",
    13 : "Let's start with LogIn!",
    14 : "Login",
    15 : "Password",
    16 : "LOGIN",
    17 : "Forgot password",
    18 : "E-mail address",
    19 : "SEND",
    20 : "Create an Account!",
    21 : "Login",
    22 : "Confirm Password",
    23 : "CREATE ACCOUNT",
    24 : "Orders",
    25 : "Notifications",
    26 : "Help & Support",
    27 : "Account",
    28 : "Languages",
    29 : "Sign Out",
    30 : "App Language",
    32 : "User Name",
    33 : "E-mail",
    38 : "Help & support",
    39 : "Not Have Notifications",
    40 : "This is very important information",
    41 : "New",
    42 : "Active",
    43 : "History",
    44 : "Order ID",
    45 : "Date",
    46 : "Distance",
    47 : "On Map",
    48 : "Accept",
    49 : "km",
    50 : "Not Have Orders",
    51 : "Complete",
    52 : "Customer name",
    53 : "Customer phone",
    54 : "Call to Customer",
    55 : "Back to Orders",
    56 : "Order Details",
    57 : "Subtotal",
    58 : "Shopping costs",
    59 : "Taxes",
    60 : "Total",
    61 : "Back to Map",
    62 : "Online/Offline",
    63 : "Phone",
    64 : "Edit profile",
    66 : "Cancel",
    67 : "Enter your User Name",
    68 : "Enter your User E-mail",
    69 : "Enter your User Phone",
    70 : "Change password",
    71 : "Change",
    72 : "Old password",
    73 : "Enter your old password",
    74 : "New password",
    75 : "Enter your new password",
    76 : "Confirm New password",
    77 : "Open Gallery",
    78 : "Open Camera",
    79 : "Statistics",
    83 : "Earning",
    84 : "Rejection",
    85 : "Reason to Reject",
    86 : "Send",
    87 : "Enter Reason",
    88 : "here",
    89 : "Map",
    90 : "Enter Login",
    91 : "Enter Password",
    92 : "Cancel",
    94 : "Login or Password in incorrect",
    95 : "Something went wrong",
    96 : "Need user with role Driver",
    97 : "Enter your E-mail",
    98 : "You E-mail is incorrect",
    99 : "User with this Email was not found!",
    100 : "Failed to send Email. Please try again later.",
    101 : "Something went wrong. ",
    102 : "A letter with a new password has been sent to the specified E-mail",
    103 : "Enter your Login",
    104 : "Enter your E-mail",
    105 : "You E-mail is incorrect",
    106 : "Enter your password",
    107 : "Passwords are different.",
    108 : "Passwords don't equals",
    109 : "Enter New Password",
    110 : "Password change",
    111 : "Old password is incorrect",
    112 : "The password length must be more than 5 chars",
    113 : "User Profile change",
    114 : "Help & support",
    115 : "Last 10 days",
    116 : "Failed to sign in",
    117 : "To continue enter your phone number",
    118 : "Failed to Verify Phone Number",
    119 : "This email is busy",
    120 : "Verify phone number",
    121 : "Phone number",
    122 : "CONTINUE",
    123 : "send SMS with code. Enter code",
    124 : "On phone number",
    // 3
    125 : "Allow program to access this device's location even when the app is closed or not in use. This app collects location data to enable customers can see you location in its apps.",
// This app collects location data to enable [“feature”], [“feature”], & [“feature”] even when the app is closed or not in use.”
    126 : "OK",
    127 : "Exit",
    128 : "Do you really want to exit? We will not be able to track your position. ",
    129 : "Back to shop",
    130 : "Driver fee",

  };

  //
  //
  //
  setLang(int id){
    pref.set(Pref.language, "$id");
    if (id == english) {
      defaultLang = langEng;
      init = true;
    }
    if (id == german) {
      defaultLang = langDeu;
      init = true;
    }
    if (id == espanol) {
      defaultLang = langEsp;
      init = true;
    }
    if (id == french) {
      defaultLang = langFrench;
      init = true;
    }
    if (id == korean) {
      defaultLang = langKorean;
      init = true;
    }
    if (id == arabic) {
      defaultLang = langArabic;
      init = true;
    }
    if (id == portugal){
      defaultLang = langPort;
      init = true;
    }
    if (id == rus){
      defaultLang = langRus;
      init = true;
    }
    for (var lang in langData) {
      lang.current = false;
      if (lang.id == id) {
        lang.current = true;
        direction = lang.direction;
      }
    }
  }

  Map<int, String> defaultLang;
  var init = false;

  String get(int id){
    if (!init) return "";
    var str = defaultLang[id];
    if (str == null)
      str = "";
    return str;
  }

}

