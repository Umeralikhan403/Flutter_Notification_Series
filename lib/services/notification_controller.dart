import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notifications/main.dart';
import 'package:flutter_notifications/services/local_notifications.dart';
import 'package:flutter_notifications/temp_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

navigateHelper(ReceivedAction receivedAction) {
  if (receivedAction.payload != null &&
      receivedAction.payload!['screen_name'] == "TEMP_SCREEN") {
    MyApp.navigatorKey.currentState!
        .push(MaterialPageRoute(builder: (context) => const TempScreen()));
  }
}

Future<void> _bgMessageHandler(RemoteMessage remoteMessage) async {
  print('Background message ${remoteMessage.toMap()}');
}

class NotificationController extends ChangeNotifier {
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() {
    return _instance;
  }

  NotificationController._internal();

  /////////////// Initialization Local Notification ///////////////////
  static Future<void> initializeLocalNotification({required bool debug}) async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic Notifications',
            channelDescription: 'Notification Channel for basic tests',
            importance: NotificationImportance.Max,
            // defaultPrivacy: NotificationPrivacy.Secret,
            defaultRingtoneType: DefaultRingtoneType.Notification,
            enableVibration: true,
            defaultColor: Colors.redAccent,
            channelShowBadge: true,
            enableLights: true,
            // icon: 'resource://drawable/res_naruto',
            // playSound: true,
            // soundSource: 'resource://raw/naruto_jutsu',
          ),
          ///////////// notification channel for group messages/chats
          NotificationChannel(
            channelGroupKey: "chat_tests",
            channelKey: 'chats',
            channelName: 'Group chats',
            channelDescription: 'Simple example of chat group',
            importance: NotificationImportance.Max,
            enableVibration: true,
            channelShowBadge: true,
          )
        ],
        debug: debug);
  }

//////// This method is call when a given cause the app launch
  ////////   Note the app  was terminated
  static Future<void> getInitialNotificationAction() async {
    ReceivedAction? receivedAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);

    if (receivedAction == null) return;

    navigateHelper(receivedAction);
  }

  /////////////// Initialization Remote Notification ///////////////////
  static Future<void> initializeRemoteNotification(
      {required bool debug}) async {
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_bgMessageHandler);

    FirebaseMessaging.onMessage.listen(NotificationController.onMessageLister);

    FirebaseMessaging.onMessageOpenedApp
        .listen(NotificationController.onMessageOpenedAppListner);
    // await AwesomeNotificationsFcm().initialize(
    //   onFcmTokenHandle: NotificationController.myFCMTokenHandle,
    //   onFcmSilentDataHandle: NotificationController.mySilentDataHandle,
    //   onNativeTokenHandle: NotificationController.myNativeTokenHandle,
    //   licenseKeys: [],
    //   debug: debug,
    // );
  }

  static getFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('fcmToken $fcmToken');
  }

/////////////////
  static onMessageLister(RemoteMessage remoteMessage) {
    print("onMessage received ${remoteMessage.toMap()}");
  }

/////////////////
  static onMessageOpenedAppListner(RemoteMessage remoteMessage) {
    print("onMessageOpenedAppListner received ${remoteMessage.toMap()}");
  }

  ///// Event Listener ///////
  static Future<void> initializeNotificationEventListeners() async {
    await AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissedActionReceivedMethod);
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    bool isSilentAction =
        receivedAction.actionType == ActionType.SilentAction ||
            receivedAction.actionType == ActionType.SilentBackgroundAction;
    debugPrint(
        "${isSilentAction ? 'silent action' : 'action'} notification received");

    print("receivedAction : $receivedAction");

    navigateHelper(receivedAction);
    // if (receivedAction.buttonKeyPressed == "SUBSCRIBE") {
    //   print("Subscribe button is pressed");
    // } else if (receivedAction.buttonKeyPressed == "DISMISS") {
    //   print("Dismiss button is pressed");
    // }

    if (receivedAction.channelKey == 'chats') {
      receivedChatNotificationAction(receivedAction);
    }

    Fluttertoast.showToast(
      msg:
          "${isSilentAction ? 'silent action' : 'action'} notification received",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.blue,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static Future<void> receivedChatNotificationAction(
      ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == "REPLY") {
      await LocalNotification.createMessagingNotification(
          channelKey: 'chats',
          groupKey: receivedAction.groupKey!,
          chatName: receivedAction.summary!,
          userName: 'You',
          message: receivedAction.buttonKeyInput,
          largeIcon:
              'https://images.unsplash.com/photo-1697484452652-6ac6e917ecc8?auto=format&fit=crop&q=80&w=1486&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');
    } else {}
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedAction) async {
    debugPrint("Notification Created");

    Fluttertoast.showToast(
        msg: "Notification Created",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.blue,
        gravity: ToastGravity.BOTTOM);
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedAction) async {
    debugPrint("Notification Dislayed");

    Fluttertoast.showToast(
        msg: "Notification Displayed",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.blue,
        gravity: ToastGravity.BOTTOM);
  }

  static Future<void> onDismissedActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint("Notification Dismiss");

    Fluttertoast.showToast(
        msg: "Notification Dismiss",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.blue,
        gravity: ToastGravity.BOTTOM);
  }

  ///////////// Remote notificatiion event listener //////////////

  ///// use this method to execute on background when a silent data arrives
  ///  {// even while terminated}
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    Fluttertoast.showToast(
        msg: "Silent date received",
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16);

    print('SilentData: ${silentData.data}');

    if (silentData.data!['IsLiveScore'] == "true") {
      LocalNotification.createLiveScoreNotification(
        id: 1,
        title: silentData.data!['title']!,
        body: silentData.data!['body']!,
        largeIcon: silentData.data!['largeIcon'],
      );
    }

    if (silentData.createdLifeCycle == NotificationLifeCycle.Foreground) {
      print("ForeGround");
    } else {
      print("Background");
    }
  }

///// use this method to detect when a new fcm token is received
  static Future<void> myFCMTokenHandle(String token) async {
    Fluttertoast.showToast(
        msg: "FCM Token received",
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16);

    print('Firebase token: $token');
  }

///// use this method to detect when a new native token is received
  static Future<void> myNativeTokenHandle(String token) async {
    Fluttertoast.showToast(
        msg: "Native Token received",
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16);

    print('Native token: $token');
  }

//////////// request firebase token //////////////
  static Future<String> requestFirebaseToken() async {
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        AwesomeNotificationsFcm().requestFirebaseAppToken();
      } catch (e) {
        debugPrint('$e');
      }
    } else {
      debugPrint('Firebase is not available for this project');
    }
    return '';
  }

///////////  Subscribe or Unsubscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    await AwesomeNotificationsFcm().subscribeToTopic(topic);
    print('Subscribe to $topic');
  }

  static Future<void> unSubscribeToTopic(String topic) async {
    await AwesomeNotificationsFcm().unsubscribeToTopic(topic);
    print('UbSubscribe to $topic');
  }
}
