import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:uzhii/products.dart';

import 'charts.dart';
import 'expensesHistory.dart';
import 'expensesReport.dart';
import 'orders.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List classes = [
    'Order History',
    'Products Report',
    "Expenses",
    "Expenses Report",
    "Charts Report"
  ];
  List classesName = [
    OrderHistory(),
    Products(),
    ExpensesHistory(),
    Expenses(),
    Charts()
  ];
  int income = 0;
  int expenses = 0;
  int profit = 0;

  bool flage1 = false;
  bool flage2 = false;
  List<Map> cats = [];

  int totalExpenses = 0;

  calculate1() {
    FirebaseFirestore.instance
        .collection('expenses')
        .snapshots()
        .forEach((event) {
      for (int i = 0; i < event.docs.length; i++) {
        for (int j = 0; j < cats.length; j++) {
          if (event.docs[i]['name'] == cats[j]['name']) {
            cats[j]['total'] += event.docs[i]['price'];
            setState(() {
              totalExpenses += event.docs[i]['price'];
            });
            break;
          }
        }
      }
    }).timeout(Duration(seconds: 2), onTimeout: calculate2);
  }

  calculate2() {
    cats.forEach((element) {
      FirebaseFirestore.instance
          .collection('expensesCategory')
          .doc(element['id'])
          .update({"total": element['total']});
    });
  }

  calculate() {
    FirebaseFirestore.instance
        .collection('expensesCategory')
        .snapshots()
        .forEach((eventTwo) {
      eventTwo.docs.forEach((element) {
        cats.add(
            {'name': element.data()['name'], 'total': 0, 'id': element.id});
      });
    }).timeout(Duration(seconds: 2), onTimeout: calculate1);
  }

  caleculateProfit() {
    FirebaseFirestore.instance
        .collection("orders")
        .orderBy("date", descending: true)
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        setState(() {
          income += element['total'];
        });
      });
    });
  }

  @override
  void initState() {
    calculate();
    caleculateProfit();
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        NeumorphicText(
                          "Nashwan Sabri",
                          textStyle: NeumorphicTextStyle(fontSize: 16),
                          style: NeumorphicStyle(color: Colors.black),
                        ),
                        // Container(
                        //     width: 75,
                        //     height: 75,
                        //     child: Image.asset('images/logo.jpg'))
                      ],
                    ),
                  )),
              Expanded(
                  flex: 7,
                  child: Center(
                    child: Container(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemCount: classes.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => classesName[index]));
                            },
                            child: Padding(
                              padding: EdgeInsets.all(25.0),
                              child: Neumorphic(
                                child: Center(
                                  child: Container(
                                      child: NeumorphicText(
                                        classes[index],
                                        style: NeumorphicStyle(color: Colors.black),
                                      )),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Neumorphic(
                            style:
                            NeumorphicStyle(shadowDarkColor: Colors.green),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  NeumorphicText(
                                    "Income",
                                    textStyle:
                                    NeumorphicTextStyle(fontSize: 16),
                                    style: NeumorphicStyle(color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Countup(
                                    begin: 0,
                                    end: income.toDouble(),
                                    duration: Duration(seconds: 3),
                                    separator: ',',
                                    suffix: "  IQD",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Neumorphic(
                            style: NeumorphicStyle(shadowDarkColor: Colors.red),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  NeumorphicText(
                                    "Expenses",
                                    textStyle:
                                    NeumorphicTextStyle(fontSize: 16),
                                    style: NeumorphicStyle(color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Countup(
                                    begin: 0,
                                    end: totalExpenses.toDouble(),
                                    duration: Duration(seconds: 3),
                                    separator: ',',
                                    suffix: "  IQD",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Neumorphic(
                            style:
                            NeumorphicStyle(shadowDarkColor: Colors.blue),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  NeumorphicText(
                                    "Profit",
                                    textStyle:
                                    NeumorphicTextStyle(fontSize: 16),
                                    style: NeumorphicStyle(color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Countup(
                                    begin: 0,
                                    end: (income - totalExpenses).toDouble(),
                                    duration: Duration(seconds: 3),
                                    separator: ',',
                                    suffix: "  IQD",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
