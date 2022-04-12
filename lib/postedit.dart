import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:uzhii/Posts.dart';

class PostEdit extends StatefulWidget {
  List<String> productString;
  DocumentSnapshot parentPost;
  PostEdit({this.productString, this.parentPost});
  @override
  _PostEditState createState() => _PostEditState();
}

class _PostEditState extends State<PostEdit> {
  bool addPost;
  List<DocumentSnapshot> productsSnapshot;
  List<Map> products = [];
  List<Map> productsSell = [];
  List<String> productString;
  double curency = 0;
  TextEditingController _priceController = TextEditingController();
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

  getItem() {
    FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((event) {
      if (mounted) {
        setState(() {
          productsSnapshot = event.docs;
          products = new List<Map>(productsSnapshot.length);
          productString = new List<String>(productsSnapshot.length);
          int i = 0;
          productsSnapshot.forEach((element) {
            products[i] = {
              "name": element["name"],
              "price": element["priceP"],
              "priceI": element["priceI"],
              "quantity": element["quantity"],
              "editBook": false,
              'total': 0
            };
            i++;
          });
        });
      }
    }).onDone(() {
      setState(() {
        products = products;

        dropdownValue = widget.productString[0];
      });
    });
  }

  int productQuantity = 0;
  var timer;
  double totalP = 0;
  calclutateTotal() {
    productQuantity = 0;
    totalP = 0;

    productsSell.forEach((element) {
      productQuantity += element['quantity'];
      totalP = totalP + (element["quantity"] * element['price']);
    });

    setState(() {
      totalP = totalP;
      productQuantity = productQuantity;
    });
  }

  String dropdownValue = "The ordinary peeling solution";

  int code;

  getCode() {
    FirebaseFirestore.instance
        .collection('code')
        .snapshots()
        .listen((dataSnapshot) {
      DocumentSnapshot temp = dataSnapshot.docs[0];

      setState(() {
        code = temp['code'] + 1;
      });
    });
  }

