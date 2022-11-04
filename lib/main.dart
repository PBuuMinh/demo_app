import 'package:demo_app/appauth_demo/appauth_demo.dart';
import 'package:demo_app/constants/routes.dart';
import 'package:demo_app/firebase_options.dart';
import 'package:demo_app/hive_demo/hive_demo.dart';
import 'package:demo_app/hive_demo/models/movie_model.dart';
import 'package:demo_app/views/animated_container_demo_view.dart';
import 'package:demo_app/views/animated_opacity_demo_view.dart';
import 'package:demo_app/views/homepage_view.dart';
import 'package:demo_app/views/layout_demo_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:hive_flutter/hive_flutter.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  devtools.log("Handling a background message: ${message.messageId}");
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        animatedOpacityDemoRoute: (context) => const FadeInDemo(),
        layoutDemoRoute: (context) => const LayoutDemo(),
        animatedContainerDemoRoute: (context) => const AnimatedContainerDemo(),
        appAuthDemoRoute: (context) => const AppAuthDemo(),
        hiveDemoRoute: (context) => const MyMovieList(),
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// -----------------------------------
  ///           FCM Demo
  /// -----------------------------------
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final fcmToken = await FirebaseMessaging.instance.getToken();
  devtools.log(fcmToken.toString());

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    devtools.log('Got a message whilst in the foreground!');
    devtools.log('Message data: ${message.data}');

    if (message.notification != null) {
      devtools.log(
          'Message also contained a notification: ${message.notification}');
    }
  });

  devtools.log('User granted permission: ${settings.authorizationStatus}');

  /// -----------------------------------
  ///           Hive Demo
  /// -----------------------------------
  await Hive.initFlutter();
  Hive.registerAdapter(MovieAdapter());
  await Hive.openBox<Movie>('my_movie_list');

  runApp(
    const MyApp(),
  );
}
