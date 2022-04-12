import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:uzhii/Postscreen.dart';
import 'package:uzhii/main.dart';
import 'package:uzhii/postDetail.dart';
import 'package:uzhii/profile.dart';
import 'package:uzhii/sellScreen.dart';

class Invoices extends StatefulWidget {
  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  bool add = false;

  int btnAction = 0;

  int statControll = 2;

  QueryDocumentSnapshot currentDoc;

  showAlertDialog(BuildContext context, String msg) {
    // set up the button
    Widget okButton = TextButton(
      child: Icon(
        Icons.close,
        color: Color.fromRGBO(23, 25, 95, 1),
        size: 20,
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Note"),
      content: Text(msg.toString()),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: height * 0.01),
        child: SafeArea(
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Invoices",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(23, 25, 95, 1),
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: height * 0.05,
                left: width * 0.2,
                child: Container(
                  width: width * 0.6,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        NeumorphicButton(
                          style: NeumorphicStyle(
                            color: statControll == 1
                                ? Colors.white
                                : Color.fromRGBO(23, 25, 95, 1),
                          ),
                          onPressed: () {
                            setState(() {
                              statControll = 1;
                            });
                          },
                          child: Text(
                            "ALL",
                            style: TextStyle(
                                color: statControll == 1
                                    ? Color.fromRGBO(23, 25, 95, 1)
                                    : Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        NeumorphicButton(
                          onPressed: () {
                            setState(() {
                              statControll = 2;
                            });
                          },
                          style: NeumorphicStyle(
                            color: statControll == 2
                                ? Colors.white
                                : Color.fromRGBO(23, 25, 95, 1),
                          ),
                          child: Text(
                            "New",
                            style: TextStyle(
                                color: statControll == 2
                                    ? Color.fromRGBO(23, 25, 95, 1)
                                    : Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        NeumorphicButton(
                          style: NeumorphicStyle(
                            color: statControll == 3
                                ? Colors.white
                                : Color.fromRGBO(23, 25, 95, 1),
                          ),
                          onPressed: () {
                            setState(() {
                              statControll = 3;
                            });
                          },
                          child: Text(
                            "History",
                            style: TextStyle(
                                color: statControll == 3
                                    ? Color.fromRGBO(23, 25, 95, 1)
                                    : Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Container(
                    padding: EdgeInsets.only(top: height * 0.1),
                    height: height * 0.9,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('invoice')
                          .snapshots(),
                      builder: (context, snapshot) {
                        QuerySnapshot data = snapshot.data;
                        if (data == null)
                          return Center(
                            child: Container(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            ),
                          );
                        return Padding(
                          padding: EdgeInsets.only(right: width * 0.0),
                          child: ListView.builder(
                            itemCount: data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (statControll == 1) {
                                return Container(
                                  height: height * 0.2,
                                  margin: EdgeInsets.all(5),
                                  child: new Neumorphic(
                                    padding: EdgeInsets.only(left: 10),
                                    style: NeumorphicStyle(
                                        border: NeumorphicBorder(
                                      color: Color.fromRGBO(23, 25, 95, 1),
                                    )),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8.0, right: 8),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.person,
                                                    size: 18,
                                                    color: Color.fromRGBO(
                                                        23, 25, 95, 1),
                                                  ),
                                                  Text(
                                                    "  " +
                                                        data.docs[index]
                                                            ['CustomerName'],
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          23, 25, 95, 1),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Text(
                                              " Invoice No: " +
                                                  data.docs[index].id
                                                      .toString()
                                                      .substring(1, 7),
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    23, 25, 95, 1),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.phone,
                                                    size: 18,
                                                    color: Color.fromRGBO(
                                                        23, 25, 95, 1),
                                                  ),
                                                  Text(
                                                    "  " +
                                                        data.docs[index]
                                                            ['phoneNo2'],
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          23, 25, 95, 1),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 10,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.phone,
                                                      size: 18,
                                                      color: Color.fromRGBO(
                                                          23, 25, 95, 1),
                                                    ),
                                                    Text(
                                                      "  " +
                                                          data.docs[index]
                                                              ['phoneNo2'],
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            23, 25, 95, 1),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Icon(
                                                  Icons.pin_drop_outlined,
                                                  size: 18,
                                                  color: Color.fromRGBO(
                                                      23, 25, 95, 1),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  data.docs[index]['address'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        23, 25, 95, 1),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Text(
                                                " Products:  " +
                                                    data.docs[index]
                                                            ['noOfProducts']
                                                        .toString(),
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      23, 25, 95, 1),
                                                ),
                                              ),
                                            ),
                                            data.docs[index]['state'] == 0
                                                ? Text(
                                                    "State: Not Delivered",
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          23, 25, 95, 1),
                                                    ),
                                                  )
                                                : Text(
                                                    "State: Delivered",
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          23, 25, 95, 1),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Text(
                                                " Total:   " +
                                                    data.docs[index]['totalI']
                                                        .toStringAsFixed(1) +
                                                    " IQD  -  " +
                                                    data.docs[index]['totalP']
                                                        .toStringAsFixed(1) +
                                                    " Lb",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Color.fromRGBO(
                                                      23, 25, 95, 1),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8.0),
                                                    child: NeumorphicButton(
                                                      child: Text(
                                                        "Detail",
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: Color.fromRGBO(
                                                              23, 25, 95, 1),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          btnAction = 3;

                                                          currentDoc =
                                                              data.docs[index];
                                                        });
                                                      },
                                                      style: NeumorphicStyle(
                                                          shadowDarkColor:
                                                              Colors.black38,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  data.docs[index]['state'] == 1
                                                      ? Container()
                                                      : Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 8.0),
                                                          child:
                                                              NeumorphicButton(
                                                            child: Text(
                                                              "Cancle",
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        23,
                                                                        25,
                                                                        95,
                                                                        1),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                btnAction = 1;
                                                                currentDoc =
                                                                    data.docs[
                                                                        index];
                                                              });
                                                            },
                                                            style: NeumorphicStyle(
                                                                shadowDarkColor:
                                                                    Colors
                                                                        .black38,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                  data.docs[index]['state'] == 1
                                                      ? Container()
                                                      : NeumorphicButton(
                                                          child: Text(
                                                            "Done",
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              btnAction = 2;
                                                              currentDoc = data
                                                                  .docs[index];
                                                            });
                                                          },
                                                          style:
                                                              NeumorphicStyle(
                                                            shadowDarkColor:
                                                                Colors.black38,
                                                            color:
                                                                Color.fromRGBO(
                                                                    23,
                                                                    25,
                                                                    95,
                                                                    1),
                                                          ))
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else if (statControll == 2) {
                                return data.docs[index]['state'] != 0
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.all(5),
                                        child: new Neumorphic(
                                          padding: EdgeInsets.only(left: 10),
                                          style: NeumorphicStyle(
                                              border: NeumorphicBorder(
                                            color:
                                                Color.fromRGBO(23, 25, 95, 1),
                                          )),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8.0, right: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.person,
                                                          size: 18,
                                                          color: Color.fromRGBO(
                                                              23, 25, 95, 1),
                                                        ),
                                                        Text(
                                                          "  " +
                                                              data.docs[index][
                                                                  'CustomerName'],
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    23,
                                                                    25,
                                                                    95,
                                                                    1),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Text(
                                                      " Invoice No: " +
                                                          data.docs[index].id
                                                              .toString()
                                                              .substring(1, 7),
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            23, 25, 95, 1),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.phone,
                                                          size: 18,
                                                          color: Color.fromRGBO(
                                                              23, 25, 95, 1),
                                                        ),
                                                        Text(
                                                          "  " +
                                                              data.docs[index]
                                                                  ['phoneNo2'],
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    23,
                                                                    25,
                                                                    95,
                                                                    1),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 10,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.phone,
                                                            size: 18,
                                                            color:
                                                                Color.fromRGBO(
                                                                    23,
                                                                    25,
                                                                    95,
                                                                    1),
                                                          ),
                                                          Text(
                                                            "  " +
                                                                data.docs[index]
                                                                    [
                                                                    'phoneNo2'],
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      23,
                                                                      25,
                                                                      95,
                                                                      1),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child: Icon(
                                                        Icons.pin_drop_outlined,
                                                        size: 18,
                                                        color: Color.fromRGBO(
                                                            23, 25, 95, 1),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        data.docs[index]
                                                            ['address'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              23, 25, 95, 1),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child: Icon(
                                                        Icons.date_range,
                                                        size: 18,
                                                        color: Color.fromRGBO(
                                                            23, 25, 95, 1),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        data.docs[index]
                                                            ['sellingDate'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              23, 25, 95, 1),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    child: Text(
                                                      " Products:  " +
                                                          data.docs[index][
                                                                  'noOfProducts']
                                                              .toString(),
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            23, 25, 95, 1),
                                                      ),
                                                    ),
                                                  ),
                                                  data.docs[index]['state'] == 0
                                                      ? Text(
                                                          "State: Not Delivered",
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    23,
                                                                    25,
                                                                    95,
                                                                    1),
                                                          ),
                                                        )
                                                      : Text(
                                                          "State: Delivered",
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    23,
                                                                    25,
                                                                    95,
                                                                    1),
                                                          ),
                                                        ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    child: Text(
                                                      " Total:   " +
                                                          data.docs[index]
                                                                  ['totalI']
                                                              .toStringAsFixed(
                                                                  1) +
                                                          " IQD  -  " +
                                                          data.docs[index]
                                                                  ['totalP']
                                                              .toStringAsFixed(
                                                                  1) +
                                                          " Lb",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Color.fromRGBO(
                                                            23, 25, 95, 1),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 8.0),
                                                          child:
                                                              NeumorphicButton(
                                                            child: Text(
                                                              "Detail",
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        23,
                                                                        25,
                                                                        95,
                                                                        1),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                btnAction = 3;

                                                                currentDoc =
                                                                    data.docs[
                                                                        index];
                                                              });
                                                            },
                                                            style: NeumorphicStyle(
                                                                shadowDarkColor:
                                                                    Colors
                                                                        .black38,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        data.docs[index]
                                                                    ['state'] ==
                                                                1
                                                            ? Container()
                                                            : Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            8.0),
                                                                child:
                                                                    NeumorphicButton(
                                                                  child: Text(
                                                                    "Cancle",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              23,
                                                                              25,
                                                                              95,
                                                                              1),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      btnAction =
                                                                          1;
                                                                      currentDoc =
                                                                          data.docs[
                                                                              index];
                                                                    });
                                                                  },
                                                                  style: NeumorphicStyle(
                                                                      shadowDarkColor:
                                                                          Colors
                                                                              .black38,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                        data.docs[index]
                                                                    ['state'] ==
                                                                1
                                                            ? Container()
                                                            : NeumorphicButton(
                                                                child: Text(
                                                                  "Done",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    btnAction =
                                                                        2;
                                                                    currentDoc =
                                                                        data.docs[
                                                                            index];
                                                                  });
                                                                },
                                                                style:
                                                                    NeumorphicStyle(
                                                                  shadowDarkColor:
                                                                      Colors
                                                                          .black38,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          23,
                                                                          25,
                                                                          95,
                                                                          1),
                                                                ))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                              } else {
                                return data.docs[index]['state'] == 0
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.all(5),
                                        child: new Neumorphic(
                                          padding: EdgeInsets.only(left: 10),
                                          style: NeumorphicStyle(
                                              border: NeumorphicBorder(
                                            color:
                                                Color.fromRGBO(23, 25, 95, 1),
                                          )),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0, right: 8),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.person,
                                                          size: 18,
                                                          color: Color.fromRGBO(
                                                              23, 25, 95, 1),
                                                        ),
                                                        Text(
                                                          "  " +
                                                              data.docs[index][
                                                                  'CustomerName'],
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    23,
                                                                    25,
                                                                    95,
                                                                    1),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    " Invoice No: " +
                                                        data.docs[index].id
                                                            .toString()
                                                            .substring(1, 7),
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          23, 25, 95, 1),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.phone,
                                                          size: 18,
                                                          color: Color.fromRGBO(
                                                              23, 25, 95, 1),
                                                        ),
                                                        Text(
                                                          "  " +
                                                              data.docs[index]
                                                                  ['phoneNo2'],
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      23,
                                                                      25,
                                                                      95,
                                                                      1)),
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 10,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.phone,
                                                            size: 18,
                                                            color:
                                                                Color.fromRGBO(
                                                                    23,
                                                                    25,
                                                                    95,
                                                                    1),
                                                          ),
                                                          Text(
                                                            "  " +
                                                                data.docs[index]
                                                                    [
                                                                    'phoneNo2'],
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        23,
                                                                        25,
                                                                        95,
                                                                        1)),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child: Icon(
                                                        Icons.pin_drop_outlined,
                                                        size: 18,
                                                        color: Color.fromRGBO(
                                                            23, 25, 95, 1),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        data.docs[index]
                                                            ['address'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              23, 25, 95, 1),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child: Icon(
                                                        Icons.date_range,
                                                        size: 18,
                                                        color: Color.fromRGBO(
                                                            23, 25, 95, 1),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        data.docs[index]
                                                            ['sellingDate'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              23, 25, 95, 1),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    child: Text(
                                                      " Products:  " +
                                                          data.docs[index][
                                                                  'noOfProducts']
                                                              .toString(),
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            23, 25, 95, 1),
                                                      ),
                                                    ),
                                                  ),
                                                  data.docs[index]['state'] == 0
                                                      ? Text(
                                                          "State: Not Delivered",
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    23,
                                                                    25,
                                                                    95,
                                                                    1),
                                                          ),
                                                        )
                                                      : Text(
                                                          "State: Delivered",
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    23,
                                                                    25,
                                                                    95,
                                                                    1),
                                                          ),
                                                        ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    child: Text(
                                                      " Total:   " +
                                                          data.docs[index]
                                                                  ['totalI']
                                                              .toStringAsFixed(
                                                                  1) +
                                                          " IQD  -  " +
                                                          data.docs[index]
                                                                  ['totalP']
                                                              .toStringAsFixed(
                                                                  1) +
                                                          " Lb",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Color.fromRGBO(
                                                            23, 25, 95, 1),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 8.0),
                                                          child:
                                                              NeumorphicButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                btnAction = 3;

                                                                currentDoc =
                                                                    data.docs[
                                                                        index];
                                                              });
                                                            },
                                                            child: Text(
                                                              "Detail",
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        23,
                                                                        25,
                                                                        95,
                                                                        1),
                                                              ),
                                                            ),
                                                            style: NeumorphicStyle(
                                                                shadowDarkColor:
                                                                    Colors
                                                                        .black38,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        data.docs[index]
                                                                    ['state'] ==
                                                                1
                                                            ? Container()
                                                            : Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            8.0),
                                                                child:
                                                                    NeumorphicButton(
                                                                  child: Text(
                                                                    "Cancle",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              23,
                                                                              25,
                                                                              95,
                                                                              1),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      btnAction =
                                                                          1;
                                                                      currentDoc =
                                                                          data.docs[
                                                                              index];
                                                                    });
                                                                  },
                                                                  style: NeumorphicStyle(
                                                                      shadowDarkColor:
                                                                          Colors
                                                                              .black38,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                        data.docs[index]
                                                                    ['state'] ==
                                                                1
                                                            ? Container()
                                                            : NeumorphicButton(
                                                                child: Text(
                                                                  "Done",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    btnAction =
                                                                        2;
                                                                    currentDoc =
                                                                        data.docs[
                                                                            index];
                                                                  });
                                                                },
                                                                style:
                                                                    NeumorphicStyle(
                                                                  shadowDarkColor:
                                                                      Colors
                                                                          .black38,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          23,
                                                                          25,
                                                                          95,
                                                                          1),
                                                                ))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                              }
                            },
                          ),
                        );
                      },
                    )),
              ),
              btnAction == 0
                  ? Container()
                  : btnAction == 2
                      ? Container(
                          height: height * 0.9,
                          width: width,
                          color: Color.fromRGBO(23, 25, 95, 0.1),
                          child: Center(
                            child: Neumorphic(
                              style: NeumorphicStyle(color: Colors.white),
                              child: Container(
                                  height: height * 0.3,
                                  width: width * 0.8,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Confirmation",
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
                                      Text(
                                        "Is this order dilivered?",
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
                                        padding: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 8.0),
                                                  child: NeumorphicButton(
                                                    child: Text(
                                                      "No",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Color.fromRGBO(
                                                            23, 25, 95, 1),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        btnAction = 0;
                                                      });
                                                    },
                                                    style: NeumorphicStyle(
                                                        shadowDarkColor:
                                                            Colors.black38,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                NeumorphicButton(
                                                    child: Text(
                                                      "Yes",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection('invoice')
                                                          .doc(currentDoc.id)
                                                          .update({'state': 1});
                                                      setState(() {
                                                        btnAction = 0;
                                                      });
                                                    },
                                                    style: NeumorphicStyle(
                                                      shadowDarkColor:
                                                          Colors.black38,
                                                      color: Color.fromRGBO(
                                                          23, 25, 95, 1),
                                                    ))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        )
                      : btnAction == 3
                          ? Container(
                              height: height * 0.9,
                              width: width,
                              color: Color.fromRGBO(23, 25, 95, 0.1),
                              child: Center(
                                child: Neumorphic(
                                  style: NeumorphicStyle(color: Colors.white),
                                  child: Container(
                                      height: height * 0.9,
                                      width: width,
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Detail",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    23, 25, 95, 1),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          Container(
                                            height: height * 0.65,
                                            margin: EdgeInsets.all(5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: height * 0.15,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8.0,
                                                                right: 8),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.person,
                                                                  size: 18,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          23,
                                                                          25,
                                                                          95,
                                                                          1),
                                                                ),
                                                                Text(
                                                                  "  " +
                                                                      currentDoc[
                                                                          'CustomerName'],
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            23,
                                                                            25,
                                                                            95,
                                                                            1),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Text(
                                                              " Invoice No: " +
                                                                  currentDoc.id
                                                                      .toString()
                                                                      .substring(
                                                                          1, 7),
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        23,
                                                                        25,
                                                                        95,
                                                                        1),
                                                              ),
                                                            ),
                                                            IconButton(
                                                                icon: Icon(
                                                                    Icons.note,
                                                                    size: 20,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            23,
                                                                            25,
                                                                            95,
                                                                            1)),
                                                                onPressed: () {
                                                                  showAlertDialog(
                                                                      context,
                                                                      currentDoc[
                                                                          'note']);
                                                                }),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 10),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.phone,
                                                                  size: 18,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          23,
                                                                          25,
                                                                          95,
                                                                          1),
                                                                ),
                                                                Text(
                                                                  "  " +
                                                                      currentDoc[
                                                                          'phoneNo2'],
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            23,
                                                                            25,
                                                                            95,
                                                                            1),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                left: 10,
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.phone,
                                                                    size: 18,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            23,
                                                                            25,
                                                                            95,
                                                                            1),
                                                                  ),
                                                                  Text(
                                                                    "  " +
                                                                        currentDoc[
                                                                            'phoneNo2'],
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              23,
                                                                              25,
                                                                              95,
                                                                              1),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              child: Icon(
                                                                Icons
                                                                    .pin_drop_outlined,
                                                                size: 18,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        23,
                                                                        25,
                                                                        95,
                                                                        1),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                currentDoc[
                                                                    'address'],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          23,
                                                                          25,
                                                                          95,
                                                                          1),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 10),
                                                        child: Icon(
                                                          Icons.date_range,
                                                          size: 18,
                                                          color: Color.fromRGBO(
                                                              23, 25, 95, 1),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          currentDoc[
                                                              'sellingDate'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    23,
                                                                    25,
                                                                    95,
                                                                    1),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child: Text(
                                                        " Products:  " +
                                                            currentDoc[
                                                                    'noOfProducts']
                                                                .toString(),
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              23, 25, 95, 1),
                                                        ),
                                                      ),
                                                    ),
                                                    currentDoc['state'] == 0
                                                        ? Text(
                                                            "State: Not Delivered",
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      23,
                                                                      25,
                                                                      95,
                                                                      1),
                                                            ),
                                                          )
                                                        : Text(
                                                            "State: Delivered",
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      23,
                                                                      25,
                                                                      95,
                                                                      1),
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: height * 0.01,
                                                ),
                                                Neumorphic(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      height: height * 0.25,
                                                      width: width * 0.85,
                                                      margin: EdgeInsets.only(
                                                          left: 15.0),
                                                      child: ListView.builder(
                                                          itemCount: currentDoc[
                                                                  "productSell"]
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Container(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    (index + 1)
                                                                            .toString() +
                                                                        "-  " +
                                                                        currentDoc["productSell"][index]
                                                                            [
                                                                            'name'],
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              23,
                                                                              25,
                                                                              95,
                                                                              1),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    currentDoc["productSell"][index]['priceI'].toStringAsFixed(
                                                                            1) +
                                                                        " IQD      -      Qtd:  " +
                                                                        currentDoc["productSell"][index]['quantity']
                                                                            .toString() +
                                                                        "       -     code:  " +
                                                                        currentDoc["productSell"][index]['code']
                                                                            .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              23,
                                                                              25,
                                                                              95,
                                                                              1),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        height *
                                                                            0.01,
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height * 0.01,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child: Text(
                                                        "Buying Total:   " +
                                                            currentDoc[
                                                                    'totalBuy']
                                                                .toStringAsFixed(
                                                                    1)
                                                                .replaceAllMapped(
                                                                    RegExp(
                                                                        r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                                    (Match m) =>
                                                                        '${m[1]},') +
                                                            " IQD",
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              23, 25, 95, 1),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: Text(
                                                        "   Selling Total:   " +
                                                            currentDoc[
                                                                    'totalCI']
                                                                .toStringAsFixed(
                                                                    1)
                                                                .replaceAllMapped(
                                                                    RegExp(
                                                                        r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                                    (Match m) =>
                                                                        '${m[1]},') +
                                                            " IQD",
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              23, 25, 95, 1),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: Text(
                                                        "   Profit:   " +
                                                            (currentDoc['totalCI'] -
                                                                    currentDoc[
                                                                        'totalBuy'])
                                                                .toStringAsFixed(
                                                                    1)
                                                                .replaceAllMapped(
                                                                    RegExp(
                                                                        r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                                    (Match m) =>
                                                                        '${m[1]},') +
                                                            " IQD",
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              23, 25, 95, 1),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: currentDoc[
                                                                  'totalDis'] ==
                                                              0
                                                          ? Text(
                                                              "   Discount:   " +
                                                                  "0 %",
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        23,
                                                                        25,
                                                                        95,
                                                                        1),
                                                              ),
                                                            )
                                                          : Text(
                                                              "   Discount:   " +
                                                                  (((currentDoc['totalCI'] - currentDoc['totalDis']) /
                                                                              currentDoc['totalCI']) *
                                                                          100)
                                                                      .toString() +
                                                                  " %",
                                                              style: TextStyle(
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
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child: Text(
                                                        " Total:   " +
                                                            currentDoc['totalI']
                                                                .toStringAsFixed(
                                                                    1)
                                                                .replaceAllMapped(
                                                                    RegExp(
                                                                        r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                                    (Match m) =>
                                                                        '${m[1]},') +
                                                            " IQD  -  " +
                                                            currentDoc['totalP']
                                                                .toStringAsFixed(
                                                                    1) +
                                                            " Lb",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Color.fromRGBO(
                                                              23, 25, 95, 1),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  child: Text(
                                                    " Profit:   " +
                                                        (currentDoc['totalI'] -
                                                                currentDoc[
                                                                    'totalBuy'])
                                                            .toStringAsFixed(1)
                                                            .replaceAllMapped(
                                                                RegExp(
                                                                    r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                                (Match m) =>
                                                                    '${m[1]},') +
                                                        " IQD",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Color.fromRGBO(
                                                          23, 25, 95, 1),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: height * 0.04,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  children: [
                                                    NeumorphicButton(
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 16,
                                                          color: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            btnAction = 0;
                                                          });
                                                        },
                                                        style: NeumorphicStyle(
                                                          shadowDarkColor:
                                                              Colors.black38,
                                                          color: Color.fromRGBO(
                                                              23, 25, 95, 1),
                                                        ))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            )
                          : Container(
                              height: height * 0.9,
                              width: width,
                              color: Color.fromRGBO(23, 25, 95, 0.1),
                              child: Center(
                                child: Neumorphic(
                                  style: NeumorphicStyle(color: Colors.white),
                                  child: Container(
                                      height: height * 0.3,
                                      width: width * 0.8,
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Information",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    23, 25, 95, 1),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: height * 0.04,
                                          ),
                                          Text(
                                            "Are you sure to delete this order?",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    23, 25, 95, 1),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: height * 0.04,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8.0),
                                                      child: NeumorphicButton(
                                                        child: Text(
                                                          "No",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Color.fromRGBO(
                                                                    23,
                                                                    25,
                                                                    95,
                                                                    1),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            btnAction = 0;
                                                          });
                                                        },
                                                        style: NeumorphicStyle(
                                                            shadowDarkColor:
                                                                Colors.black38,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    NeumorphicButton(
                                                        child: Text(
                                                          "Yes",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          currentDoc[
                                                                  'productSell']
                                                              .forEach((e) {
                                                            int quantity;
                                                            String docId;
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'products')
                                                                .where('name',
                                                                    isEqualTo: e[
                                                                        'name'])
                                                                .get()
                                                                .then((value) {
                                                              quantity = value
                                                                          .docs[0]
                                                                      [
                                                                      'quantity'] +
                                                                  e['quantity'];
                                                              docId = value
                                                                  .docs[0].id;
                                                            });

                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'products')
                                                                .doc(docId)
                                                                .update({
                                                              'quantity':
                                                                  quantity
                                                            }).whenComplete(() {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'invoice')
                                                                  .doc(
                                                                      currentDoc
                                                                          .id)
                                                                  .delete();
                                                              setState(() {
                                                                btnAction = 0;
                                                              });
                                                            });

                                                            // FirebaseFirestore.instance
                                                            //     .collection('posts')
                                                            //     .where('code',
                                                            //         isEqualTo: currentDoc[
                                                            //             'code'])
                                                            //     .get()
                                                            //     .then((value) {
                                                            //   value.docs[0]['products']
                                                            //       .forEach((pe) {
                                                            //     if (pe['name'] ==
                                                            //         e['name']) {
                                                            //       print(e['name']);
                                                            //       print(quantity);
                                                            //     }
                                                            //   });
                                                            // });
                                                          });
                                                        },
                                                        style: NeumorphicStyle(
                                                          shadowDarkColor:
                                                              Colors.black38,
                                                          color: Color.fromRGBO(
                                                              23, 25, 95, 1),
                                                        ))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            ),
              Positioned(
                bottom: height * 0.05,
                right: width * 0.4,
                child: Container(
                    height: height * 0.05,
                    width: width * 0.2,
                    child: NeumorphicButton(
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        List<DocumentSnapshot> thisPost;
                        int code;
                        FirebaseFirestore.instance
                            .collection('code')
                            .get()
                            .then((value) {
                          code = value.docs[0].data()['code'];
                        }).whenComplete(() {
                          FirebaseFirestore.instance
                              .collection('posts')
                              .where('code', isEqualTo: code)
                              .get()
                              .then((proVal) {
                            thisPost = proVal.docs;

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => SellScreen(
                                          postId: proVal.docs.first.id,
                                        )));
                          });
                        });
                      },
                      style: NeumorphicStyle(
                          color: Color.fromRGBO(23, 25, 95, 1),
                          border: NeumorphicBorder.none()),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
