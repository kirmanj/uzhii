import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class WareHouse extends StatefulWidget {
  @override
  _WareHouseState createState() => _WareHouseState();
}

class _WareHouseState extends State<WareHouse> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.only(left: width * 0.025),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Neumorphic(
                child: Container(
                  height: height * 0.40,
                  width: width * 0.95,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              child: Text(
                            "Available In Store",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(235, 118, 189, 1)),
                          )),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Container(
                              width: 25,
                              height: 25,
                              child: Image.asset("images/happy.png"),
                            ),
                          )
                        ],
                      )),
                      Container(
                        height: height * 0.37,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('products')
                              .snapshots(),
                          builder: (context, snapshot) {
                            QuerySnapshot data = snapshot.data;
                            print(data);
                            if (data == null)
                              return Center(
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color.fromRGBO(235, 118, 189, 1)),
                                  ),
                                ),
                              );
                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: data.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return data.docs[index]["quantity"] == 0
                                      ? Container()
                                      : Container(
                                          height: height * 0.065,
                                          width: width * 0.95,
                                          padding: EdgeInsets.only(
                                              left: width * 0.02,
                                              bottom: height * 0.01,
                                              right: width * 0.02),
                                          child: Neumorphic(
                                            style: NeumorphicStyle(
                                                color: Color.fromRGBO(
                                                    235, 118, 189, 1)),
                                            child: Center(
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      data.docs[index]["name"],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      data.docs[index]
                                                                  ["priceP"]
                                                              .toString() +
                                                          " Ld     " +
                                                          data.docs[index]
                                                                  ["priceI"]
                                                              .toString() +
                                                          "  IQD  " +
                                                          "  Quantity  " +
                                                          data.docs[index]
                                                                  ["quantity"]
                                                              .toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Neumorphic(
                child: Container(
                  height: height * 0.40,
                  width: width * 0.95,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              child: Text(
                            "Unavailable In Store",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(235, 118, 189, 1)),
                          )),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Container(
                              width: 25,
                              height: 25,
                              child: Image.asset("images/sad.png"),
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: height * 0.37,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('products')
                              .snapshots(),
                          builder: (context, snapshot) {
                            QuerySnapshot data = snapshot.data;
                            print(data);
                            if (data == null)
                              return Center(
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                  ),
                                ),
                              );
                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: data.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return data.docs[index]["quantity"] != 0
                                      ? Container()
                                      : Container(
                                          height: height * 0.065,
                                          width: width * 0.95,
                                          padding: EdgeInsets.only(
                                              left: width * 0.02,
                                              bottom: height * 0.01,
                                              right: width * 0.02),
                                          child: Neumorphic(
                                            style: NeumorphicStyle(
                                                color: Color.fromRGBO(
                                                    235, 118, 189, 1)),
                                            child: Center(
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      data.docs[index]["name"],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      data.docs[index]
                                                                  ["priceP"]
                                                              .toString() +
                                                          " Ld     " +
                                                          data.docs[index]
                                                                  ["priceI"]
                                                              .toString() +
                                                          "  IQD  " +
                                                          "  Quantity  " +
                                                          data.docs[index]
                                                                  ["quantity"]
                                                              .toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