  @override
  void initState() {
    getCurency();

    getCode();

    if (mounted) {
      timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
        widget.productString.sort((a, b) => a.compareTo(b));
        setState(() {
          dropdownValue = widget.productString[0];
        });
      });
    }

    getItem();
    print(widget.parentPost['noOfProducts']);
    widget.parentPost['products'].forEach((v) {
      print(v);
      productsSell.add(v);
    });
    setState(() {
      productsSell = productsSell;
      productQuantity = widget.parentPost['noOfProducts'];
      totalP = widget.parentPost['totalP'];
    });

    // TODO: implement initState
    super.initState();
  }

  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                              ),
                              child: Text(
                                "Post: " + widget.parentPost['code'].toString(),
                                style: TextStyle(
                                  color: Color.fromRGBO(23, 25, 95, 1),
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: width * 0.95,
                          height: height * 0.8,
                          margin: EdgeInsets.only(
                              left: width * 0.025, top: height * 0.03),
                          child: Neumorphic(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    DropdownButton<String>(
                                      value: dropdownValue,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Color.fromRGBO(23, 25, 95, 1),
                                      ),
                                      elevation: 16,
                                      onChanged: (String newValue) {
                                        calclutateTotal();
                                        setState(() {
                                          dropdownValue = newValue;
                                        });
                                        products.forEach((element) {
                                          if (element['name'] ==
                                              dropdownValue) {
                                            setState(() {
                                              productsSell.add(element);
                                            });
                                          }
                                        });
                                        // print(productsSell[0]['name']);
                                      },
                                      dropdownColor: Colors.white,
                                      items: widget.productString.map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromRGBO(
                                                    23, 25, 95, 1)),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    Text(
                                      "Code: " + code.toString(),
                                      style: TextStyle(
                                        color: Color.fromRGBO(23, 25, 95, 1),
                                      ),
                                    )
                                  ],
                                ),
                                productsSell.isEmpty
                                    ? Container(
                                        height: height * 0.62,
                                        child: Text(
                                          "No Item",
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(23, 25, 95, 1),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: height * 0.62,
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: productsSell.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                child:
                                                    productsSell[index] == null
                                                        ? Container()
                                                        : Container(
                                                            height:
                                                                height * 0.08,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            child: Neumorphic(
                                                              child: Stack(
                                                                children: [
                                                                  Positioned(
                                                                    left: width *
                                                                        0.87,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          height *
                                                                              0.08,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                productsSell[index]['editBook'] = !productsSell[index]['editBook'];
                                                                                print(_priceController.text);
                                                                              });

                                                                              productsSell[index]['price'] = double.parse(_priceController.text);
                                                                              productsSell[index]['priceI'] = productsSell[index]['price'] * curency;
                                                                              calclutateTotal();
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              child: Icon(
                                                                                productsSell[index]['editBook'] ? Icons.done : Icons.edit,
                                                                                color: Color.fromRGBO(23, 25, 95, 1),
                                                                                size: 20,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              productsSell.remove(productsSell[index]);
                                                                              setState(() {
                                                                                productsSell = productsSell;
                                                                              });
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              child: Icon(
                                                                                Icons.delete,
                                                                                color: Color.fromRGBO(23, 25, 95, 1),
                                                                                size: 20,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      productsSell[index]
                                                                              [
                                                                              'editBook']
                                                                          ? Container(
                                                                              width: width * 0.4,
                                                                              margin: EdgeInsets.only(right: width * 0.32),
                                                                              child: TextFormField(
                                                                                controller: _priceController,
                                                                                keyboardType: TextInputType.number,
                                                                                decoration: InputDecoration(
                                                                                  hintText: 'Enter Number',
                                                                                  hintStyle: TextStyle(color: Color.fromRGBO(23, 25, 95, 1), fontSize: 14),
                                                                                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                                                                ),
                                                                              ))
                                                                          : Container(
                                                                              width: width * 0.72,
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    productsSell[index]['name'],
                                                                                    style: TextStyle(color: Color.fromRGBO(23, 25, 95, 1)),
                                                                                  ),
                                                                                  Text(
                                                                                    productsSell[index]['price'].toString() + "  Lb   -   " + productsSell[index]['priceI'].toStringAsFixed(2) + "  IQD" + "  -  Qt " + productsSell[index]['quantity'].toString(),
                                                                                    style: TextStyle(color: Color.fromRGBO(23, 25, 95, 1)),
                                                                                  ),
                                                                                  Text(
                                                                                    "Total:  " + (productsSell[index]['price'] * productsSell[index]['quantity']).toStringAsFixed(2) + "  Lb  -   " + (productsSell[index]['price'] * productsSell[index]['quantity'] * curency).toStringAsFixed(2) + "  IQD",
                                                                                    style: TextStyle(color: Color.fromRGBO(23, 25, 95, 1)),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                      Row(
                                                                        children: [
                                                                          RotatedBox(
                                                                              quarterTurns: 3,
                                                                              child: Text(
                                                                                "Quantity",
                                                                                style: TextStyle(color: Color.fromRGBO(23, 25, 95, 1)),
                                                                              )),
                                                                          Container(
                                                                            width:
                                                                                width * 0.1,
                                                                            child:
                                                                                Center(
                                                                              child: NumberPicker(
                                                                                textStyle: TextStyle(color: Color.fromRGBO(23, 25, 95, 0.7)),
                                                                                selectedTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color.fromRGBO(23, 25, 95, 1)),
                                                                                itemHeight: height * 0.03,
                                                                                value: productsSell[index]['quantity'],
                                                                                minValue: 0,
                                                                                itemWidth: width * 0.1,
                                                                                maxValue: 100,
                                                                                axis: Axis.vertical,
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    productsSell[index]['quantity'] = value;
                                                                                  });
                                                                                  calclutateTotal();
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                              );
                                            }),
                                      ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  width: width * 0.9,
                                  height: height * 0.11,
                                  child: Column(
                                    children: [
                                      Neumorphic(
                                        child: Container(
                                          height: height * 0.09,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                "Total:  ",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Color.fromRGBO(
                                                        23, 25, 95, 1)),
                                              ),
                                              Text(
                                                totalP
                                                        .toStringAsFixed(1)
                                                        .replaceAllMapped(
                                                            RegExp(
                                                                r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                            (Match m) =>
                                                                '${m[1]},') +
                                                    "   LB  " +
                                                    '\n' +
                                                    (totalP * curency)
                                                        .toStringAsFixed(1)
                                                        .replaceAllMapped(
                                                            RegExp(
                                                                r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                            (Match m) =>
                                                                '${m[1]},') +
                                                    "  IQD  \n" +
                                                    productQuantity.toString() +
                                                    "  Products",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        23, 25, 95, 1)),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  productsSnapshot
                                                      .forEach((element) {
                                                    productsSell.forEach((e) {
                                                      if (element['name'] ==
                                                          e['name']) {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'products')
                                                            .doc(element.id)
                                                            .update({
                                                          'quantity': element[
                                                                  "quantity"] +
                                                              e["quantity"]
                                                        });
                                                      }
                                                    });
                                                  });
                                                  DateTime now =
                                                      new DateTime.now();
                                                  String formattedDate =
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(now);

                                                  FirebaseFirestore.instance
                                                      .collection('posts')
                                                      .doc(widget.parentPost.id)
                                                      .update({
                                                    'products': productsSell,
                                                    'totalI': totalP * curency,
                                                    'totalP': totalP,
                                                    'noOfProducts':
                                                        productQuantity,
                                                  });

                                                  Navigator.pop(context);
                                                },
                                                child: Neumorphic(
                                                  child: Container(
                                                    width: width * 0.2,
                                                    height: height * 0.05,
                                                    color: Color.fromRGBO(
                                                        23, 25, 95, 1),
                                                    child: Center(
                                                        child: RotatedBox(
                                                      quarterTurns: 3,
                                                      child: Icon(
                                                        Icons.send,
                                                        color: Colors.white,
                                                      ),
                                                    )),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: height * 0.0,
                left: width * 0.0,
                child: Container(
                    child: NeumorphicButton(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Color.fromRGBO(23, 25, 95, 1),
                    size: 14,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: NeumorphicStyle(
                      color: Colors.white, border: NeumorphicBorder.none()),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
