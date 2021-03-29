import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ubberclone/allscreen/LoginScreen.dart';
import 'package:ubberclone/allscreen/mainsreen.dart';

import 'package:ubberclone/allscreen/registerscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference usersref =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Taxi",
      theme: ThemeData(
          fontFamily: "Brand Bold",
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      initialRoute: MainScreen.idScreen,
      routes: {
        Register.idScreen: (context) => Register(),
        Login.idScreen: (context) => Login(),
        MainScreen.idScreen: (context) => MainScreen()
      },
      home: Register(),
      debugShowCheckedModeBanner: false,
    );
  }
}
