import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

int createUniqueId(int maxValue) {
  Random random = Random();
  return random.nextInt(maxValue);
}

class LocalNotification {
  static Future<void> createBasicNotificationWithPayload() async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'This is a basic Channel',
        body: 'Press on the notification on it on temp screen',
        payload: {
          "screen_name": "TEMP_SCREEN",
        },
      ),
    );
  }

  static scheduleNotification() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: 'Simple Notification',
          body: 'Simple Button',
          bigPicture:
              'https://images.unsplash.com/photo-1697807713049-d171c4dd9d5e?auto=format&fit=crop&q=80&w=1470&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          notificationLayout: NotificationLayout.BigPicture,
        ),

        /// will be getting the notification after every minute
        schedule: NotificationCalendar(
          weekday: 1, //// means monday
          hour: 23, ////// means 11 pm
          minute: 0,
          second: 0,
          repeats: true,
        )
        /////// will be getting notiifcation after 1 minute
        // schedule: NotificationCalendar.fromDate(
        //   date: DateTime.now().add(const Duration(minutes: 1)),
        //   preciseAlarm: true,
        //   allowWhileIdle: true,
        //   repeats: true,
        // )
        );
  }

  static cancelScheduleNotification(int id) async {
    await AwesomeNotifications().cancelSchedule(id);
  }

  static triggerNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Simple Notification',
        body: 'Simple Button',
        bigPicture:
            'https://images.unsplash.com/photo-1697484452652-6ac6e917ecc8?auto=format&fit=crop&q=80&w=1486&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        notificationLayout: NotificationLayout.BigPicture,
      ),
    );
  }

  /////////// Action Buttons ////////////
  static Future<void> showNotificationWithActionButton(int id) async {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'basic_channel',
          title: 'Anonymus',
          body: 'Hi there!!',
        ),
        actionButtons: [
          // NotificationActionButton(
          //   key: 'READ', label: 'Reply', autoDismissible: true,
          //   requireInputText: true, //// input field to type something
          // ),
          NotificationActionButton(
            key: 'SUBSCRIBE',
            label: 'Subscribe',
            autoDismissible: true,
          ),
          NotificationActionButton(
            key: 'DISMISS',
            label: 'Dismiss',
            actionType: ActionType.Default,
            autoDismissible: true,
            // enabled: false,
            color: Colors.greenAccent,
            isDangerousOption: true,
          ),
        ]);
  }

  ////////////// Chat notifications //////////////////
  static Future<void> createMessagingNotification({
    required String channelKey,
    required String groupKey,
    required String chatName,
    required String userName,
    required String message,
    String? largeIcon,
  }) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(AwesomeNotifications.maxID),
          channelKey: channelKey,
          groupKey: groupKey,
          summary: chatName,
          title: userName,
          body: message,
          largeIcon: largeIcon,
          notificationLayout: NotificationLayout.MessagingGroup,
          category: NotificationCategory.Message,
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'REPLY',
            label: 'Reply',
            requireInputText: true,
            autoDismissible: false,
          ),
          NotificationActionButton(
            key: 'READ',
            label: 'Mark As Read',
            autoDismissible: true,
          ),
        ]);
  }

  ////////////// Continuous Progress bar notifications //////////////////
  static Future<void> showIndeterminateProgressNotification(int id) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: 'Downloading fake file...',
        body: 'filename.txt',
        payload: {
          'file': 'filename.txt',
        },
        notificationLayout: NotificationLayout.ProgressBar,
        category: NotificationCategory.Progress,
        progress: null,
        locked: true,
      ),
    );

    await Future.delayed(const Duration(seconds: 5));

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: id,
      channelKey: 'basic_channel',
      title: 'Downloading finished',
      body: 'filename.txt',
      category: NotificationCategory.Progress,
      locked: false,
    ));
  }

  ////////////// Downloading Progress bar notifications //////////////////
  static int currentStep = 0;
  static Future<void> showProgressNotification(int id) async {
    int maxStep = 10;

    for (var simulatedStep = 1; simulatedStep <= maxStep + 1; simulatedStep++) {
      currentStep = simulatedStep;
      await Future.delayed(const Duration(seconds: 1));

      _updateCurrentProgressBar(
          id: id, simulatedStep: currentStep, maxStep: maxStep);
    }
  }

/////////// tracking the download //////////
  static void _updateCurrentProgressBar(
      {required id, required int simulatedStep, required maxStep}) {
    if (simulatedStep > maxStep) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: 'Downloading finished',
        body: 'filename.txt',
        category: NotificationCategory.Progress,
        payload: {
          'file': 'filename.txt',
        },
        locked: false,
      ));
    } else {
      int progress = min((simulatedStep / maxStep * 100).round(), 100);

      AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: 'Downloading file in progress ($progress%)',
        body: 'filename.txt',
        category: NotificationCategory.Progress,
        payload: {
          'file': 'filename.txt',
        },
        notificationLayout: NotificationLayout.ProgressBar,
        progress: progress,
        locked: true,
      ));
    }
  }

  /////////// Creating an emoji notification /////////////
  static Future<void> showEmojiNotification(int id) async {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: id,
      channelKey: 'basic_channel',
      title: "Emoji's are awesome 🤣❤🎶😢🤦‍♂️💖",
      body: "simple body with a bunch of emoji's",
      category: NotificationCategory.Social,
    ));
  }

  /////////// Wake Up notification /////////////
  static Future<void> wakeUpNotification(int id) async {
    await Future.delayed(const Duration(seconds: 5));
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: id,
      channelKey: 'basic_channel',
      title: "Hey wake up",
      body: "Wake up please",
      wakeUpScreen: true,
    ));
  }
}
