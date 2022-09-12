import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Products extends StatefulWidget {
  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<Map> products = [];
  int total = 0;

  Map most;
  Map least;

  bool flage = false;
  getProduct() {
    FirebaseFirestore.instance
        .collection('menuProducts')
        .snapshots()
        .listen((event) {
      event.docs.forEach(
        (element) {
          setState(() {
            products.add({
              'English': element['English'],
              'total': 0,
              "quantities": 0,
              'id': element.id,
              'image': element['image']
            });
          });
          if (products.length == event.docs.length) {
            print("DOneeeeeeeeeee");
            calculateProduct();
          }
        },
      );
    }).onDone(() {});
  }

  calculateProduct() {
    FirebaseFirestore.instance.collection('orders').snapshots().listen((event) {
      event.docs.forEach((element) {
        for (int i = 0; i < element.data()['items'].length; i++) {
          for (int j = 0; j < products.length; j++) {
            if (element.data()['items'][i]['English'] ==
                products[j]['English']) {
              setState(() {
                products[j]['total'] +=
                    int.parse(element.data()['items'][i]['price'].toString());
                total +=
                    int.parse(element.data()['items'][i]['price'].toString());
                products[j]['quantities'] +=
                    element.data()['items'][i]['quantity'];
              });
              break;
            }
          }
        }
      });

      int tempMax = 0;
      int tempMin = total;
      products.forEach((element) {
        if (element['total'] > tempMax) {
          tempMax = element['total'];
          setState(() {
            most = element;
          });
        }

        if (element['total'] < tempMin) {
          tempMin = element['total'];
          setState(() {
            least = element;
          });
        }
        print("least");
        print(least);
      });
    });
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
                        Row(
                          children: [
                            NeumorphicText(
                              "Total Income : ",
                              textStyle: NeumorphicTextStyle(fontSize: 16),
                              style: NeumorphicStyle(color: Colors.black),
                            ),
                            Countup(
                                begin: 0,
                                end: total.toDouble(),
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
                  flex: 14,
                  child: Center(
                    child: products == []
                        ? Container()
                        : Container(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemCount: products.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Neumorphic(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            height: height * 0.15,
                                            child: Image.network(
                                                products[index]['image'],
                                                fit: BoxFit.cover),
                                          ),
                                          NeumorphicText(
                                            products[index]['English'],
                                            textStyle: NeumorphicTextStyle(
                                                fontSize: 12),
                                            style: NeumorphicStyle(
                                                color: Colors.black),
                                          ),
                                          NeumorphicText(
                                            products[index]['total']
                                                    .toStringAsFixed(1) +
                                                "  IQD",
                                            textStyle: NeumorphicTextStyle(
                                                fontSize: 12),
                                            style: NeumorphicStyle(
                                                color: Colors.black),
                                          ),
                                          NeumorphicText(
                                            products[index]['quantities']
                                                    .toString() +
                                                "  Qtd",
                                            textStyle: NeumorphicTextStyle(
                                                fontSize: 12),
                                            style: NeumorphicStyle(
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Neumorphic(
                            style:
                                NeumorphicStyle(shadowDarkColor: Colors.green),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: height * 0.07,
                                  width: width * 0.17,
                                  child: Image.network(most['image'],
                                      fit: BoxFit.cover),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      NeumorphicText(
                                        'Most Sales',
                                        textStyle:
                                            NeumorphicTextStyle(fontSize: 12),
                                        style: NeumorphicStyle(
                                            color: Colors.black),
                                      ),
                                      NeumorphicText(
                                        most['English'],
                                        textStyle:
                                            NeumorphicTextStyle(fontSize: 12),
                                        style: NeumorphicStyle(
                                            color: Colors.black),
                                      ),
                                      Countup(
                                          begin: 0,
                                          end: most['total'].toDouble(),
                                          duration: Duration(seconds: 3),
                                          separator: ',',
                                          suffix: "  IQD",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Neumorphic(
                            style: NeumorphicStyle(shadowDarkColor: Colors.red),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: height * 0.07,
                                  width: width * 0.17,
                                  child: Image.network(least['image'],
                                      fit: BoxFit.cover),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      NeumorphicText(
                                        'Least Sales',
                                        textStyle:
                                            NeumorphicTextStyle(fontSize: 12),
                                        style: NeumorphicStyle(
                                            color: Colors.black),
                                      ),
                                      NeumorphicText(
                                        least['English'],
                                        textStyle:
                                            NeumorphicTextStyle(fontSize: 12),
                                        style: NeumorphicStyle(
                                            color: Colors.black),
                                      ),

                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
