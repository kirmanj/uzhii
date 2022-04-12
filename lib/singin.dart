import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:uzhii/main.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  GlobalKey<ScaffoldState> scaffoldKey;

  LoginPage({scaffoldKey});
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  String getEmail = "";
  String getPassword = "";
  bool forget = false;
  GlobalKey<FormState> _formKey = GlobalKey();

  loged() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passController.text);
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _emailController.text)
          .limit(1)
          .get()
          .then((value) {
        value.docs.first.reference.update({'password': _passController.text});
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => UZHII()));

      FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        const snackBar = SnackBar(
          content: Text('No user found for that email.'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        const snackBarr = SnackBar(
          content: Text('Wrong password provided for that user.'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBarr);

        print('Wrong password provided for that user.');
      }
    }
  }

  passwordReset() {
    if (_formKey.currentState.validate()) {
      print(_emailController.text);
      try {
        FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text)
            .then((v) {
          widget.scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(' سەردانی ئیمێلەکەت بکە'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ));
          // FirebaseFirestore.instance
          //     .collection('users')
          //     .where('email', isEqualTo: _emailController.text)
          //     .limit(1)
          //     .get()
          //     .then((value) {
          //   value.docs.first.reference.update({data});
          // });
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          widget.scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Email'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ));
        } else if (e.code == 'user-not-found') {
          widget.scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('User not found'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      validator: (val) {
        if (val.isEmpty) {
          return 'Email is empty';
        } else {
          return null;
        }
      },
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      validator: (val) {
        if (_emailController.text.isNotEmpty) {
          if (val.isEmpty) {
            return 'پاسوردەکەت هەلەیە';
          } else {
            return null;
          }
        }
      },
      controller: _passController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: RaisedButton(
        color: Color.fromRGBO(23, 25, 95, 1),
        onPressed: () {
          if (forget) {
            passwordReset();
          } else {
            if (_formKey.currentState.validate()) {
              loged();
            }
          }
        },
        child: Text(
          forget ? "Send" : 'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        forget ? "Back" : 'Forget Password',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        setState(() {
          forget = !forget;
        });
      },
    );

    double width = MediaQuery.of(context).size.width;
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   elevation: 0,
      //   leading: IconButton(
      //     icon:
      //         Icon(Icons.arrow_back_ios, color: Theme.of(context).accentColor),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      // ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          child: Center(
            child: Card(
              elevation: 0,
              child: Container(
                width: width * 0.9,
                height: height,
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: "logo",
                        child: Container(
                          height: height * 0.07,
                          child: Image.asset("images/plogo1.png"),
                        ),
                      ),
                      SizedBox(height: 70.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              email,
                              SizedBox(height: 8.0),
                              forget ? Container() : password,
                            ],
                          )),
                      loginButton,
                      forgotLabel,
                      SizedBox(
                        height: height * 0.1,
                      ),
                      Center(
                        child: Text('ONLY UZHII STAFF',
                            style: TextStyle(
                              color: Color.fromRGBO(23, 25, 95, 1),
                              fontSize: 18,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
