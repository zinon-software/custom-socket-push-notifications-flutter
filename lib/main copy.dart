// // Copyright 2019 The Chromium Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

// import 'dart:async';
// import 'dart:convert';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
// import 'package:socket_push_notifictions/bytx/mainscreen.dart';

// import 'firebase_options.dart';
// import 'message.dart';
// import 'message_list.dart';
// import 'permissions.dart';
// import 'token_monitor.dart';

// /// Working example of FirebaseMessaging.
// /// Please use this in order to verify messages are working in foreground, background & terminated state.
// /// Setup your app following this guide:
// /// https://firebase.google.com/docs/cloud-messaging/flutter/client#platform-specific_setup_and_requirements):
// ///
// /// Once you've completed platform specific requirements, follow these instructions:
// /// 1. Install melos tool by running `flutter pub global activate melos`.
// /// 2. Run `melos bootstrap` in FlutterFire project.
// /// 3. In your terminal, root to ./packages/firebase_messaging/firebase_messaging/example directory.
// /// 4. Run `flutterfire configure` in the example/ directory to setup your app with your Firebase project.
// /// 5. Run the app on an actual device for iOS, android is fine to run on an emulator.
// /// 6. Use the following script to send a message to your device: scripts/send-message.js. To run this script,
// ///    you will need nodejs installed on your computer. Then the following:
// ///     a. Download a service account key (JSON file) from your Firebase console, rename it to "google-services.json" and add to the example/scripts directory.
// ///     b. Ensure your device/emulator is running, and run the FirebaseMessaging example app using `flutter run --no-pub`.
// ///     c. Copy the token that is printed in the console and paste it here: https://github.com/firebase/flutterfire/blob/01b4d357e1/packages/firebase_messaging/firebase_messaging/example/lib/main.dart#L32
// ///     c. From your terminal, root to example/scripts directory & run `npm install`.
// ///     d. Run `npm run send-message` in the example/scripts directory and your app will receive messages in any state; foreground, background, terminated.
// ///  Note: Flutter API documentation for receiving messages: https://firebase.google.com/docs/cloud-messaging/flutter/receive
// ///  Note: If you find your messages have stopped arriving, it is extremely likely they are being throttled by the platform. iOS in particular
// ///  are aggressive with their throttling policy.
// ///
// /// To verify that your messages are being received, you ought to see a notification appearon your device/emulator via the flutter_local_notifications plugin.
// /// Define a top-level named handler which background/terminated messages will
// /// call.
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await setupFlutterNotifications();
//   showFlutterNotification(message);
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   print('Handling a background message ${message.messageId}');
// }

// /// Create a [AndroidNotificationChannel] for heads up notifications
// late AndroidNotificationChannel channel;

// bool isFlutterLocalNotificationsInitialized = false;

// Future<void> setupFlutterNotifications() async {
//   if (isFlutterLocalNotificationsInitialized) {
//     return;
//   }
//   channel = const AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description:
//         'This channel is used for important notifications.', // description
//     importance: Importance.high,
//   );

//   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   /// Create an Android Notification Channel.
//   ///
//   /// We use this channel in the `AndroidManifest.xml` file to override the
//   /// default FCM channel to enable heads up notifications.
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   /// Update the iOS foreground notification presentation options to allow
//   /// heads up notifications.
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   isFlutterLocalNotificationsInitialized = true;
// }

// void showFlutterNotification(RemoteMessage message) {
//   RemoteNotification? notification = message.notification;
//   AndroidNotification? android = message.notification?.android;
//   if (notification != null && android != null && !kIsWeb) {
//     flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channelDescription: channel.description,
//           // TODO add a proper drawable resource to android, for now using
//           //      one that already exists in example app.
//           icon: 'launch_background',
//         ),
//       ),
//     );
//   }
// }

