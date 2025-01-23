import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/notification_add.dart';
import 'pages/register.dart';
import 'pages/task.dart';
import 'pages/logo.dart';
import 'pages/launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'pages/notification_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelGroupKey: "channelGroupKey",
        channelKey: "channelKey",
        channelName: "channelName",
        channelDescription: "channelDescription"),
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: "channelGroupKey", channelGroupName: "Basic Group")
  ]);

  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HomeAlert app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/login': (context) => Login(),
        '/notification_add': (context) => AddItemPage(username: "", email: ""),
        '/signup': (context) => SignUp(),
        '/task': (context) => MainHome(username: "", email: ""),
        '/launcher': (context) => Launcher(email: ""),
      },
    );
  }
}
