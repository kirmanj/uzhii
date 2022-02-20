import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:uzhii/Postscreen.dart';
import 'package:uzhii/main.dart';
import 'package:uzhii/postDetail.dart';
import 'package:uzhii/profile.dart';

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  bool add = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: height * 0.03),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "POSTS",
                    style: TextStyle(
                      color: Color.fromRGBO(235, 118, 189, 1),
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Positioned(
              child: Container(
                  padding: EdgeInsets.only(top: height * 0.05),
                  height: height * 0.9,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .snapshots(),
                    builder: (context, snapshot) {
                      QuerySnapshot data = snapshot.data;
                      if (data == null)
                        return Center(
                          child: Container(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          ),
                        );
                      return Padding(
                        padding: EdgeInsets.only(right: width * 0.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.all(5),
                              child: new Neumorphic(
                                padding: EdgeInsets.only(left: 10),
                                style: NeumorphicStyle(
                                    border: NeumorphicBorder(
                                  color: Color.fromRGBO(235, 118, 189, 1),
                                )),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Code: " +
                                              data.docs[index]['code']
                                                  .toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(
                                                235, 118, 189, 1),
                                          ),
                                        ),
                                        Container(
                                            width: 30,
                                            height: 30,
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.arrow_forward_ios_sharp,
                                                  size: 18,
                                                  color: Color.fromRGBO(
                                                      235, 118, 189, 1),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (ctx) =>
                                                              PostDetail(
                                                                post: data.docs[
                                                                    index],
                                                              )));
                                                }))
                                      ],
                                    ),
                                    Text(
                                      "Pound Price: " +
                                          data.docs[index]['totalP']
                                              .toStringAsFixed(0)
                                              .replaceAllMapped(
                                                  RegExp(
                                                      r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                  (Match m) => '${m[1]},'),
                                      style: TextStyle(
                                        color: Color.fromRGBO(235, 118, 189, 1),
                                      ),
                                    ),
                                    Text(
                                      "IQD Price: " +
                                          data.docs[index]['totalI']
                                              .toStringAsFixed(0)
                                              .replaceAllMapped(
                                                  RegExp(
                                                      r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                  (Match m) => '${m[1]},'),
                                      style: TextStyle(
                                        color: Color.fromRGBO(235, 118, 189, 1),
                                      ),
                                    ),
                                    Text(
                                      "No Of Products: " +
                                          data.docs[index]['noOfProducts']
                                              .toString(),
                                      style: TextStyle(
                                        color: Color.fromRGBO(235, 118, 189, 1),
                                      ),
                                    ),
                                    data.docs[index]['state'] == 0
                                        ? Text(
                                            "State: Not Arrived",
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  235, 118, 189, 1),
                                            ),
                                          )
                                        : Text(
                                            "State: Arrived",
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  235, 118, 189, 1),
                                            ),
                                          ),
                                    Text(
                                        "Sending Date: " +
                                            data.docs[index]['sendingDate']
                                                .toString(),
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(235, 118, 189, 1),
                                        )),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  )),
            ),
            (userRole != 1)
                ? Container()
                : Positioned(
                    bottom: -2,
                    right: width * 0.4,
                    child: Container(
                        height: height * 0.05,
                        width: width * 0.2,
                        child: NeumorphicButton(
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            List<DocumentSnapshot> productsSnapshot;

                            List<String> productString = [];
                            FirebaseFirestore.instance
                                .collection('products')
                                .snapshots()
                                .listen((event) {
                              productsSnapshot = event.docs;

                              productsSnapshot.forEach((element) {
                                productString.add(element['name']);
                              });
                            });

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => PostScreen(
                                          productString: productString,
                                        )));
                          },
                          style: NeumorphicStyle(
                              color: Color.fromRGBO(235, 118, 189, 1),
                              border: NeumorphicBorder.none()),
                        )),
                  ),
          ],
        ),
      ),
    );
  }
}
