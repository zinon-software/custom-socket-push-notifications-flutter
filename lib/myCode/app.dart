import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          // onPressed: sendPushMessage,
          onPressed: () async {
            String token = await getToken();

            print(token);

            sendPushMessage(token, 'titleText', 'bodyText');
          },
          backgroundColor: Colors.white,
          child: const Icon(Icons.send),
        ),
      ),
    );
  }
}

getToken() async {
  return await FirebaseMessaging.instance.getToken();
}

void sendPushMessage(String token, String body, String title) async {
  try {
    var r = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAdK-as-Q:APA91bHO9EdgX4sO8zg7DumbBAM3rVToDEdhOkbTgSiVbUipTo4K2-vZohe2eplzRfBxEg97QgbC7QwgE5Zp8MZ65ht54Nv7m98xP-UHSaDywJCOhB55-EzDmQ5AvIkZnK_IgkEPJ9k5',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': body, 'title': title},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          "to": token,
        },
      ),
    );

    print('FCM request for device sent!================================');
    print(jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{'body': body, 'title': title},
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done'
      },
      "to": token,
    }));
    print(r.body);
  } catch (e) {
    print("error push notification");
  }
}
