import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:uzhii/Posts.dart';

class SellScreen extends StatefulWidget {
  String postId;

  SellScreen({this.postId});
  @override
  _SellScreenState createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  List<DocumentSnapshot> productsSnapshot;
  List<Map> products = [];
  List<Map> productsSell = [];
  bool noteFlage = true;
  List<String> productString;
  double curency = 0;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNo1 = TextEditingController();
  TextEditingController _note = TextEditingController();
  TextEditingController _phoneNo2 = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _editPrice = TextEditingController();
  double reciprocal(double d) => d / 1;
  getCurency() {
    FirebaseFirestore.instance
        .collection('curency')
        .snapshots()
        .listen((dataSnapshot) {
      DocumentSnapshot temp = dataSnapshot.docs[0];

      setState(() {
        curency = reciprocal(temp['euro'].toDouble());
      });
    });
  }

  int productQuantity = 0;
  var timer;
  double totalP = 0;

  String dropdownValue = "0";

  double totalPrice = 0;
  double discountPrice = 0;

  Map post;
  Map sell;
  int productTotal = 0;

  getPost() {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.postId)
        .snapshots()
        .listen((event) {
      setState(() {
        code = event.data()['code'];
        post = {
          'code': event.data()['code'],
          'postBenifit': event.data()['code'],
          'products': event.data()['products'],
          'state': event.data()['state'],
          'totalI': event.data()['totalI'],
          'totalP': event.data()['totalP'],
          'noOfProducts': event.data()['noOfProducts'],
          'sendingDate': event.data()['sendingDate'],
          'arrivingDate': event.data()['arrivingDate'],
          'soldOutDate': event.data()['soldOutDate'],
        };
        sell = {
          'products': event.data()['products'],
        };

        sell['products'].forEach((e) {
          setState(() {
            e["quantity"] = 0;
            e["code"] = code;
          });
        });
      });
    });
  }

  String formattedDate = "";
  @override
  void initState() {
    getCurency();

    getPost();
    DateTime now = new DateTime.now();
    setState(() {
      formattedDate = DateFormat('dd-MM-yyyy').format(now);
    });

    super.initState();
  }

  // void dispose() {
  //   timer.cancel();
  //   super.dispose();
  // }

  bool send = false;

  bool addMore = false;
  int code;
  List codes = [];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "     SELLING  :  ${addMore ? "" : (code == null) ? "" : code.toString()}",
                  style: TextStyle(
                      fontSize: 20, color: Color.fromRGBO(23, 25, 95, 1)),
                ),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.note_add_outlined,
                            color: Color.fromRGBO(23, 25, 95, 1)),
                        onPressed: () {
                          setState(() {
                            noteFlage = !noteFlage;
                          });
                        }),
                    IconButton(
                        icon: Icon(Icons.add_circle,
                            size: 24, color: Color.fromRGBO(23, 25, 95, 1)),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('code')
                              .get()
                              .then((value) {
                            code = value.docs[0].data()['code'];
                          }).whenComplete(() {
                            FirebaseFirestore.instance
                                .collection('posts')
                                .get()
                                .then((proVal) {
                              int lastCode = code - (proVal.docs.length - 1);
                              codes = [];
                              for (code; code >= lastCode; code--) {
                                codes.add(code);
                              }
                            }).whenComplete(() {
                              setState(() {
                                codes = codes;
                                addMore = !addMore;
                              });
                            });
                          });
                        })
                  ],
                )
              ],
            ),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: Color.fromRGBO(23, 25, 95, 1)),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: SafeArea(
          child: Container(
              height: height,
              child: Stack(
                children: [
                  send
                      ? Container(
                          height: height,
                          child: Column(
                            children: [
                              Container(
                                height: height * 0.2,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Customer Name: " +
                                                _nameController.text,
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(23, 25, 95, 1),
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Phone Number1: " + _phoneNo1.text,
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(23, 25, 95, 1),
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Phone Number2: " + _phoneNo2.text,
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(23, 25, 95, 1),
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Date: " + formattedDate,
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(23, 25, 95, 1),
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: height * 0.06,
                                            child: Text(
                                              "Address: ",
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    23, 25, 95, 1),
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Flexible(
                                            child: Container(
                                              height: height * 0.06,
                                              child: Text(
                                                _address.text,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      23, 25, 95, 1),
                                                  fontSize: 16,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  height: height * 0.4,
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: sell["products"].length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return (sell["products"][index]
                                                    ['quantity'] ==
                                                0)
                                            ? Container()
                                            : Container(
                                                height: height * 0.08,
                                                padding: EdgeInsets.only(
                                                    left: width * 0.02,
                                                    bottom: height * 0.01,
                                                    right: width * 0.02),
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                    left: width * 0.02,
                                                  ),
                                                  child: Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          height: 18,
                                                          child: Text(
                                                            sell["products"]
                                                                [index]["name"],
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        23,
                                                                        25,
                                                                        95,
                                                                        1),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 20,
                                                          child: Text(
                                                            sell["products"][
                                                                            index]
                                                                        [
                                                                        "price"]
                                                                    .toStringAsFixed(
                                                                        1) +
                                                                " Ld     " +
                                                                sell["products"]
                                                                            [
                                                                            index]
                                                                        [
                                                                        "priceI"]
                                                                    .toStringAsFixed(
                                                                        1) +
                                                                "  IQD  " +
                                                                "  Quantity  " +
                                                                sell["products"]
                                                                            [
                                                                            index]
                                                                        [
                                                                        "quantity"]
                                                                    .toString() +
                                                                "     Code  " +
                                                                sell["products"]
                                                                            [
                                                                            index]
                                                                        ["code"]
                                                                    .toString(),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      23,
                                                                      25,
                                                                      95,
                                                                      1),
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                      })),
                              Container(
                                width: width * 0.7,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      child: Text(
                                        "Discount Amount: ",
                                        style: TextStyle(
                                          color: Color.fromRGBO(23, 25, 95, 1),
                                        ),
                                      ),
                                    ),
                                    DropdownButton<String>(
                                      value: dropdownValue,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Color.fromRGBO(23, 25, 95, 1),
                                      ),
                                      elevation: 16,
                                      onChanged: (newValue) {
                                        setState(() {
                                          dropdownValue = newValue;

                                          discountPrice = totalPrice -
                                              (totalPrice *
                                                  (int.parse(dropdownValue) /
                                                      100));
                                        });
                                      },
                                      dropdownColor: Colors.white,
                                      items: [
                                        "0",
                                        "10",
                                        "20",
                                        "30",
                                        "40",
                                        "50",
                                        "60",
                                        "70",
                                        "80",
                                        "90",
                                        "100"
                                      ].map<DropdownMenuItem<String>>((value) {
                                        return DropdownMenuItem(
                                          value: value.toString(),
                                          child: Text(
                                            value.toString() + " %",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    23, 25, 95, 1)),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              Neumorphic(
                                child: Container(
                                    height: height * 0.1,
                                    color: Color.fromRGBO(23, 25, 95, 1),
                                    width: width * 0.8,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      "Total: ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        child: (totalPrice
                                                                    .toString() ==
                                                                'null')
                                                            ? Text(
                                                                "0" + " IQD",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            : Text(
                                                                totalPrice.toStringAsFixed(1).replaceAllMapped(
                                                                        RegExp(
                                                                            r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                                        (Match m) =>
                                                                            '${m[1]},') +
                                                                    " IQD",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        (dropdownValue !=
                                                                                "0")
                                                                            ? 10
                                                                            : 18,
                                                                    decoration: (dropdownValue ==
                                                                            "0")
                                                                        ? null
                                                                        : TextDecoration
                                                                            .lineThrough,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                      ),
                                                      (dropdownValue == "0")
                                                          ? Container()
                                                          : Container(
                                                              child: Text(
                                                              discountPrice
                                                                      .toStringAsFixed(
                                                                          1)
                                                                      .replaceAllMapped(
                                                                          RegExp(
                                                                              r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                                          (Match m) =>
                                                                              '${m[1]},') +
                                                                  " IQD",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Quantity: ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  productTotal.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      15.0) //                 <--- border radius here
                                                  ),
                                              border: Border.all(
                                                  color: Colors.white)),
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  send = !send;
                                                });
                                              }),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      15.0) //                 <--- border radius here
                                                  ),
                                              border: Border.all(
                                                  color: Colors.white)),
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.done,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                final List<dynamic> sellingP =
                                                    sell['products'];
                                                double totalbenifit = 0;
                                                double newTotalB = 0;
                                                sellingP.removeWhere(
                                                    (dynamic value) =>
                                                        value["quantity"] == 0);

                                                for (int i = 0;
                                                    i < sellingP.length;
                                                    i++) {
                                                  FirebaseFirestore.instance
                                                      .collection("products")
                                                      .get()
                                                      .then((value) {
                                                    for (var element
                                                        in value.docs) {
                                                      if (element['name'] ==
                                                          sellingP[i]['name']) {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'products')
                                                            .doc(element.id)
                                                            .update({
                                                          "quantity": element[
                                                                  'quantity'] -
                                                              sellingP[i]
                                                                  ['quantity']
                                                        });
                                                        break;
                                                      }
                                                    }
                                                  });
                                                }
                                                double finalTotal;

                                                if (dropdownValue == "0") {
                                                  finalTotal = totalPrice;
                                                } else {
                                                  finalTotal = discountPrice;
                                                }

                                                FirebaseFirestore.instance
                                                    .collection('posts')
                                                    .where('code',
                                                        isEqualTo: post['code'])
                                                    .get()
                                                    .then((value) {
                                                  value.docs[0]
                                                      .data()['products']
                                                      .forEach((element) {
                                                    int i = 0;
                                                    sellingP.forEach((sellEle) {
                                                      if (element['name'] ==
                                                          sellEle['name']) {
                                                        sellingP[i]['benifit'] =
                                                            sellEle['priceI'] -
                                                                element[
                                                                    'priceI'];

                                                        totalbenifit += (sellEle[
                                                                    'priceI'] -
                                                                element[
                                                                    'priceI']) *
                                                            sellEle['quantity'];
                                                        newTotalB += element[
                                                                'priceI'] *
                                                            sellEle['quantity'];

                                                        i++;
                                                      }
                                                    });
                                                  });
                                                }).whenComplete(() {
                                                  FirebaseFirestore.instance
                                                      .collection('invoice')
                                                      .doc()
                                                      .set({
                                                    'CustomerName':
                                                        _nameController.text,
                                                    "postID": widget.postId,
                                                    'phoneNo1': _phoneNo1.text,
                                                    'phoneNo2': _phoneNo2.text,
                                                    'address': _address.text,
                                                    'productSell': sellingP,
                                                    'totalCI': totalPrice,
                                                    'totalDis': discountPrice,
                                                    'note': _note.text,
                                                    'totalBenifit':
                                                        totalbenifit,
                                                    'totalBuy': newTotalB,
                                                    'profit': 0,
                                                    'state': 0,
                                                    'totalI': finalTotal,
                                                    'totalP':
                                                        finalTotal / curency,
                                                    'noOfProducts':
                                                        productTotal,
                                                    'sellingDate':
                                                        formattedDate,
                                                  });

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (ctx) =>
                                                              Posts()));
                                                });
                                              }),
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  height: height * 0.25,
                                  padding: EdgeInsets.only(top: height * 0.01),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          NeumorphicText(
                                            "Customer Name",
                                            style: NeumorphicStyle(
                                              color:
                                                  Color.fromRGBO(23, 25, 95, 1),
                                            ),
                                          ),
                                          Container(
                                              width: width * 0.5,
                                              height: height * 0.04,
                                              child: Center(
                                                  child: TextFormField(
                                                keyboardType:
                                                    TextInputType.name,
                                                controller: _nameController,
                                                decoration: InputDecoration(
                                                  hintText: 'Name',
                                                  hintStyle: TextStyle(
                                                      color: Color.fromRGBO(
                                                          23, 25, 95, 1),
                                                      fontSize: 14),
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(20.0,
                                                          10.0, 20.0, 10.0),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0)),
                                                ),
                                              ))),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          NeumorphicText(
                                            "Phone Number 1",
                                            style: NeumorphicStyle(
                                              color:
                                                  Color.fromRGBO(23, 25, 95, 1),
                                            ),
                                          ),
                                          Container(
                                              width: width * 0.5,
                                              height: height * 0.04,
                                              child: Center(
                                                  child: TextFormField(
                                                keyboardType:
                                                    TextInputType.phone,
                                                controller: _phoneNo1,
                                                decoration: InputDecoration(
                                                  hintText: 'Phone Number',
                                                  hintStyle: TextStyle(
                                                      color: Color.fromRGBO(
                                                          23, 25, 95, 1),
                                                      fontSize: 14),
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(20.0,
                                                          10.0, 20.0, 10.0),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0)),
                                                ),
                                              ))),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          NeumorphicText(
                                            "Phone Number 2",
                                            style: NeumorphicStyle(
                                              color:
                                                  Color.fromRGBO(23, 25, 95, 1),
                                            ),
                                          ),
                                          Container(
                                              width: width * 0.5,
                                              height: height * 0.04,
                                              child: Center(
                                                  child: TextFormField(
                                                keyboardType:
                                                    TextInputType.phone,
                                                controller: _phoneNo2,
                                                decoration: InputDecoration(
                                                  hintText: 'Phone Number',
                                                  hintStyle: TextStyle(
                                                      color: Color.fromRGBO(
                                                          23, 25, 95, 1),
                                                      fontSize: 14),
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(20.0,
                                                          10.0, 20.0, 10.0),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0)),
                                                ),
                                              ))),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          NeumorphicText(
                                            "Customer Adress",
                                            style: NeumorphicStyle(
                                              color:
                                                  Color.fromRGBO(23, 25, 95, 1),
                                            ),
                                          ),
                                          Container(
                                              width: width * 0.5,
                                              height: height * 0.05,
                                              child: Center(
                                                  child: TextFormField(
                                                keyboardType:
                                                    TextInputType.name,
                                                controller: _address,
                                                decoration: InputDecoration(
                                                  hintText: 'Address',
                                                  hintStyle: TextStyle(
                                                      color: Color.fromRGBO(
                                                          23, 25, 95, 1),
                                                      fontSize: 14),
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(20.0,
                                                          10.0, 20.0, 10.0),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0)),
                                                ),
                                              ))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                (post == null)
                                    ? Container()
                                    : Container(
                                        height: height * 0.44,
                                        padding:
                                            EdgeInsets.only(top: height * 0.02),
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: post["products"].length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                height: height * 0.08,
                                                width: width * 0.95,
                                                padding: EdgeInsets.only(
                                                    left: width * 0.02,
                                                    bottom: height * 0.01,
                                                    right: width * 0.02),
                                                child: Neumorphic(
                                                  style: NeumorphicStyle(
                                                    color: Colors.white,
                                                  ),
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                      left: width * 0.02,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          width: width * 0.65,
                                                          child: (post["products"]
                                                                          [
                                                                          index]
                                                                      [
                                                                      "priceI"] ==
                                                                  0)
                                                              ? Container(
                                                                  width: width *
                                                                      0.5,
                                                                  height:
                                                                      height *
                                                                          0.04,
                                                                  child: Center(
                                                                      child:
                                                                          TextFormField(
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    controller:
                                                                        _editPrice,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      hintText:
                                                                          'Price',
                                                                      hintStyle: TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              23,
                                                                              25,
                                                                              95,
                                                                              1),
                                                                          fontSize:
                                                                              14),
                                                                      contentPadding: EdgeInsets.fromLTRB(
                                                                          20.0,
                                                                          10.0,
                                                                          20.0,
                                                                          10.0),
                                                                      border: OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.0)),
                                                                    ),
                                                                  )))
                                                              : Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      width: width *
                                                                          0.65,
                                                                      height:
                                                                          20,
                                                                      child:
                                                                          Text(
                                                                        post["products"][index]
                                                                            [
                                                                            "name"],
                                                                        overflow:
                                                                            TextOverflow.clip,
                                                                        style: TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                23,
                                                                                25,
                                                                                95,
                                                                                1),
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: width *
                                                                          0.65,
                                                                      height:
                                                                          20,
                                                                      child:
                                                                          Text(
                                                                        post["products"][index]["price"].toStringAsFixed(1) +
                                                                            " Ld     " +
                                                                            post["products"][index]["priceI"].toStringAsFixed(1) +
                                                                            "  IQD  ",
                                                                        overflow:
                                                                            TextOverflow.clip,
                                                                        style:
                                                                            TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              23,
                                                                              25,
                                                                              95,
                                                                              1),
                                                                        ),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                        ),
                                                        Container(
                                                          width: width * 0.25,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              (post["products"][
                                                                              index]
                                                                          [
                                                                          "priceI"] ==
                                                                      0)
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        if (_editPrice
                                                                            .text
                                                                            .isEmpty) {
                                                                        } else {
                                                                          setState(
                                                                              () {
                                                                            post["products"][index]["priceI"] =
                                                                                double.parse(_editPrice.text);

                                                                            post["products"][index]["price"] =
                                                                                (double.parse(_editPrice.text.toString()) / curency);
                                                                            sell["products"][index]["priceI"] =
                                                                                double.parse(_editPrice.text);

                                                                            sell["products"][index]["price"] =
                                                                                (double.parse(_editPrice.text.toString()) / curency);
                                                                          });
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .done,
                                                                          size:
                                                                              20,
                                                                          color: Color.fromRGBO(
                                                                              23,
                                                                              25,
                                                                              95,
                                                                              1),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          post["products"][index]["priceI"] =
                                                                              0;
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .edit,
                                                                          size:
                                                                              16,
                                                                          color: Color.fromRGBO(
                                                                              23,
                                                                              25,
                                                                              95,
                                                                              1),
                                                                        ),
                                                                      ),
                                                                    ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  if (productTotal ==
                                                                      0) {
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      post["products"]
                                                                              [
                                                                              index]
                                                                          [
                                                                          "quantity"]++;

                                                                      sell["products"]
                                                                              [
                                                                              index]
                                                                          [
                                                                          "quantity"]--;

                                                                      productTotal--;
                                                                      double
                                                                          temp1 =
                                                                          double.parse(
                                                                              post["products"][index]['priceI'].toString());

                                                                      totalPrice =
                                                                          totalPrice -
                                                                              temp1;
                                                                    });
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  child: Icon(
                                                                    Icons
                                                                        .remove,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            23,
                                                                            25,
                                                                            95,
                                                                            1),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  if (post["products"]
                                                                              [
                                                                              index]
                                                                          [
                                                                          "quantity"] ==
                                                                      0) {
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      post["products"]
                                                                              [
                                                                              index]
                                                                          [
                                                                          "quantity"]--;

                                                                      for (int i =
                                                                              0;
                                                                          i < sell["products"].length;
                                                                          i++) {
                                                                        if ((sell["products"][i]['name'] == post["products"][index]["name"]) &&
                                                                            (sell["products"][i]['code'] ==
                                                                                code)) {
                                                                          sell["products"][i]
                                                                              [
                                                                              "quantity"]++;
                                                                        }
                                                                      }

                                                                      productTotal++;
                                                                      double
                                                                          temp =
                                                                          double.parse(
                                                                              post["products"][index]['priceI'].toString());

                                                                      totalPrice =
                                                                          totalPrice +
                                                                              temp;
                                                                    });
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            23,
                                                                            25,
                                                                            95,
                                                                            1),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                Neumorphic(
                                  child: Container(
                                      height: height * 0.08,
                                      color: Color.fromRGBO(23, 25, 95, 1),
                                      width: width * 0.8,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  child: Text(
                                                    " Total: ",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Container(
                                                  child: (totalPrice
                                                              .toString() ==
                                                          'null')
                                                      ? Text(
                                                          "0" + " IQD",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      : Text(
                                                          totalPrice
                                                                  .toStringAsFixed(
                                                                      1)
                                                                  .replaceAllMapped(
                                                                      RegExp(
                                                                          r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                                      (Match m) =>
                                                                          '${m[1]},') +
                                                              " IQD",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Quantity: ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                productTotal.toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          Container(
                                            child: RotatedBox(
                                              quarterTurns: 3,
                                              child: IconButton(
                                                  icon: Icon(
                                                    Icons.send,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    if (_nameController
                                                            .text.isNotEmpty &&
                                                        _phoneNo1
                                                            .text.isNotEmpty &&
                                                        _address
                                                            .text.isNotEmpty) {
                                                      setState(() {
                                                        send = !send;
                                                      });
                                                    } else {}
                                                  }),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                  noteFlage
                      ? Container()
                      : Container(
                          height: height * 0.9,
                          width: width,
                          color: Color.fromRGBO(23, 25, 95, 0.8),
                          child: Center(
                            child: Neumorphic(
                              style: NeumorphicStyle(color: Colors.white),
                              child: Container(
                                  height: height * 0.5,
                                  width: width * 0.8,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Write Note",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(23, 25, 95, 1),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: height * 0.04,
                                      ),
                                      Container(
                                        width: width * 0.7,
                                        color: Colors.white,
                                        child: TextFormField(
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(23, 25, 95, 1),
                                          ),
                                          controller: _note,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 4,
                                          autofocus: false,
                                          decoration: InputDecoration(
                                              labelText: "Note",
                                              labelStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    23, 25, 95, 1),
                                              ),
                                              hintText: 'Note',
                                              hintStyle: TextStyle(
                                                  color: Color.fromRGBO(
                                                      23, 25, 95, 1)),
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      20.0, 10.0, 20.0, 10.0),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color.fromRGBO(
                                                        23, 25, 95, 1),
                                                    width: 0.0),
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.04,
                                      ),
                                      NeumorphicButton(
                                          child: Text(
                                            "Done",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              noteFlage = !noteFlage;
                                            });
                                          },
                                          style: NeumorphicStyle(
                                            color:
                                                Color.fromRGBO(23, 25, 95, 1),
                                          ))
                                    ],
                                  )),
                            ),
                          ),
                        ),
                  !addMore
                      ? Container()
                      : Container(
                          height: height * 0.9,
                          width: width,
                          color: Color.fromRGBO(23, 25, 95, 0.8),
                          child: Center(
                            child: Neumorphic(
                              style: NeumorphicStyle(color: Colors.white),
                              child: Container(
                                  height: height * 0.7,
                                  width: width * 0.8,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Choose Post Code",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(23, 25, 95, 1),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: height * 0.04,
                                      ),
                                      Container(
                                        width: width * 0.7,
                                        color: Colors.white,
                                        height: height * 0.5,
                                        child: GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3),
                                          itemCount: codes.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  FirebaseFirestore.instance
                                                      .collection("posts")
                                                        ..where('code',
                                                                isEqualTo:
                                                                    codes[
                                                                        index])
                                                            .snapshots()
                                                            .listen((event) {
                                                          setState(() {
                                                            code = codes[index];
                                                            post = {
                                                              'code':
                                                                  event.docs[0]
                                                                      ['code'],
                                                              'postBenifit':
                                                                  event.docs[0]
                                                                      ['code'],
                                                              'products': event
                                                                      .docs[0]
                                                                  ['products'],
                                                              'state':
                                                                  event.docs[0]
                                                                      ['state'],
                                                              'totalI': event
                                                                      .docs[0]
                                                                  ['totalI'],
                                                              'totalP': event
                                                                      .docs[0]
                                                                  ['totalP'],
                                                              'noOfProducts': event
                                                                      .docs[0][
                                                                  'noOfProducts'],
                                                              'sendingDate': event
                                                                      .docs[0][
                                                                  'sendingDate'],
                                                              'arrivingDate': event
                                                                      .docs[0][
                                                                  'arrivingDate'],
                                                              'soldOutDate': event
                                                                      .docs[0][
                                                                  'soldOutDate']
                                                            };

                                                            Map<dynamic,
                                                                    dynamic>
                                                                tempS = {
                                                              'products': event
                                                                      .docs[0]
                                                                  ['products'],
                                                            };

                                                            tempS['products']
                                                                .forEach((e) {
                                                              setState(() {
                                                                e["quantity"] =
                                                                    0;
                                                                e["code"] =
                                                                    code;
                                                                sell['products']
                                                                    .add(e);
                                                              });
                                                            });

                                                            addMore = !addMore;
                                                            !send
                                                                ? send
                                                                : send = !send;
                                                          });
                                                        });
                                                },
                                                child: Container(
                                                  child: Neumorphic(
                                                    child: Center(
                                                      child: Text(codes[index]
                                                          .toString()),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.04,
                                      ),
                                      NeumorphicButton(
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              addMore = !addMore;
                                            });
                                          },
                                          style: NeumorphicStyle(
                                            color:
                                                Color.fromRGBO(23, 25, 95, 1),
                                          ))
                                    ],
                                  )),
                            ),
                          ),
                        ),
                ],
              )),
        ));
  }
}
