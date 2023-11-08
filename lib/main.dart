import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_notifications/local_notifications_screen.dart';
import 'package:flutter_notifications/services/notification_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationController.initializeLocalNotification(debug: true);
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const LocalNotificationsScreen()));
                },
                child: const Text('Local Notifications'),
              )),
              const SizedBox(height: 20),
              Center(
                  child: ElevatedButton(
                onPressed: () {},
                child: const Text('Remote Notification'),
              )),
              const SizedBox(height: 20),
              Center(
                  child: ElevatedButton(
                onPressed: () {},
                child: const Text('Media Notification'),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
