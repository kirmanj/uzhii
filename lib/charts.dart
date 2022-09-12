import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_util/date_util.dart';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Charts extends StatefulWidget {
  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  List<DocumentSnapshot> expenses;
  List<DocumentSnapshot> orders;
  int totalExpenses = 0;
  int totalOrders = 0;

  List<String> time = ['Daily', "Monthly", "Yearly"];
  String dropdownValue = 'Daily';
  String dropdownValueTwo = 'Income';
  List<String> reportType = ['Income', 'Expenses', 'Profit'];
  List<ExpensesDate> _chartDate;
  List<ExpensesDate> _orderDate;
  List<ExpensesDate> _monthlyOrderDate;
  List<ExpensesDate> _monthlyExpensesDate;
  List<ExpensesDate> _yearlyOrderDate;
  List<ExpensesDate> _yearlyExpensesDate;

  getProduct() {
    print("products");
    FirebaseFirestore.instance
        .collection('expenses')
        .snapshots()
        .listen((event) {
      setState(() {
        expenses = event.docs;

        _chartDate = dailyCalculate();
      });
    }).onDone(() {});

    FirebaseFirestore.instance.collection('orders').snapshots().listen((event) {
      setState(() {
        orders = event.docs;

        _orderDate = dailyCalculateOrder();
      });
    }).onDone(() {});
  }

  int maxOrder = 1000;
  yearlyCalculateOrder() {
    totalOrders = 0;

    List<ExpensesDate> data = [];
    List<Map> daily = [];

    for (int i = 0; i < 10; i++) {
      daily.add({"year": i + 21, "total": 0});
    }

    orders.forEach((element) {
      daily[-2021 + int.parse(element["date"].substring(6, 10))]['total'] +=
          element['total'];
    });

    daily.forEach((element) {
      maxOrder < element['total'] ? maxOrder = element['total'] : () {};
      data.add(ExpensesDate(
          element['year'].toString(), element['total'].toDouble()));

      setState(() {
        totalOrders += element['total'];
      });
    });

    return data;
  }

  monthlyCalculateOrder() {
    totalOrders = 0;
    List<ExpensesDate> data = [];
    var dateUtility = DateUtil();
    DateTime now = new DateTime.now();
    var day1 = dateUtility.daysInMonth(now.month, now.year);
    List<Map> daily = [];

                      for (int i = 0; i < 12; i++) {
                        daily.add(
                            {"month": DateFormat("MMM").format(DateTime(0, i + 1)), "total": 0});
                      }

                      orders.forEach((element) {
                        if (int.parse(element["date"].substring(6, 10)) == now.year) {
                          daily[int.parse(element["date"].substring(3, 5)) - 1]['total'] +=
                              element['total'];
                        }
                      });

    daily.forEach((element) {
      maxOrder < element['total'] ? maxOrder = element['total'] : () {};
      data.add(ExpensesDate(
          element['month'].toString(), element['total'].toDouble()));
      setState(() {
        totalOrders += element['total'];
      });
    });

    return data;
  }

  dailyCalculateOrder() {
    totalOrders = 0;
    List<ExpensesDate> data = [];
    var dateUtility = DateUtil();
    DateTime now = new DateTime.now();
    var day1 = dateUtility.daysInMonth(now.month, now.year);
    List<Map> daily = [];
    for (int i = 0; i < day1; i++) {
      daily.add({"day": i + 1, "total": 0});
    }

    orders.forEach((element) {
      if (int.parse(element["date"].substring(3, 5)) == now.month) {
        daily[int.parse(element["date"].substring(0, 2)) - 1]['total'] +=
            element['total'];
      }
    });

    daily.forEach((element) {
      maxOrder < element['total'] ? maxOrder = element['total'] : () {};
      data.add(
          ExpensesDate(element['day'].toString(), element['total'].toDouble()));
      setState(() {
        totalOrders += element['total'];
      });
    });
    return data;
  }

  int maxExpens = 1000;
  yearlyCalculateExpenses() {
    totalExpenses = 0;
    List<ExpensesDate> data = [];
    List<Map> daily = [];

    for (int i = 0; i < 10; i++) {
      daily.add({"year": i + 21, "total": 0});
    }

    expenses.forEach((element) {
      print(int.parse(element["date"].substring(0, 4)));

      print(-2021 + int.parse(element["date"].substring(0, 4)));
      print("int.parse(element[" "].substring(6, 10))");
      daily[-2021 + int.parse(element["date"].substring(0, 4))]['total'] +=
          element['price'];
      print(element['price']);
    });

    print(daily);

    daily.forEach((element) {
      maxExpens < element['total'] ? maxExpens = element['total'] : () {};
      data.add(ExpensesDate(
          element['year'].toString(), element['total'].toDouble()));
      setState(() {
        totalExpenses += element['total'];
      });
    });

    return data;
  }

  dailyCalculate() {
    totalExpenses = 0;
    List<ExpensesDate> data = [];
    var dateUtility = DateUtil();
    DateTime now = new DateTime.now();
    var day1 = dateUtility.daysInMonth(now.month, now.year);
    List<Map> daily = [];
    for (int i = 0; i < day1; i++) {
      daily.add({"day": i + 1, "total": 0});
    }

    expenses.forEach((element) {
      if (int.parse(element["date"].substring(5, 7)) == now.month) {
        daily[int.parse(element["date"].substring(8, 10)) - 1]['total'] +=
            element['price'];
      }
    });

    daily.forEach((element) {
      maxExpens < element['total'] ? maxExpens = element['total'] : () {};
      data.add(
          ExpensesDate(element['day'].toString(), element['total'].toDouble()));
      setState(() {
        totalExpenses += element['total'];
      });
    });

    return data;
  }

  monthlyCalculateExpenses() {
    totalExpenses = 0;
    List<ExpensesDate> data = [];
    DateTime now = new DateTime.now();
    List<Map> daily = [];

    for (int i = 0; i < 12; i++) {
      daily.add(
          {"month": DateFormat("MMM").format(DateTime(0, i + 1)), "total": 0});
    }

    expenses.forEach((element) {
      if (int.parse(element["date"].substring(0, 4)) == now.year) {
        daily[int.parse(element["date"].substring(5, 7)) - 1]['total'] +=
            element['price'];
      }
    });

    daily.forEach((element) {
      maxExpens < element['total'] ? maxExpens = element['total'] : () {};
      data.add(ExpensesDate(
          element['month'].toString(), element['total'].toDouble()));
      setState(() {
        totalExpenses += element['total'];
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
                        DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Color.fromRGBO(23, 25, 95, 1),
                          ),
                          elevation: 3,
                          onChanged: (String newValue) {
                            if (newValue == "Monthly") {
                              setState(() {
                                _monthlyExpensesDate =
                                    monthlyCalculateExpenses();
                                _monthlyOrderDate = monthlyCalculateOrder();
                              });
                            }
                            if (newValue == "Yearly") {
                              setState(() {
                                _yearlyExpensesDate =
                                    yearlyCalculateExpenses();
                                _yearlyOrderDate = yearlyCalculateOrder();
                              });
                            }

                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          dropdownColor: Colors.white,
                          items: time.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(23, 25, 95, 1)),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 4,
                  child: Center(
                    child: expenses == null
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                  shadowDarkColor: Colors.green),
                              child: Container(
                                child: dropdownValue == "Daily"
                                    ? SfCartesianChart(
                                        title: ChartTitle(
                                            text: 'Income Chart: ' +
                                                totalOrders.toString()),
                                        primaryXAxis: CategoryAxis(),
                                        primaryYAxis: NumericAxis(
                                            minimum: 0,
                                            maximum: maxOrder.toDouble() + 1000,
                                            interval: maxOrder / 8),
                                        series: <
                                            ChartSeries<ExpensesDate, String>>[
                                            ColumnSeries<ExpensesDate, String>(
                                                dataSource: _orderDate,
                                                xValueMapper:
                                                    (ExpensesDate data, _) =>
                                                        data.x,
                                                yValueMapper:
                                                    (ExpensesDate data, _) =>
                                                        data.y)
                                          ])
                                    : dropdownValue == "Yearly"
                                        ? SfCartesianChart(
                                            title: ChartTitle(
                                                text: 'Income Chart: ' +
                                                    totalOrders.toString()),
                                            primaryXAxis: CategoryAxis(),
                                            primaryYAxis: NumericAxis(
                                                minimum: 0,
                                                maximum:
                                                    maxOrder.toDouble() + 1000,
                                                interval: maxOrder / 8),
                                            series: <
                                                ChartSeries<ExpensesDate,
                                                    String>>[
                                                ColumnSeries<ExpensesDate,
                                                        String>(
                                                    dataSource:
                                                        _yearlyOrderDate,
                                                    xValueMapper:
                                                        (ExpensesDate data,
                                                                _) =>
                                                            data.x,
                                                    yValueMapper:
                                                        (ExpensesDate data,
                                                                _) =>
                                                            data.y)
                                              ])
                                        : SfCartesianChart(
                                            title: ChartTitle(
                                                text: 'Income Chart: ' +
                                                    totalOrders.toString()),
                                            primaryXAxis: CategoryAxis(),
                                            primaryYAxis: NumericAxis(
                                                minimum: 0,
                                                maximum:
                                                    maxOrder.toDouble() + 1000,
                                                interval: maxOrder / 8),
                                            series: <
                                                ChartSeries<ExpensesDate,
                                                    String>>[
                                                ColumnSeries<ExpensesDate,
                                                        String>(
                                                    dataSource:
                                                        _monthlyOrderDate,
                                                    xValueMapper:
                                                        (ExpensesDate data,
                                                                _) =>
                                                            data.x,
                                                    yValueMapper:
                                                        (ExpensesDate data,
                                                                _) =>
                                                            data.y)
                                              ]),
                              ),
                            ),
                          ),
                  )),
              Expanded(
                  flex: 4,
                  child: Center(
                    child: expenses == null
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Neumorphic(
                              style:
                                  NeumorphicStyle(shadowDarkColor: Colors.red),
                              child: Container(
                                child: dropdownValue == "Daily"
                                    ? SfCartesianChart(
                                        title: ChartTitle(
                                            text: 'Expenses Chart: ' +
                                                totalExpenses.toString()),
                                        primaryXAxis: CategoryAxis(),
                                        primaryYAxis: NumericAxis(
                                            minimum: 0,
                                            maximum:
                                                maxExpens.toDouble() + 1000,
                                            interval: maxExpens / 8),
                                        series: <
                                            ChartSeries<ExpensesDate, String>>[
                                            ColumnSeries<ExpensesDate, String>(
                                                dataSource: _chartDate,
                                                xValueMapper:
                                                    (ExpensesDate data, _) =>
                                                        data.x,
                                                yValueMapper:
                                                    (ExpensesDate data, _) =>
                                                        data.y)
                                          ])
                                    : dropdownValue == "Yearly"
                                        ? SfCartesianChart(
                                            title: ChartTitle(
                                                text: 'Expenses Chart: ' +
                                                    totalExpenses.toString()),
                                            primaryXAxis: CategoryAxis(),
                                            primaryYAxis: NumericAxis(
                                                minimum: 0,
                                                maximum:
                                                    maxExpens.toDouble() + 1000,
                                                interval: maxExpens / 8),
                                            series: <
                                                ChartSeries<ExpensesDate,
                                                    String>>[
                                                ColumnSeries<ExpensesDate,
                                                        String>(
                                                    dataSource:
                                                        _yearlyExpensesDate,
                                                    xValueMapper:
                                                        (ExpensesDate data,
                                                                _) =>
                                                            data.x,
                                                    yValueMapper:
                                                        (ExpensesDate data,
                                                                _) =>
                                                            data.y)
                                              ])
                                        : SfCartesianChart(
                                            title: ChartTitle(
                                                text: 'Expenses Chart: ' +
                                                    totalExpenses.toString()),
                                            primaryXAxis: CategoryAxis(),
                                            primaryYAxis: NumericAxis(
                                                minimum: 0,
                                                maximum:
                                                    maxExpens.toDouble() + 1000,
                                                interval: maxExpens / 8),
                                            series: <
                                                ChartSeries<ExpensesDate,
                                                    String>>[
                                                ColumnSeries<ExpensesDate,
                                                        String>(
                                                    dataSource:
                                                        _monthlyExpensesDate,
                                                    xValueMapper:
                                                        (ExpensesDate data,
                                                                _) =>
                                                            data.x,
                                                    yValueMapper:
                                                        (ExpensesDate data,
                                                                _) =>
                                                            data.y)
                                              ]),
                              ),
                            ),
                          ),
                  )),
              Expanded(
                  flex: 1,
                  child: Center(
                    child: expenses == null
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Neumorphic(
                              style:
                                  NeumorphicStyle(shadowDarkColor: Colors.blue),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  child: NeumorphicText(
                                    "Income : " +
                                        (totalOrders - totalExpenses)
                                            .toStringAsFixed(1) +
                                        "  IQD",
                                    textStyle:
                                        NeumorphicTextStyle(fontSize: 16),
                                    style: NeumorphicStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  )),
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
