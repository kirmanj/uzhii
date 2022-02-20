import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:uzhii/main.dart';
import 'package:uzhii/reports.dart';
import 'package:uzhii/splash.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int curency;

  bool edit = false;

  TextEditingController _curencyController = TextEditingController();

  getCurency() {
    FirebaseFirestore.instance
        .collection('curency')
        .snapshots()
        .listen((dataSnapshot) {
      DocumentSnapshot temp = dataSnapshot.docs[0];
      print(temp['euro']);
      setState(() {
        curency = temp['euro'];
      });
    });
  }

  changeCurency(int val) {
    setState(() {
      _curencyController = new TextEditingController();
      edit = !edit;
    });
    print(val);
    FirebaseFirestore.instance
        .collection('curency')
        .doc('FdODBHbSYS4NY4L29oPs')
        .update({'euro': val});
  }

  User user;
  FirebaseAuth _auth;

  DocumentSnapshot snapshot;
  Future getUserInfo() async {
    //user =  _auth.currentUser;
    snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    setState(() {
      userRole = snapshot['role'];
      print("userRole $userRole");
    });
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    super.initState();
    _auth = FirebaseAuth.instance;
    Future.delayed(Duration(milliseconds: 100), () {
      getUserInfo();
    });
    getCurency();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: height * 0.9,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: height * 0.1),
                      child: Column(
                        children: [
                          Container(
                            width: width * 0.5,
                            child: Container(
                              child: Image.asset("images/plogo.png"),
                            ),
                          ),
                          Container(
                            child: Text(
                              "BUYER",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(235, 118, 189, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: height * 0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          NeumorphicButton(
                            child: Text(
                              "Profit Reports        ",
                              style: TextStyle(
                                color: Color.fromRGBO(235, 118, 189, 1),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => Reposts(
                                            state: 1,
                                          )));
                            },
                            style: NeumorphicStyle(color: Colors.white),
                          ),
                          NeumorphicButton(
                            child: Text(
                              "Costumer Reports",
                              style: TextStyle(
                                color: Color.fromRGBO(235, 118, 189, 1),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => Reposts(
                                            state: 1,
                                          )));
                            },
                            style: NeumorphicStyle(color: Colors.white),
                          ),
                          (!edit)
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Neumorphic(
                                      child: Container(
                                          width: width * 0.4,
                                          height: height * 0.05,
                                          child: Center(
                                              child: Text(
                                            "1 Lb  =  " +
                                                curency.toString() +
                                                " IQD",
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  235, 118, 189, 1),
                                            ),
                                          ))),
                                    ),
                                    NeumorphicButton(
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        print(userRole);
                                        setState(() {
                                          edit = !edit;
                                        });
                                      },
                                      style: NeumorphicStyle(
                                        color: Color.fromRGBO(235, 118, 189, 1),
                                      ),
                                    )
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Neumorphic(
                                      child: Container(
                                          width: width * 0.4,
                                          height: height * 0.05,
                                          child: Center(
                                              child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: _curencyController,
                                            decoration: InputDecoration(
                                              hintText: 'Enter Number',
                                              hintStyle: TextStyle(
                                                  color: Color.fromRGBO(
                                                      235, 118, 189, 1),
                                                  fontSize: 14),
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      20.0, 10.0, 20.0, 10.0),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                            ),
                                          ))),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: NeumorphicButton(
                                            child: Icon(
                                              Icons.close,
                                              size: 18,
                                              color: Color.fromRGBO(
                                                  235, 118, 189, 1),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                edit = !edit;
                                              });
                                            },
                                            style: NeumorphicStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                        NeumorphicButton(
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              int temp = int.parse(
                                                  _curencyController.text
                                                      .toString());

                                              changeCurency(temp);
                                            },
                                            style: NeumorphicStyle(
                                              color: Color.fromRGBO(
                                                  235, 118, 189, 1),
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                    bottom: height * 0.03,
                    left: width * 0.35,
                    child: Container(
                      width: width * 0.3,
                      child: NeumorphicButton(
                          style: NeumorphicStyle(
                            color: Color.fromRGBO(235, 118, 189, 1),
                          ),
                          child: Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Logout",
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(
                                Icons.logout,
                                size: 18,
                                color: Colors.white,
                              ),
                            ],
                          )),
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => new SplashScreen()));
                          }),
                    ))
              ],
            )),
      ),
    );
  }
}
