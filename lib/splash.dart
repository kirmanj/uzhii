import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:uzhii/main.dart';
import 'package:uzhii/singin.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      print("object");
      PageRouteBuilder(
          transitionDuration: Duration(seconds: 2),
          pageBuilder: (_, __, ___) => LoginPage());
      Navigator.push(context, MaterialPageRoute(builder: (crl) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: width,
        height: height,
        child: Center(
            child: Hero(tag: "logo", child: Image.asset("images/plogo1.png"))),
      ),
    );
  }
}