// /// Initialize the [FlutterLocalNotificationsPlugin] package.
// late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   // Set the background messaging handler early on, as a named top-level function
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   if (!kIsWeb) {
//     await setupFlutterNotifications();
//   }

//   runApp(MessagingExampleApp());
// }

// /// Entry point for the example application.
// class MessagingExampleApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Messaging Example App',
//       theme: ThemeData.dark(),
//       // routes: {
//       //   '/': (context) => Application(),
//       //   '/message': (context) => MessageView(),
//       // },
//       home: MainScreen(),
//     );
//   }
// }

// // Crude counter to make messages unique
// int _messageCount = 0;

// /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
// String constructFCMPayload(String? token) {
//   _messageCount++;
//   return jsonEncode({
//     'token': token,
//     'data': {
//       'via': 'FlutterFire Cloud Messaging!!!',
//       'count': _messageCount.toString(),
//     },
//     'notification': {
//       'title': 'Hello FlutterFire!',
//       'body': 'This notification (#$_messageCount) was created via FCM!',
//     },
//   });
// }

// /// Renders the example application.
// class Application extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _Application();
// }

// class _Application extends State<Application> {
//   String? _token;

//   @override
//   void initState() {
//     super.initState();

//     FirebaseMessaging.onMessage.listen(showFlutterNotification);

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//       Navigator.pushNamed(
//         context,
//         '/message',
//         arguments: MessageArguments(message, true),
//       );
//     });
//   }

//   // Future<void> sendPushMessage() async {
//   //   if (_token == null) {
//   //     print('Unable to send FCM message, no token exists.');
//   //     return;
//   //   }

//   //   try {
//   //     var r = await http.post(
//   //       Uri.parse('https://api.rnfirebase.io/messaging/send'),
//   //       headers: <String, String>{
//   //         'Content-Type': 'application/json; charset=UTF-8',
//   //       },
//   //       body: constructFCMPayload(_token),
//   //     );

//   //     print('FCM request for device sent!================================');
//   //     print(r.body);
//   //   } catch (e) {
//   //     print(e);
//   //   }
//   // }

//   void sendPushMessage(String body, String title) async {
//     try {
//       var r = await http.post(
//         Uri.parse('https://fcm.googleapis.com/fcm/send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization':
//               'key=AAAAdK-as-Q:APA91bHO9EdgX4sO8zg7DumbBAM3rVToDEdhOkbTgSiVbUipTo4K2-vZohe2eplzRfBxEg97QgbC7QwgE5Zp8MZ65ht54Nv7m98xP-UHSaDywJCOhB55-EzDmQ5AvIkZnK_IgkEPJ9k5',
//         },
//         body: jsonEncode(
//           <String, dynamic>{
//             'notification': <String, dynamic>{'body': body, 'title': title},
//             'priority': 'high',
//             'data': <String, dynamic>{
//               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//               'id': '1',
//               'status': 'done'
//             },
//             "to": _token,
//           },
//         ),
//       );

//       print(jsonEncode(
//         <String, dynamic>{
//           'notification': <String, dynamic>{'body': body, 'title': title},
//           'priority': 'high',
//           'data': <String, dynamic>{
//             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//             'id': '1',
//             'status': 'done'
//           },
//           "to": _token,
//         },
//       ));

//       print('FCM request for device sent!================================');
//       print(r.body);
//     } catch (e) {
//       print("error push notification");
//     }
//   }

//   Future<void> onActionSelected(String value) async {
//     switch (value) {
//       case 'subscribe':
//         {
//           print(
//             'FlutterFire Messaging Example: Subscribing to topic "fcm_test".',
//           );
//           await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
//           print(
//             'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.',
//           );
//         }
//         break;
//       case 'unsubscribe':
//         {
//           print(
//             'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".',
//           );
//           await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
//           print(
//             'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.',
//           );
//         }
//         break;
//       case 'get_apns_token':
//         {
//           if (defaultTargetPlatform == TargetPlatform.iOS ||
//               defaultTargetPlatform == TargetPlatform.macOS) {
//             print('FlutterFire Messaging Example: Getting APNs token...');
//             String? token = await FirebaseMessaging.instance.getAPNSToken();
//             print('FlutterFire Messaging Example: Got APNs token: $token');
//           } else {
//             print(
//               'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.',
//             );
//           }
//         }
//         break;
//       default:
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Cloud Messaging'),
//         actions: <Widget>[
//           PopupMenuButton(
//             onSelected: onActionSelected,
//             itemBuilder: (BuildContext context) {
//               return [
//                 const PopupMenuItem(
//                   value: 'subscribe',
//                   child: Text('Subscribe to topic'),
//                 ),
//                 const PopupMenuItem(
//                   value: 'unsubscribe',
//                   child: Text('Unsubscribe to topic'),
//                 ),
//                 const PopupMenuItem(
//                   value: 'get_apns_token',
//                   child: Text('Get APNs token (Apple only)'),
//                 ),
//               ];
//             },
//           ),
//         ],
//       ),
//       floatingActionButton: Builder(
//         builder: (context) => FloatingActionButton(
//           // onPressed: sendPushMessage,
//           onPressed: () {
//             sendPushMessage("titleText", "bodyText");
//           },
//           backgroundColor: Colors.white,
//           child: const Icon(Icons.send),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             MetaCard('Permissions', Permissions()),
//             MetaCard(
//               'FCM Token',
//               TokenMonitor((token) {
//                 _token = token;
//                 print(token);
//                 return token == null
//                     ? const CircularProgressIndicator()
//                     : Text(token, style: const TextStyle(fontSize: 12));
//               }),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 FirebaseMessaging.instance
//                     .getInitialMessage()
//                     .then((RemoteMessage? message) {
//                   if (message != null) {
//                     Navigator.pushNamed(
//                       context,
//                       '/message',
//                       arguments: MessageArguments(message, true),
//                     );
//                   }
//                 });
//               },
//               child: const Text('getInitialMessage()'),
//             ),
//             MetaCard('Message Stream', MessageList()),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// UI Widget for displaying metadata.
// class MetaCard extends StatelessWidget {
//   final String _title;
//   final Widget _children;

//   // ignore: public_member_api_docs
//   MetaCard(this._title, this._children);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(bottom: 16),
//                 child: Text(_title, style: const TextStyle(fontSize: 18)),
//               ),
//               _children,
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }





















// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'firebase_options.dart';

// // import 'package:flutter/material.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp(
// //     options: DefaultFirebaseOptions.currentPlatform,
// //   );
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'Flutter Demo',
// //       theme: ThemeData(
// //         primarySwatch: Colors.purple,
// //         visualDensity: VisualDensity.adaptivePlatformDensity,
// //       ),
// //       home: HomePage(),
// //     );
// //   }
// // }

// // class HomePage extends StatefulWidget {
// //   const HomePage({Key? key}) : super(key: key);

// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }

// // class _HomePageState extends State<HomePage> {
// //   String? token;

// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //     getToken();
// //   }

// //   getToken() async {
// //     token = await FirebaseMessaging.instance.getToken();
// //     print(token);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container();
// //   }
// // }




























// // import 'dart:convert';

// // import 'package:flutter/material.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:web_socket_channel/io.dart';
// // import 'package:web_socket_channel/web_socket_channel.dart';
// // import 'package:workmanager/workmanager.dart';

// // const simpleDelayedTask = "be.tramckrijte.workmanagerExample.simpleDelayedTask";

// // // void main() {
// // //   Workmanager().initialize(
// // //     callbackDispatcher,
// // //     isInDebugMode: true,
// // //   );
// // //   Workmanager().registerOneOffTask(
// // //     simpleDelayedTask,
// // //     simpleDelayedTask,
// // //     initialDelay: const Duration(hours: 10),
// // //   );
// // //   runApp(MyApp());
// // // }

// // // void callbackDispatcher() {
// // //   Workmanager().executeTask((task, inputData) {
// // //     print("Native called background task: $backgroundTask"); //simpleTask will be emitted here.
// // //     return Future.value(true);
// // //   });
// // // }

// // void main() {
// //   WidgetsFlutterBinding.ensureInitialized();

// //   Workmanager().initialize(
// //       callbackDispatcher, // The top level function, aka callbackDispatcher
// //       isInDebugMode:
// //           true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
// //       );
// //   Workmanager().registerOneOffTask("task-identifier", "simpleTask");
// //   runApp(MyApp());
// // }

// // void callbackDispatcher() {
// //   print("callbackDispatcher___________))))))))))))))))");
// //   Workmanager().executeTask((task, inputData) async {
// //     print("callbackDispatcher___________))))))))))))))))");

// //     listenNotificatins();
// //     print("callbackDispatcher___________))))))))))))))))");

// //     return Future.value(true);
// //   });
// // }

// // TextEditingController _message = TextEditingController();
// // late WebSocketChannel channel;
// // bool _iserror = false;
// // var sub;
// // String? text;

