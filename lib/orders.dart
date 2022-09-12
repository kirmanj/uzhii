import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class OrderHistory extends StatefulWidget {
  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<DocumentSnapshot> orders;
  int totalIncome = 0;

  List<ExpensesDate> _chartDate;
  getProduct() {
    print("products");
    FirebaseFirestore.instance
        .collection("orders")
        .orderBy("date", descending: true)
        .snapshots()
        .listen((event) {
      setState(() {
        orders = event.docs;

        _chartDate = getDate();
      });
    }).onDone(() {});
  }

  getDate() {
    List<ExpensesDate> data = [];

    orders.forEach((element) {
      print(element);
      setState(() {
        totalIncome += element['total'];
      });
    });

    return data;
  }

  @override
  void initState() {
    getProduct();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    width: width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Neumorphic(
                            style:
                                NeumorphicStyle(shadowDarkColor: Colors.blue),
                            child: Container(
                              margin: EdgeInsets.only(left: 5.0),
                              width: 35,
                              height: 35,
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            NeumorphicText(
                              "Total Income : ",
                              textStyle: NeumorphicTextStyle(fontSize: 16),
                              style: NeumorphicStyle(color: Colors.black),
                            ),
                            Countup(
                                begin: 0,
                                end: totalIncome.toDouble(),
                                duration: Duration(seconds: 3),
                                separator: ',',
                                suffix: "  IQD",
                                style: TextStyle(
                                  fontSize: 13,
                                ))
                          ],
                        ),
                      ],
                    ),
                  )
              ),




              Expanded(
                flex: 9,
                child: orders == null
                    ? Container()
                    : Container(
                        child: ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: ((BuildContext context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Neumorphic(
                                    style: NeumorphicStyle(
                                        shadowDarkColor: Colors.blue),
                                    child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                            child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                NeumorphicText(
                                                  orders[index]
                                                      .id
                                                      .toString()
                                                      .substring(0, 7),
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                          fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                  style: NeumorphicStyle(
                                                      color: Colors.black),
                                                ),
                                                NeumorphicText(
                                                  orders[index]['date'],
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                          fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                  style: NeumorphicStyle(
                                                      color: Colors.black),
                                                ),
                                                NeumorphicText(
                                                  orders[index]['total']
                                                          .toStringAsFixed(1) +
                                                      "  IQD",
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                          fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                  style: NeumorphicStyle(
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                NeumorphicText(
                                                  "Product",
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                          fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                  style: NeumorphicStyle(
                                                      color: Colors.black),
                                                ),
                                                NeumorphicText(
                                                  "Quantity",
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                          fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                  style: NeumorphicStyle(
                                                      color: Colors.black),
                                                ),
                                                NeumorphicText(
                                                  "Price",
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                          fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                  style: NeumorphicStyle(
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                            Divider(color: Colors.blueAccent),
                                            Container(
                                                height: height * 0.15,
                                                child: ListView.builder(
                                                    itemCount: orders[index]
                                                            ['items']
                                                        .length,
                                                    itemBuilder:
                                                        ((BuildContext
                                                                context,
                                                            indext) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.1),
                                                        child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            child: Container(
                                                                child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child:
                                                                      NeumorphicText(
                                                                    orders[index]['items']
                                                                            [
                                                                            indext]
                                                                        [
                                                                        'English'],
                                                                    textStyle:
                                                                        NeumorphicTextStyle(
                                                                            fontSize: 12),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: NeumorphicStyle(
                                                                        color:
                                                                            Colors.black),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child:
                                                                      NeumorphicText(
                                                                    orders[index]['items'][indext]
                                                                            [
                                                                            'quantity']
                                                                        .toString(),
                                                                    textStyle:
                                                                        NeumorphicTextStyle(
                                                                            fontSize: 12),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: NeumorphicStyle(
                                                                        color:
                                                                            Colors.black),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child:
                                                                      NeumorphicText(
                                                                    orders[index]['items'][indext]
                                                                            [
                                                                            'price'] +
                                                                        "  IQD",
                                                                    textStyle:
                                                                        NeumorphicTextStyle(
                                                                            fontSize: 12),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: NeumorphicStyle(
                                                                        color:
                                                                            Colors.black),
                                                                  ),
                                                                )
                                                              ],
                                                            ))),
                                                      );
                                                    }))),
                                          ],
                                        )))),
                              );
                            }))),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ExpensesDate {
  String x;
  double y;
  ExpensesDate(this.x, this.y);
}
