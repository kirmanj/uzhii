import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

int userRole = 1;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
   // Scaffold(body: Text('ss'),);
      NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Fresh Pasta',
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        baseColor: Colors.white,
        lightSource: LightSource.topLeft,
        depth: 2,
      ),
      darkTheme: NeumorphicThemeData(
        baseColor: Colors.white,
        lightSource: LightSource.topLeft,
        depth: 6,
      ),
      home: Home(),
    );
  }
}