// // void listenNotificatins() {
// //   FlutterLocalNotificationsPlugin notifications =
// //       FlutterLocalNotificationsPlugin();
// //   var androidInit = const AndroidInitializationSettings('@mipmap/ic_launcher');
// //   var iOSInit = const IOSInitializationSettings();
// //   channel = IOWebSocketChannel.connect(
// //       'wss://abber.co/ws/help/7540ed48-cc30-4edb-8a2a-266db241cd15/',
// //       headers: {
// //         'Authorization':
// //             'JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMCwidXNlcm5hbWUiOiJzZWxsZXJzIiwiZXhwIjoxNjYxMjk1MjI4LCJlbWFpbCI6ImJ1c2luZXNzLnppbm9uQGdtYWlsLmNvbSIsIm9yaWdfaWF0IjoxNjYxMjA4ODI4fQ.SD1z46Qy3XHuo0VpaQkjMLtcEvfp_pfm-9PPwMnmBWQ'
// //       });
// //   _message = TextEditingController();
// //   var init = InitializationSettings(android: androidInit, iOS: iOSInit);
// //   notifications.initialize(init).then((done) {
// //     sub = channel.stream.listen((newData) {
// //       print("الاستماع للاشعار");
// //       text = json.decode(newData).toString();
// //       print(text);
// //       notifications.show(
// //           0,
// //           "New announcement",
// //           text,
// //           const NotificationDetails(
// //               android: AndroidNotificationDetails(
// //                 "announcement_app_0",
// //                 'Announcement App',
// //               ),
// //               iOS: IOSNotificationDetails()));
// //     });
// //   });
// // }

// // class MyApp extends StatelessWidget {
// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'Flutter Demo',
// //       theme: ThemeData(
// //         primarySwatch: Colors.purple,
// //         visualDensity: VisualDensity.adaptivePlatformDensity,
// //       ),
// //       home: HomePage(),
// //     );
// //   }
// // }

// // class HomePage extends StatefulWidget {
// //   @override
// //   _HomePageState createState() => _HomePageState();
// // }

// // class _HomePageState extends State<HomePage> {
// //   // TextEditingController _message = TextEditingController();
// //   // late WebSocketChannel channel;
// //   // bool _iserror = false;
// //   // var sub;
// //   // String? text;

// //   @override
// //   void initState() {
// //     super.initState();

// //     // FlutterLocalNotificationsPlugin notifications =
// //     //     FlutterLocalNotificationsPlugin();
// //     // var androidInit =
// //     //     const AndroidInitializationSettings('@mipmap/ic_launcher');
// //     // var iOSInit = const IOSInitializationSettings();
// //     // channel = IOWebSocketChannel.connect(
// //     //     'wss://abber.co/ws/help/7540ed48-cc30-4edb-8a2a-266db241cd15/',
// //     //     headers: {
// //     //       'Authorization':
// //     //           'JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMCwidXNlcm5hbWUiOiJzZWxsZXJzIiwiZXhwIjoxNjYxMjk1MjI4LCJlbWFpbCI6ImJ1c2luZXNzLnppbm9uQGdtYWlsLmNvbSIsIm9yaWdfaWF0IjoxNjYxMjA4ODI4fQ.SD1z46Qy3XHuo0VpaQkjMLtcEvfp_pfm-9PPwMnmBWQ'
// //     //     });
// //     // _message = TextEditingController();
// //     // var init = InitializationSettings(android: androidInit, iOS: iOSInit);
// //     // notifications.initialize(init).then((done) {
// //     //   sub = channel.stream.listen((newData) {
// //     //     print("الاستماع للاشعار");
// //     //     text = json.decode(newData).toString();
// //     //     print(text);
// //     //     notifications.show(
// //     //         0,
// //     //         "New announcement",
// //     //         text,
// //     //         const NotificationDetails(
// //     //             android: AndroidNotificationDetails(
// //     //               "announcement_app_0",
// //     //               'Announcement App',
// //     //             ),
// //     //             iOS: IOSNotificationDetails()));
// //     //   });
// //     // });
// //   }

// //   @override
// //   void dispose() {
// //     // _iserror = false;
// //     // _message.dispose();
// //     // channel.sink.close(status.goingAway);
// //     // sub.cancel();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Home Page'),
// //       ),
// //       body: SizedBox(
// //         height: double.infinity,
// //         child: Padding(
// //           padding: const EdgeInsets.all(20),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: <Widget>[
// //               TextField(
// //                 controller: _message,
// //                 autofocus: false,
// //                 decoration: InputDecoration(
// //                   hintText: 'Type your Message',
// //                   errorText: _iserror ? 'Textfield is empty!' : null,
// //                   contentPadding:
// //                       const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
// //                   border: const OutlineInputBorder(),
// //                 ),
// //               ),
// //               IconButton(
// //                   icon: const Icon(Icons.send),
// //                   onPressed: () {
// //                     setState(() {
// //                       _message.text.isEmpty
// //                           ? _iserror = true
// //                           : _iserror = false;
// //                     });
// //                     if (!_iserror) {
// //                       channel.sink.add(jsonEncode({
// //                         'message': _message.text.trim(),
// //                         'room': '7540ed48-cc30-4edb-8a2a-266db241cd15'
// //                       }));
// //                       _message.text = '';
// //                     }
// //                   })
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
































