import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:delivery_template/main.dart';
import 'package:delivery_template/ui/widgets/iline.dart';
import 'package:delivery_template/ui/widgets/ilist5.dart';

class Menu extends StatelessWidget {
  @required final BuildContext context;
  final Function(String) callback;
  Menu({this.context, this.callback});

  //////////////////////////////////////////////////////////////////
  //
  //
  //
  _onMenuClickItem(int id){
    print("User click menu item: $id");
    switch(id){
      case 1:
        callback("orders");
        break;
      case 2:
        callback("notification");
        break;
      case 3:
        callback("statistics");
        break;
      case 7:
        callback("help");
        break;
      case 8:
        callback("account");
        break;
      case 9:
        callback("language");
        break;
      case 10:   // dark & light mode
        theme.changeDarkMode();
        callback("redraw");
        break;
      case 11:   // sign out
        account.logOut();
        Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
        break;

    }
  }

  _changeOnlineOffline(bool value){
    print("Online/Offline button change value: $value");
    account.setOnlineStatus(value);
  }

  // _changeNotify(bool value){
  //   print("Notification button change value: $value");
  // }
  //
  //
  //
  //////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: strings.direction,
        child: Drawer(
        child: Container(
          color: theme.colorBackground,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(height: MediaQuery
                  .of(context)
                  .padding
                  .top,),
              Container(
                  height: 100,
                  child: Row(
                    children: <Widget>[
                      UnconstrainedBox(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(1, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: _avatar(),
                          margin: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
                        )
                      ),
                      SizedBox(width: 20,),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(account.userName, style: theme.text18boldPrimary,),
                            Text(account.email, style: theme.text16,),
                          ],
                        ),
                      )
                    ],

                  )
              ),
              ILine(),

              IList5(icon:  UnconstrainedBox(
                  child: Container(
                      height: 25,
                      width: 25,
                      child: Image.asset("assets/online.png",
                        fit: BoxFit.contain, color: theme.colorPrimary,
                      )
                  )),
                text : strings.get(62),                                   // "Online/Offline"
                textStyle: theme.text16bold,
                activeColor: theme.colorPrimary,
                inactiveTrackColor: theme.colorGrey,
                press: _changeOnlineOffline,
                initState: account.onLine,
              ),

              _item(1, strings.get(24), "assets/home.png"), // 'Orders'
              _item(2, strings.get(25), "assets/notifyicon.png"),  // Notifications
              _item(3, strings.get(79), "assets/statistics.png"),  // Statistics
              ILine(),
              _item(7, strings.get(26), "assets/help.png"), // Help & Support
              _item(8, strings.get(27), "assets/account.png"), // "Account",
              _item(9, strings.get(28), "assets/language.png"), // Languages

//              IList5(icon:  UnconstrainedBox(
//                  child: Container(
//                      height: 25,
//                      width: 25,
//                      child: Image.asset("assets/notifyicon.png",
//                          fit: BoxFit.contain, color: theme.colorPrimary,
//                      )
//                  )),
//                text : strings.get(25),                                   // Notifications
//                textStyle: theme.text16bold,
//                activeColor: theme.colorPrimary,
//                inactiveTrackColor: theme.colorGrey,
//                press: _changeNotify,
//              ),

//              ILine(),
//              _darkMode(),
              ILine(),
              _item(11, strings.get(29), "assets/signout.png"), // "Sign Out",

            ],
          ),
        )
    ));
  }

  _avatar(){
      return Container(
        width: 55,
        height: 55,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(55),
          child: Container(
            child: CachedNetworkImage(
              placeholder: (context, url) =>
                  CircularProgressIndicator(backgroundColor: theme.colorPrimary,),
              imageUrl: account.userAvatar,
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
        ),
      );
  }

//  _darkMode(){
//    if (theme.darkMode)
//      return _item(10, "Light colors", "assets/brands.png");
//    return _item(10, "Dark colors", "assets/brands.png");
//  }

  _item(int id, String name, String imageAsset){
    return Stack(
      children: <Widget>[
        ListTile(
          title: Text(name, style: theme.text16bold,),
          leading:  UnconstrainedBox(
              child: Container(
                  height: 25,
                  width: 25,
                  child: Image.asset(imageAsset,
                      fit: BoxFit.contain,
                      color: theme.colorPrimary,
                  )

              )),
        ),
        Positioned.fill(
          child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: () {
                  Navigator.pop(context);
                  _onMenuClickItem(id);
                }, // needed
              )),
        )
      ],
    );
  }

}