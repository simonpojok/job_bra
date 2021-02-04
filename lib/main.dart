import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:job_extra/pages/home/home_page.dart';
import 'package:job_extra/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Extra',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: HomePage.routeName,
      routes: routes,
    );
  }
}