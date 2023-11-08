import 'package:awesome_notifications/awesome_notifications.dart';
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

class NotificationController extends ChangeNotifier {
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() {
    return _instance;
  }

  NotificationController._internal();

  //// Initialization Method
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

  ///// Event Listener
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

  //////// This method is call when a given cause the app launch
  ////////   Note the app  was terminated
  static Future<void> getInitialNotificationAction() async {
    ReceivedAction? receivedAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);

    if (receivedAction == null) return;

    navigateHelper(receivedAction);
  }
}