// // import 'dart:async';
// // import 'dart:io';
// // import 'dart:math';

// // import 'package:flutter/material.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:workmanager/workmanager.dart';

// // void main() => runApp(MyApp());

// // const simpleTaskKey = "be.tramckrijte.workmanagerExample.simpleTask";
// // const rescheduledTaskKey = "be.tramckrijte.workmanagerExample.rescheduledTask";
// // const failedTaskKey = "be.tramckrijte.workmanagerExample.failedTask";
// // const simpleDelayedTask = "be.tramckrijte.workmanagerExample.simpleDelayedTask";
// // const simplePeriodicTask =
// //     "be.tramckrijte.workmanagerExample.simplePeriodicTask";
// // const simplePeriodic1HourTask =
// //     "be.tramckrijte.workmanagerExample.simplePeriodic1HourTask";

// // void callbackDispatcher() {
// //   Workmanager().executeTask((task, inputData) async {
// //     switch (task) {
// //       case simpleTaskKey:
// //         print("$simpleTaskKey was executed. inputData = $inputData");
// //         print("$simpleTaskKey تم اعدامه. ادخال البيانات = $inputData");
// //         final prefs = await SharedPreferences.getInstance();
// //         prefs.setBool("test", true);
// //         print("Bool from prefs: ${prefs.getBool("test")}");
// //         print("Bool من prefs: ${prefs.getBool("test")}");
// //         break;
// //       case rescheduledTaskKey:
// //         final key = inputData!['key']!;
// //         final prefs = await SharedPreferences.getInstance();
// //         if (prefs.containsKey('unique-$key')) {
// //           print('has been running before, task is successful');
// //           print('تم تشغيله من قبل ، المهمة ناجحة');
// //           return true;
// //         } else {
// //           await prefs.setBool('unique-$key', true);
// //           print('reschedule task');
// //           print('إعادة جدولة المهمة');
// //           return false;
// //         }
// //       case failedTaskKey:
// //         print('failed task');
// //         print('مهمة فاشلة');
// //         return Future.error('failed');
// //       case simpleDelayedTask:
// //         print("$simpleDelayedTask was executed");
// //         print("$simpleDelayedTask تم اعدامه");
// //         break;
// //       case simplePeriodicTask:
// //         print("$simplePeriodicTask was executed");
// //         print("$simplePeriodicTask تم اعدامه");
// //         break;
// //       case simplePeriodic1HourTask:
// //         print("$simplePeriodic1HourTask was executed");
// //         print("$simplePeriodic1HourTask تم اعدامه");
// //         break;
// //       case Workmanager.iOSBackgroundTask:
// //         print("The iOS background fetch was triggered");
// //         print("تم تشغيل جلب خلفية iOS");
// //         Directory? tempDir = await getTemporaryDirectory();
// //         String? tempPath = tempDir.path;
// //         print(
// //             "You can access other plugins in the background, for example Directory.getTemporaryDirectory(): $tempPath");
// //         print(
// //             "يمكنك الوصول إلى المكونات الإضافية الأخرى في الخلفية ، على سبيل المثال Directory.getTauseDirectory (): $tempPath");
// //         break;
// //     }

// //     return Future.value(true);
// //   });
// // }

// // class MyApp extends StatefulWidget {
// //   @override
// //   _MyAppState createState() => _MyAppState();
// // }

// // class _MyAppState extends State<MyApp> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: const Text("Flutter WorkManager Example"),
// //         ),
// //         body: SingleChildScrollView(
// //           child: Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               children: <Widget>[
// //                 Text(
// //                   "Plugin initialization",
// //                   style: Theme.of(context).textTheme.headline5,
// //                 ),
// //                 const Text("تهيئة البرنامج المساعد"),
// //                 ElevatedButton(
// //                   child: Column(children: const [
// //                     Text("Start the Flutter background service"),
// //                     Text("ابدأ خدمة Flutter في الخلفية"),
// //                   ]),
// //                   onPressed: () {
// //                     Workmanager().initialize(
// //                       callbackDispatcher,
// //                       isInDebugMode: true,
// //                     );
// //                   },
// //                 ),
// //                 const SizedBox(height: 16),

