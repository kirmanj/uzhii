import 'dart:developer';
import 'dart:ffi';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:uzhii/Postscreen.dart';
import 'package:uzhii/sellScreen.dart';

class PostDetail extends StatefulWidget {
  DocumentSnapshot post;
  PostDetail({this.post});
  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  bool arrive = false;

  List<Map> remainQtd;
  Map<dynamic, dynamic> post;

  @override
  void initState() {
    if (widget.post['arrivingDate'] != 'Not Arrived') {
      setState(() {
        arrive = true;
      });
    }

    remainQtd = new List<Map>(widget.post["products"].length);

    for (int index = 0; index < widget.post["products"].length; index++) {
      FirebaseFirestore.instance
          .collection("products")
          .where("name", isEqualTo: widget.post["products"][index]['name'])
          .get()
          .then((value) {
        print(value.docs[0]['quantity']);
        setState(() {
          remainQtd[index] = {
            "name": value.docs[0]['name'],
            "quantity": value.docs[0]['quantity']
          };
        });
      }).whenComplete(() {
        post = {
          'code': widget.post['code'],
          'postBenifit': "",
          'products': widget.post['products'],
          'remainProducts': remainQtd,
          'state': widget.post['state'],
          'totalI': widget.post['totalI'],
          'totalP': widget.post['totalP'],
          'noOfProducts': widget.post['noOfProducts'],
          'sendingDate': widget.post['sendingDate'],
          'arrivingDate': widget.post['arrivingDate'],
          'soldOutDate': widget.post['soldOutDate']
        };
      });
    }

    // TODO: implement initState
    super.initState();
  }

  String formattedDate;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          arrive
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => SellScreen(
                                  postId: widget.post.id,
                                  remainProducts: remainQtd,
                                )));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 13, right: 10),
                    child: Neumorphic(
                      child: Container(
                        width: width * 0.2,
                        color: Color.fromRGBO(235, 118, 189, 1),
                        height: 20,
                        child: Center(
                          child: Text(
                            "SELL",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    print(widget.post['arrivingDate']);
                    DateTime now = new DateTime.now();
                    setState(() {
                      formattedDate = DateFormat('dd-MM-yyyy').format(now);
                    });

                    FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.post.id)
                        .update({'arrivingDate': formattedDate});

                    setState(() {
                      arrive = true;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 13, right: 10),
                    child: Neumorphic(
                      child: Container(
                        width: width * 0.2,
                        color: Color.fromRGBO(235, 118, 189, 1),
                        height: 20,
                        child: Center(
                          child: Text(
                            "ARRIVE",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
        ],
        backgroundColor: Colors.white,
        title: Text(
          "Code:  " + widget.post['code'].toString(),
          style:
              TextStyle(fontSize: 20, color: Color.fromRGBO(235, 118, 189, 1)),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Color.fromRGBO(235, 118, 189, 1)),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pound Price: " +
                  widget.post['totalP'].toStringAsFixed(0).replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]},'),
              style: TextStyle(
                  fontSize: 18, color: Color.fromRGBO(235, 118, 189, 1)),
            ),
            Text(
              "IQD Price: " +
                  widget.post['totalI'].toStringAsFixed(0).replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]},'),
              style: TextStyle(
                  fontSize: 18, color: Color.fromRGBO(235, 118, 189, 1)),
            ),
            Text("No Of Products: " + widget.post['noOfProducts'].toString(),
                style: TextStyle(
                    fontSize: 18, color: Color.fromRGBO(235, 118, 189, 1))),
            widget.post['state'] == 0
                ? Text(
                    "State: Not Arrived",
                    style: TextStyle(
                        fontSize: 18, color: Color.fromRGBO(235, 118, 189, 1)),
                  )
                : Text(
                    "State: Arrived",
                    style: TextStyle(
                        fontSize: 18, color: Color.fromRGBO(235, 118, 189, 1)),
                  ),
            Text(
              "Sending Date: " + widget.post['sendingDate'].toString(),
              style: TextStyle(
                  fontSize: 18, color: Color.fromRGBO(235, 118, 189, 1)),
            ),
            Row(
              children: [
                Text("Arriving Date: ",
                    style: TextStyle(
                        fontSize: 18, color: Color.fromRGBO(235, 118, 189, 1))),
                (formattedDate != null)
                    ? Text(formattedDate,
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(235, 118, 189, 1)))
                    : Text(widget.post['arrivingDate'].toString(),
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(235, 118, 189, 1))),
              ],
            ),
            Row(
              children: [
                Text(
                  "Sold Out Date: ",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromRGBO(235, 118, 189, 1)),
                ),
                Text(
                  "Sold Out Date: " + widget.post['soldOutDate'] != 'empty'
                      ? "not sold out"
                      : widget.post['soldOutDate'].toString(),
                  style: TextStyle(
                      fontSize: 18, color: Color.fromRGBO(235, 118, 189, 1)),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Container(
                height: height * 0.55,
                child: post == null
                    ? Container()
                    : ListView.builder(
                        itemCount: post["products"].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Container(
                              height: height * 0.07,
                              width: width * 0.95,
                              padding: EdgeInsets.only(
                                  left: width * 0.02,
                                  bottom: height * 0.01,
                                  right: width * 0.02),
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                    color: Color.fromRGBO(235, 118, 189, 1)),
                                child: Center(
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          post["products"][index]["name"],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            (post["remainProducts"][index] ==
                                                    null)
                                                ? Text("")
                                                : Text(
                                                    post["products"][index]
                                                                ["price"]
                                                            .toStringAsFixed(
                                                                1) +
                                                        " Ld     " +
                                                        post["products"][index]
                                                                ["priceI"]
                                                            .toStringAsFixed(
                                                                1) +
                                                        "  IQD  " +
                                                        "  Qtd  " +
                                                        post["products"][index]
                                                                ["quantity"]
                                                            .toString() +
                                                        "  Remain  " +
                                                        post["remainProducts"]
                                                                    [index]
                                                                ['quantity']
                                                            .toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
