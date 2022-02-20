import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

class Reposts extends StatefulWidget {
  int state;
  Reposts({this.state});
  @override
  _RepostsState createState() => _RepostsState(state: state);
}

class _RepostsState extends State<Reposts> {
  int state;
  _RepostsState({this.state});
  var now_1w;
  var now_1m;
  var now;
  var now_1y;
  bool isYearly = true;
  int todayP = 0;
  int lastWeek = 0;
  int lastYear = 0;
  int lastMonth = 0;

  List<Map> monthlyProfit = [
    {
      "month": "Feb",
      "profit": 0,
    },
    {
      "month": "Jan",
      "profit": 0,
    },
    {
      "month": "Mar",
      "profit": 0,
    },
    {
      "month": "Apr",
      "profit": 0,
    },
    {
      "month": "May",
      "profit": 0,
    },
    {
      "month": "Jun",
      "profit": 0,
    },
    {
      "month": "Jul",
      "profit": 0,
    },
    {
      "month": "Aug",
      "profit": 0,
    },
    {
      "month": "Sep",
      "profit": 0,
    },
    {
      "month": "Oct",
      "profit": 0,
    },
    {
      "month": "Nov",
      "profit": 0,
    },
    {
      "month": "Dec",
      "profit": 0,
    }
  ];
  List<Map> yearlyProfit = [
    {
      "month": "2021",
      "profit": 0,
    },
    {
      "month": "2022",
      "profit": 0,
    },
    {
      "month": "2023",
      "profit": 0,
    },
    {
      "month": "2024",
      "profit": 0,
    },
    {
      "month": "2025",
      "profit": 0,
    },
    {
      "month": "2026",
      "profit": 0,
    },
    {
      "month": "2027",
      "profit": 0,
    },
    {
      "month": "2028",
      "profit": 0,
    },
    {
      "month": "2029",
      "profit": 0,
    },
    {
      "month": "2030",
      "profit": 0,
    },
    {
      "month": "2031",
      "profit": 0,
    },
    {
      "month": "2032",
      "profit": 0,
    }
  ];

  double monthlyTotal = 0;
  double yearlyTotal = 0;
  getData() {
    FirebaseFirestore.instance
        .collection('invoice')
        .where("state", isEqualTo: 1)
        .get()
        .then((value) {
      now = new DateTime.now();

      now_1w = now.subtract(Duration(days: 7));
      now_1m = new DateTime(now.year, now.month - 1, now.day);
      now_1y = new DateTime(now.year - 1, now.month, now.day);
      todayP = 0;
      lastWeek = 0;
      lastMonth = 0;
      monthlyTotal = 0;
      lastYear = 0;
      yearlyTotal = 0;

      value.docs.forEach((element) {
        if (element["sellingDate"] == DateFormat('dd-MM-yyyy').format(now)) {
          setState(() {
            todayP += (element['totalI'] - element['totalBuy']).toInt();
          });
        }
        if (now_1w
            .isBefore(DateFormat("dd-MM-yyyy").parse(element["sellingDate"]))) {
          setState(() {
            lastWeek += (element['totalI'] - element['totalBuy']).toInt();
          });
        }
        if (now_1m
            .isBefore(DateFormat("dd-MM-yyyy").parse(element["sellingDate"]))) {
          setState(() {
            lastMonth += (element['totalI'] - element['totalBuy']).toInt();
          });
        }
        if (now_1y
            .isBefore(DateFormat("dd-MM-yyyy").parse(element["sellingDate"]))) {
          setState(() {
            lastYear += (element['totalI'] - element['totalBuy']).toInt();
          });
        }

        print(DateFormat("dd-MM-yyyy").parse(element["sellingDate"]).year ==
            DateTime.now().year);
        print((element['totalI'] - element['totalBuy']).toInt());
        print(element["sellingDate"]);

        if (DateFormat("dd-MM-yyyy").parse(element["sellingDate"]).year ==
            DateTime.now().year) {
          setState(() {
            monthlyProfit[DateFormat("dd-MM-yyyy")
                        .parse(element["sellingDate"])
                        .month -
                    1]['profit'] +=
                (element['totalI'] - element['totalBuy']).toInt();

            monthlyTotal += (element['totalI'] - element['totalBuy']);
            print(monthlyTotal.toString());
          });
        } else {}

        setState(() {
          yearlyProfit[
                  DateFormat("dd-MM-yyyy").parse(element["sellingDate"]).year -
                      2020]['profit'] +=
              (element['totalI'] - element['totalBuy']).toInt();

          yearlyTotal += (element['totalI'] - element['totalBuy']);
          print(monthlyTotal.toString());
        });
      });
    });
  }