// //                 //This task runs once.
// //                 //Most likely this will trigger immediately
// //                 ElevatedButton(
// //                   child: Column(
// //                     children: const [
// //                       Text("Register OneOff Task"),
// //                       Text("تسجيل مهمة OneOff"),
// //                     ],
// //                   ),
// //                   onPressed: () {
// //                     Workmanager().registerOneOffTask(
// //                       simpleTaskKey,
// //                       simpleTaskKey,
// //                       inputData: <String, dynamic>{
// //                         'int': 1,
// //                         'bool': true,
// //                         'double': 1.0,
// //                         'string': 'string',
// //                         'array': [1, 2, 3],
// //                       },
// //                     );
// //                   },
// //                 ),
// //                 ElevatedButton(
// //                   child: Column(
// //                     children: const [
// //                       Text("Register rescheduled Task"),
// //                       Text("تسجيل المهمة المعاد جدولتها"),
// //                     ],
// //                   ),
// //                   onPressed: () {
// //                     Workmanager().registerOneOffTask(
// //                       rescheduledTaskKey,
// //                       rescheduledTaskKey,
// //                       inputData: <String, dynamic>{
// //                         'key': Random().nextInt(64000),
// //                       },
// //                     );
// //                   },
// //                 ),
// //                 ElevatedButton(
// //                   child: Column(
// //                     children: const [
// //                       Text("Register failed Task"),
// //                       Text("فشل تسجيل المهمة"),
// //                     ],
// //                   ),
// //                   onPressed: () {
// //                     Workmanager().registerOneOffTask(
// //                       failedTaskKey,
// //                       failedTaskKey,
// //                     );
// //                   },
// //                 ),
// //                 //This task runs once
// //                 //This wait at least 10 seconds before running
// //                 ElevatedButton(
// //                     child: Column(
// //                       children: const [
// //                         Text("Register Delayed OneOff Task"),
// //                         Text("تسجيل مهمة OneOff المؤجلة"),
// //                       ],
// //                     ),
// //                     onPressed: () {
// //                       Workmanager().registerOneOffTask(
// //                         simpleDelayedTask,
// //                         simpleDelayedTask,
// //                         initialDelay: const Duration(seconds: 10),
// //                       );
// //                     }),
// //                 const SizedBox(height: 8),
// //                 //This task runs periodically
// //                 //It will wait at least 10 seconds before its first launch
// //                 //Since we have not provided a frequency it will be the default 15 minutes
// //                 ElevatedButton(
// //                     onPressed: Platform.isAndroid
// //                         ? () {
// //                             Workmanager().registerPeriodicTask(
// //                               simplePeriodicTask,
// //                               simplePeriodicTask,
// //                               initialDelay: const Duration(seconds: 10),
// //                             );
// //                           }
// //                         : null,
// //                     child: Column(
// //                       children: const [
// //                         Text("Register Periodic Task (Android)"),
// //                         Text("سجل المهمة الدورية (Android)"),
// //                       ],
// //                     )),
// //                 //This task runs periodically
// //                 //It will run about every hour
// //                 ElevatedButton(
// //                     onPressed: Platform.isAndroid
// //                         ? () {
// //                             Workmanager().registerPeriodicTask(
// //                               simplePeriodicTask,
// //                               simplePeriodic1HourTask,
// //                               frequency: const Duration(seconds: 10),
// //                             );
// //                           }
// //                         : null,
// //                     child: Column(
// //                       children: const [
// //                         Text(
// //                             "Register 10 seconds Periodic Task (Android)"),
// //                         Text("سجل 10 ثانية مهمة دورية (Android)"),
// //                       ],
// //                     )),
// //                 const SizedBox(height: 16),
// //                 Text(
// //                   "Task cancellation, إلغاء المهمة",
// //                   style: Theme.of(context).textTheme.headline5,
// //                 ),
// //                 ElevatedButton(
// //                   child: const Text("Cancel All ألغ الكل"),
// //                   onPressed: () async {
// //                     await Workmanager().cancelAll();
// //                     print(
// //                         'Cancel all tasks completed  إلغاء جميع المهام المكتملة');
// //                   },
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }