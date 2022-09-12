import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpensesHistory extends StatefulWidget {
  @override
  State<ExpensesHistory> createState() => _ExpensesHistoryState();
}

class _ExpensesHistoryState extends State<ExpensesHistory> {
  List<DocumentSnapshot> expenses;
  int totalExpenses = 0;

  List<ExpensesDate> _chartDate;
  getProduct() {
    print("products");
    FirebaseFirestore.instance
        .collection("expenses")
        .orderBy("date", descending: true)
        .snapshots()
        .listen((event) {
      setState(() {
        expenses = event.docs;

        _chartDate = getDate();
      });
    }).onDone(() {});
  }

  getDate() {
    List<ExpensesDate> data = [];

    expenses.forEach((element) {
      print(element);
      setState(() {
        totalExpenses += element['price'];
      });
    });
    print("data");
    print(data);

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
                                NeumorphicStyle(shadowDarkColor: Colors.red),
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
                              "Total Expenses : ",
                              textStyle: NeumorphicTextStyle(fontSize: 16),
                              style: NeumorphicStyle(color: Colors.black),
                            ),
                            Countup(
                                begin: 0,
                                end: totalExpenses.toDouble(),
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
                  )),






              Expanded(
                flex: 9,
                child: expenses == null
                    ? Container()
                    : Container(
                    child: ListView.builder(
                        itemCount: expenses.length,
                        itemBuilder: ((BuildContext context, index) {
                          return

                            Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                  shadowDarkColor: Colors.red),
                              child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    left: 15.0),
                                                child: NeumorphicText(
                                                  expenses[index]['name'],
                                                  textStyle:
                                                  NeumorphicTextStyle(
                                                      fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                  style: NeumorphicStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        left: 15.0),
                                                    child: NeumorphicText(
                                                      expenses[index]
                                                      ['date']
                                                          .substring(0, 11),
                                                      textStyle:
                                                      NeumorphicTextStyle(
                                                          fontSize: 12),
                                                      textAlign:
                                                      TextAlign.left,
                                                      style:
                                                      NeumorphicStyle(
                                                          color: Colors
                                                              .black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    left: 25.0),
                                                child: NeumorphicText(
                                                  expenses[index]['price']
                                                      .toStringAsFixed(
                                                      1) +
                                                      "  IQD",
                                                  textStyle:
                                                  NeumorphicTextStyle(
                                                      fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                  style: NeumorphicStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            NeumorphicText(
                                              expenses[index]['note'],
                                              textStyle:
                                              NeumorphicTextStyle(
                                                  fontSize: 12),
                                              textAlign: TextAlign.left,
                                              style: NeumorphicStyle(
                                                  color: Colors.black),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          );
                        }))
                ),
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
