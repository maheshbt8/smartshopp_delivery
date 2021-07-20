
import 'package:delivery_template/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

firebaseGetToken() async {
  dprint ("Firebase messaging: _getToken");

  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      dprint("Firebase messaging:onMessage: $message");
      account.addNotify();
    },
    onLaunch: (Map<String, dynamic> message) async {
      dprint("Firebase messaging:onLaunch: $message");
      account.addNotify();
      //account.addNotify();
    },
    onResume: (Map<String, dynamic> message) async {
      dprint("Firebase messaging:onResume: $message");
      account.addNotify();
      //account.addNotify();
    },
    //onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
  );

  firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false));

  firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    dprint("Firebase messaging: Settings registered: $settings");

  });

  firebaseMessaging.getToken().then((String token) {
    assert(token != null);
    dprint ("Firebase messaging: token=$token");
    account.setFcbToken(token);
  });
}