  int indexMax = 0;
  List costumerNo = [];
  int max;
  List<Map> customers = [];
  getCustomers() {
    FirebaseFirestore.instance
        .collection('invoice')
        .where("state", isEqualTo: 1)
        .get()
        .then((value) {
      customers.clear();
      costumerNo.clear();
      value.docs.forEach((element) {
        if (costumerNo.contains(element['phoneNo1'])) {
        } else {
          costumerNo.add(element['phoneNo1']);

          double total = 0;
          String name = "";
          FirebaseFirestore.instance
              .collection('invoice')
              .where("phoneNo1", isEqualTo: element['phoneNo1'])
              .get()
              .then((value) {
            name = element['CustomerName'];
            value.docs.forEach((element) {
              total += (element['totalI'] - element['totalBuy']);
            });
          }).whenComplete(() {
            customers.add({
              'name': name,
              'phone': element['phoneNo1'],
              'total': total,
            });
            setState(() {
              customers = customers;
            });
          });
        }
      });
    }).whenComplete(() {});
  }

  @override
  void initState() {
    now = new DateTime.now();

    now_1w = now.subtract(Duration(days: 7));
    now_1m = new DateTime(now.year, now.month - 1, now.day);
    now_1y = new DateTime(now.year - 1, now.month, now.day);

    getData();
    getCustomers();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Stack(
          children: [
            state == 0
                ? Container(
                    height: height,
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NeumorphicButton(
                          child: Text(
                            "    Profits   ",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              state = 1;
                            });
                          },
                          style: NeumorphicStyle(
                              color: Color.fromRGBO(235, 118, 189, 1)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        NeumorphicButton(
                          child: Text(
                            "Costumers",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              state = 2;
                              getCustomers();
                            });
                          },
                          style: NeumorphicStyle(
                              color: Color.fromRGBO(235, 118, 189, 1)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        NeumorphicButton(
                          child: Text(
                            "  Products  ",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              state = 3;
                            });
                          },
                          style: NeumorphicStyle(
                              color: Color.fromRGBO(235, 118, 189, 1)),
                        )
                      ],
                    ),
                  )
                : state == 1
                    ? Container(
                        width: width,
                        height: height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * 0.05,
                            ),
                            Text(
                              "Profits",
                              style: TextStyle(
                                  color: Color.fromRGBO(235, 118, 189, 1),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Neumorphic(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: width * 0.9,
                                color: Color.fromRGBO(235, 118, 189, 1),
                                child: Text(
                                  "Today:            " +
                                      todayP.toString().replaceAllMapped(
                                          RegExp(
                                              r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                          (Match m) => '${m[1]},') +
                                      " IQD",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Neumorphic(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: width * 0.9,
                                color: Color.fromRGBO(235, 118, 189, 1),
                                child: Text(
                                  "This Week:    " +
                                      lastWeek.toString().replaceAllMapped(
                                          RegExp(
                                              r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                          (Match m) => '${m[1]},') +
                                      " IQD",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Neumorphic(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: width * 0.9,
                                color: Color.fromRGBO(235, 118, 189, 1),
                                child: Text(
                                  "This Month:    " +
                                      lastMonth.toString().replaceAllMapped(
                                          RegExp(
                                              r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                          (Match m) => '${m[1]},') +
                                      " IQD",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Neumorphic(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: width * 0.9,
                                color: Color.fromRGBO(235, 118, 189, 1),
                                child: Text(
                                  "This Year:    " +
                                      lastYear.toString().replaceAllMapped(
                                          RegExp(
                                              r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                          (Match m) => '${m[1]},') +
                                      " IQD",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.001,
                            ),
                            Container(
                              height: height * 0.57,
                              child: ListView.builder(
                                  itemCount: 12,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Container(
                                        width: width * 0.1,
                                        color: Colors.white,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            isYearly
                                                ? Container(
                                                    width: width * 0.1,
                                                    child: Text(
                                                      monthlyProfit[index]
                                                          ['month'],
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              235,
                                                              118,
                                                              189,
                                                              1)),
                                                    ))
                                                : Container(
                                                    width: width * 0.1,
                                                    child: Text(
                                                      yearlyProfit[index]
                                                          ['month'],
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              235,
                                                              118,
                                                              189,
                                                              1)),
                                                    ),
                                                  ),
                                            isYearly
                                                ? Neumorphic(
                                                    style: NeumorphicStyle(
                                                        color: Color.fromRGBO(
                                                            235, 118, 189, 1)),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: Container(
                                                          width: monthlyProfit[index]['profit'] == 0
                                                              ? width * 0.1
                                                              : (((width * 0.6) *
                                                                  ((monthlyProfit[index]['profit'] /
                                                                      monthlyTotal)))),
                                                          color: Color.fromRGBO(
                                                              235, 118, 189, 1),
                                                          child: Text(
                                                              monthlyProfit[index]['profit'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},') +
                                                                  " IQD",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white))),
                                                    ),
                                                  )
                                                : Neumorphic(
                                                    style: NeumorphicStyle(
                                                        color: Color.fromRGBO(
                                                            235, 118, 189, 1)),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: Container(
                                                          width: yearlyProfit[index]['profit'] == 0
                                                              ? width * 0.1
                                                              : (((width * 0.6) *
                                                                  ((yearlyProfit[index]['profit'] /
                                                                          yearlyTotal) +
                                                                      0.1))),
                                                          color: Color.fromRGBO(
                                                              235, 118, 189, 1),
                                                          child: Text(
                                                              yearlyProfit[index]['profit']
                                                                      .toString()
                                                                      .replaceAllMapped(
                                                                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                                          (Match m) => '${m[1]},') +
                                                                  " IQD",
                                                              style: TextStyle(fontSize: 12, color: Colors.white))),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                NeumorphicButton(
                                  onPressed: () {
                                    setState(() {
                                      isYearly = !isYearly;
                                    });
                                  },
                                  style: NeumorphicStyle(
                                      color: isYearly
                                          ? Colors.white
                                          : Color.fromRGBO(235, 118, 189, 1)),
                                  child: Text("Yearly",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: !isYearly
                                              ? Colors.white
                                              : Color.fromRGBO(
                                                  235, 118, 189, 1))),
                                ),
                                NeumorphicButton(
                                  onPressed: () {
                                    setState(() {
                                      isYearly = !isYearly;
                                    });
                                  },
                                  style: NeumorphicStyle(
                                      color: !isYearly
                                          ? Colors.white
                                          : Color.fromRGBO(235, 118, 189, 1)),
                                  child: Text("Monthly",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: isYearly
                                              ? Colors.white
                                              : Color.fromRGBO(
                                                  235, 118, 189, 1))),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    : state == 2
                        ? Container(
                            width: width,
                            height: height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: height * 0.05,
                                ),
                                Text(
                                  "Costumers",
                                  style: TextStyle(
                                      color: Color.fromRGBO(235, 118, 189, 1),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  height: height * 0.8,
                                  child: customers.length == 0
                                      ? Container()
                                      : ListView.builder(
                                          itemCount: customers.length,
                                          itemBuilder: (context, index) {
                                            int max = 0;

                                            for (int i = 0;
                                                i < customers.length;
                                                i++) {
                                              print(customers[i]['total']);
                                              if (customers[i]['total'] > max) {
                                                max = customers[i]['total']
                                                    .toInt();
                                                indexMax = i;
                                                print(indexMax);
                                              }
                                            }
                                            return Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Container(
                                                color: Color.fromRGBO(
                                                    235, 118, 189, 1),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(4.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Text(
                                                            customers[index]
                                                                ['name'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            customers[index]
                                                                ['phone'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            customers[index][
                                                                        'total']
                                                                    .toString()
                                                                    .replaceAllMapped(
                                                                        RegExp(
                                                                            r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                                        (Match m) =>
                                                                            '${m[1]},') +
                                                                " IQD",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          indexMax != index
                                                              ? Container()
                                                              : Icon(
                                                                  Icons.star,
                                                                  size: 18,
                                                                  color: Colors
                                                                      .yellow,
                                                                )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                )
                              ],
                            ),
                          )
                        : Container(
                            width: width,
                            height: height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Products",
                                  style: TextStyle(
                                    color: Color.fromRGBO(235, 118, 189, 1),
                                  ),
                                )
                              ],
                            ),
                          ),
            state == 0
                ? Positioned(
                    top: 25,
                    left: 5,
                    child: NeumorphicButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: NeumorphicStyle(shadowDarkColor: Colors.grey[200]),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 14,
                        color: Color.fromRGBO(235, 118, 189, 1),
                      ),
                    ),
                  )
                : Positioned(
                    top: 25,
                    left: 5,
                    child: NeumorphicButton(
                      onPressed: () {
                        setState(() {
                          state = 0;
                          // getData();
                        });
                      },
                      style: NeumorphicStyle(shadowDarkColor: Colors.grey[200]),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 14,
                        color: Color.fromRGBO(235, 118, 189, 1),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
