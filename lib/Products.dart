import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:uzhii/main.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool add = false;

  TextEditingController _name = new TextEditingController();
  TextEditingController _priceP = new TextEditingController();
  double _priceI;
  int _quantity;
  double curency;

  double reciprocal(double d) => d / 1;
  getCurency() {
    print("object");
    FirebaseFirestore.instance
        .collection('curency')
        .snapshots()
        .listen((dataSnapshot) {
      DocumentSnapshot temp = dataSnapshot.docs[0];
      print(temp['euro'].toString());
      print("curency");
      setState(() {
        curency = reciprocal(temp['euro'].toDouble());
        print(curency);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: height * 0.03),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: Text(
                    "PRODUCTS",
                    style: TextStyle(
                      color: Color.fromRGBO(235, 118, 189, 1),
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Container(
                margin: EdgeInsets.only(top: height * 0.04),
                height: height * 0.86,
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
                              Color.fromRGBO(235, 118, 189, 1),
                            ),
                          ),
                        ),
                      );
                    return Padding(
                      padding: EdgeInsets.only(right: width * 0.0),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: data.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              height: height * 0.1,
                              width: width * 0.95,
                              padding: EdgeInsets.only(
                                  left: width * 0.02,
                                  bottom: height * 0.01,
                                  right: width * 0.02),
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          data.docs[index]["name"],
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  235, 118, 189, 1),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          data.docs[index]["priceP"]
                                                  .toString() +
                                              " Ld     " +
                                              data.docs[index]["priceI"]
                                                  .toString() +
                                              "  IQD  " +
                                              "  Quantity  " +
                                              data.docs[index]["quantity"]
                                                  .toString(),
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                235, 118, 189, 1),
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  },
                )),
            (add == null)
                ? Container()
                : (add || userRole != 1)
                    ? Container()
                    : Positioned(
                        bottom: -2,
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
                                getCurency();
                                setState(() {
                                  add = !add;
                                });
                              },
                              style: NeumorphicStyle(
                                  color: Color.fromRGBO(235, 118, 189, 1),
                                  border: NeumorphicBorder.none()),
                            )),
                      ),
            (add == null)
                ? Container()
                : (!add)
                    ? Container()
                    : Container(
                        height: height * 0.9,
                        width: width,
                        color: Color.fromRGBO(235, 118, 189, 0.1),
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
                                      "ADD PRODUCT",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(235, 118, 189, 1),
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
                                              Color.fromRGBO(235, 118, 189, 1),
                                        ),
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            return 'Should not be empty';
                                          } else {
                                            return null;
                                          }
                                        },
                                        controller: _name,
                                        keyboardType: TextInputType.text,
                                        autofocus: false,
                                        decoration: InputDecoration(
                                            labelText: "Name",
                                            labelStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  235, 118, 189, 1),
                                            ),
                                            hintText: 'Name',
                                            hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    235, 118, 189, 1)),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 10.0, 20.0, 10.0),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      235, 118, 189, 1),
                                                  width: 0.0),
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Container(
                                      width: width * 0.7,
                                      color: Colors.white,
                                      child: TextFormField(
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(235, 118, 189, 1),
                                        ),
                                        onChanged: (text) {
                                          print('First text field: $text');
                                          print(curency);
                                          print(_priceP.value.text);
                                          setState(() {
                                            _priceI = curency *
                                                double.parse(
                                                    _priceP.value.text);
                                          });
                                          print(_priceI);
                                        },
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            return 'Should not be empty';
                                          } else {
                                            return null;
                                          }
                                        },
                                        controller: _priceP,
                                        keyboardType: TextInputType.number,
                                        autofocus: false,
                                        decoration: InputDecoration(
                                            labelText: "Price",
                                            labelStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  235, 118, 189, 1),
                                            ),
                                            hintText: 'Price',
                                            hintStyle: TextStyle(
                                                color: Color.fromRGBO(
                                                    235, 118, 189, 1)),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 10.0, 20.0, 10.0),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      235, 118, 189, 1),
                                                  width: 0.0),
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Neumorphic(
                                      child: Container(
                                          width: width * 0.4,
                                          height: height * 0.05,
                                          child: Center(
                                            child: Text(
                                              _priceI == null
                                                  ? "0"
                                                  : "" +
                                                      _priceI.toString() +
                                                      " IQD",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      235, 118, 189, 1)),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: height * 0.03,
                                    ),
                                    NeumorphicButton(
                                        child: Text(
                                          "ADD",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('products')
                                              .doc()
                                              .set({
                                            "name": _name.text,
                                            "priceP":
                                                double.parse(_priceP.text),
                                            "priceI": _priceI,
                                            "quantity": 0,
                                            "sellI": 0
                                          });

                                          setState(() {
                                            _priceP = TextEditingController();
                                            _name = TextEditingController();
                                            _priceI = 0;
                                          });
                                        },
                                        style: NeumorphicStyle(
                                          color:
                                              Color.fromRGBO(235, 118, 189, 1),
                                        ))
                                  ],
                                )),
                          ),
                        ),
                      ),
            (add == null)
                ? Container()
                : (!add)
                    ? Container()
                    : Positioned(
                        bottom: -2,
                        right: width * 0.4,
                        child: Container(
                            height: height * 0.05,
                            width: width * 0.2,
                            child: NeumorphicButton(
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  color: Color.fromRGBO(235, 118, 189, 1),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  add = !add;
                                  _priceP = TextEditingController();
                                  _name = TextEditingController();
                                  _priceI = 0;
                                });
                              },
                              style: NeumorphicStyle(
                                  color: Colors.white,
                                  border: NeumorphicBorder.none()),
                            )),
                      ),
          ],
        ),
      ),
    );
  }
}