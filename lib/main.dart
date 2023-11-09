import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notifications/firebase_options.dart';
import 'package:flutter_notifications/services/local_notifications.dart';
import 'package:flutter_notifications/services/notification_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationController.initializeLocalNotification(debug: true);
  await NotificationController.initializeRemoteNotification(debug: true);
  await NotificationController.initializeNotificationEventListeners();
  scheduleMicrotask(() async {
    await NotificationController.getInitialNotificationAction();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Notifications'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    NotificationController.initializeNotificationEventListeners();
    NotificationController.requestFirebaseToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        shape: const CircularAppBarShape(),
        title: const Text("Local Notifications"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Center(
                  child: ElevatedButton(
                onPressed: () => LocalNotification.showEmojiNotification(3),
                child: const Text('Emoji Notification'),
              )),
              Center(
                  child: ElevatedButton(
                onPressed: () => LocalNotification.wakeUpNotification(4),
                child: const Text('Wake Up lock screen Notification'),
              )),
            ],
          ),
          Column(
            children: [
              Center(
                  child: ElevatedButton(
                onPressed: () =>
                    LocalNotification.showIndeterminateProgressNotification(19),
                child: const Text('ProgressBar Notification'),
              )),
              Center(
                  child: ElevatedButton(
                onPressed: () => LocalNotification.showProgressNotification(2),
                child: const Text('Downloading File Notification'),
              )),
            ],
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => LocalNotification.createMessagingNotification(
                channelKey: 'chats',
                groupKey: 'Emma_group',
                chatName: 'Emma Group',
                userName: 'Emma',
                message: 'Emma has sent a message',
                largeIcon: 'asset://assets/profile_photo.jpg',
              ),
              child: const Text("Chat Notification"),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () =>
                  LocalNotification.createBasicNotificationWithPayload(),
              child: const Text("Trigger Notification"),
            ),
          ),
          Center(
              child: ElevatedButton(
            onPressed: () =>
                LocalNotification.showNotificationWithActionButton(10),
            child: const Text("Action Notifications"),
          )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ElevatedButton(
                onPressed: LocalNotification.scheduleNotification,
                child: Text("Schedule Notifications"),
              ),
              ElevatedButton(
                onPressed: () =>
                    LocalNotification.cancelScheduleNotification(10),
                child: const Text("Cancel Schedule Notifications"),
              )
            ],
          ),
          const Center(
              child: ElevatedButton(
            onPressed: LocalNotification.triggerNotification,
            child: Text("Trigger Notifications"),
          )),
        ],
      ),
    );
  }
}

class CircularAppBarShape extends RoundedRectangleBorder {
  // Custom shape for the circular AppBar
  const CircularAppBarShape()
      : super(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        );
}
