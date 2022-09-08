// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, unused_element, unused_import, avoid_web_libraries_in_flutter

import 'dart:html';

import 'package:flutter/material.dart';

import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

import '../util/hex.dart';

class billsplitter extends StatefulWidget {
  const billsplitter({Key? key}) : super(key: key);

  @override
  State<billsplitter> createState() => _billsplitterState();
}

class _billsplitterState extends State<billsplitter> {
  int _tipPercentage = 0;
  double _personCounter = 1;
  double _billamount = 0;
  Color grad_blue = Hexcolor("#33ccff");
  Color grad_purple = Hexcolor("#ff99cc");
  Color grad_shap = Hexcolor("#9F2B68");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
        alignment: Alignment.center,
        color: Colors.white,
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(20.5),
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [grad_purple, grad_blue]),
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total Per Person",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.purple.withOpacity(0.9),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "\$ ${calculateTotalPerPerson(_billamount, _personCounter, _tipPercentage)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color: grad_shap,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.blueGrey.shade100,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: <Widget>[
                  TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(
                      color: grad_purple,
                    ),
                    decoration: InputDecoration(
                      prefixText: "Bill amount",
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    onChanged: (String value) {
                      try {
                        _billamount = double.parse(value);
                      } catch (e) {
                        _billamount = 0.0;
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Split",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(
                                () {
                                  if (_personCounter > 1) {
                                    _personCounter--;
                                  }
                                },
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                color: grad_shap.withOpacity(0.1),
                              ),
                              child: Center(
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                    color: grad_blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "$_personCounter",
                            style: TextStyle(
                              color: grad_blue,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(
                                () {
                                  _personCounter++;
                                },
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                color: grad_shap.withOpacity(0.1),
                              ),
                              child: Center(
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                    color: grad_blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Tip",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                "\$${(calculateTotalTip(_billamount, _personCounter, _tipPercentage)).toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: grad_blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "$_tipPercentage%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: grad_blue,
                        ),
                      ),
                      Slider(
                          min: 0,
                          max: 100,
                          divisions: 20,
                          activeColor: grad_purple,
                          inactiveColor: Colors.grey,
                          value: _tipPercentage.toDouble(),
                          onChanged: ((double newvalue) {
                            setState(() {
                              _tipPercentage = newvalue.round();
                            });
                          })),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  calculateTotalPerPerson(
      double billAmount, double splitBy, int tipPercentage) {
    var totalPerPerson =
        (calculateTotalTip(billAmount, splitBy, tipPercentage) + billAmount) /
            splitBy;
    return totalPerPerson.toStringAsFixed(2);
  }

  calculateTotalTip(double billAmount, double splitBy, int tipPercentage) {
    double totalTip = 0.0;
    if (billAmount < 0 || billAmount == null || billAmount.toString().isEmpty) {
    } else {
      totalTip = (billAmount * tipPercentage) / 100;
    }
    return totalTip;
  }
}

class wisdom extends StatefulWidget {
  const wisdom({Key? key}) : super(key: key);

  @override
  State<wisdom> createState() => _wisdomState();
}

class _wisdomState extends State<wisdom> {
  int _index = 0;

  List quotes = [
    "Your mama is Beautiful",
    "Your mama is Beaut",
    "Your mama is Beautifully famous  ggjjgkdnjsjnsdnjsnjsdnksdjnsjvkdsnvsldnskdvsndkvnjvnsldvnsjdnvsldnvndslkdnvsodniinakdnalj",
    "Your mama is nice"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 350,
                height: 250,
                decoration: BoxDecoration(color: Colors.greenAccent.shade100),
                child: Center(
                    child: Text(
                  quotes[_index % quotes.length],
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ))),
            Divider(
              thickness: 2.3,
              color: Colors.deepPurpleAccent.shade100,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: FlatButton.icon(
                onPressed: _showQuote,
                icon: Icon(
                  Icons.wb_sunny,
                  color: Colors.amberAccent,
                ),
                label: Text(
                  "Inspire me !",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.deepPurple.shade100,
              ),
            ),
            Spacer(),
          ],
        ),
      )),
    );
  }

  void _showQuote() {
    setState(() {
      _index += 1;
    });
  }
}

class bizcard extends StatelessWidget {
  const bizcard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Bizcard",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.menu_outlined,
            color: Colors.deepPurple,
          ),
          onPressed: () {},
        ),
        centerTitle: true,
        backgroundColor: Colors.pink.withOpacity(0.03),
        elevation: 0.0,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[_getcard(), _getavatar()],
        ),
      ),
    );
  }

  Container _getavatar() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          image: DecorationImage(
            image: NetworkImage("https://picsum.photos/seed/picsum/200/300"),
            fit: BoxFit.cover,
          )),
    );
  }

  Container _getcard() {
    return Container(
      width: 350,
      height: 200,
      margin: EdgeInsets.all(30),
      decoration: BoxDecoration(
          color: Colors.pinkAccent, borderRadius: BorderRadius.circular(4.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Shepherd",
                style: TextStyle(
                  fontSize: 20.9,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              )),
          Text("Shepherd.epizy.com"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.person_outlined),
              Text("@shepherrd"),
            ],
          )
        ],
      ),
    );
  }
}

class Scaffoldexample extends StatelessWidget {
  _tappedbutton() {
    debugPrint("Tapped button");
  }

  const Scaffoldexample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
        actions: <Widget>[
          IconButton(
              onPressed: () => debugPrint("youre tapped"),
              icon: Icon(Icons.email)),
          IconButton(onPressed: _tappedbutton, icon: Icon(Icons.alarm))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        child: Icon(Icons.call_missed),
        onPressed: _tappedbutton,
      ),
      // ignore: prefer_const_literals_to_create_immutables
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: ("First"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ac_unit),
            label: ("Second"),
          )
        ],
        onTap: (int index) => debugPrint("Tapped $index"),
      ),
      backgroundColor: Colors.redAccent.shade100,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            Custombutton(),
            // InkWell(
            //   child: Text(
            //     "click me",
            //     style: TextStyle(
            //         fontWeight: FontWeight.w600,
            //         fontStyle: FontStyle.italic,
            //         fontSize: 26.0),
            //   ),
            //   onTap: () => debugPrint("tapped"),
            // )
          ],
        ),
      ),
    );
  }
}

class Custombutton extends StatelessWidget {
  const Custombutton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final snackbar = SnackBar(
          content: Text("hello again"),
        );

        // ignore: deprecated_member_use
        Scaffold.of(context).showSnackBar(snackbar);
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(8.2)),
        child: Text("Button"),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: Colors.deepOrange,
      child: Center(
        child: Text(
          "Hello Flutter ",
          textDirection: TextDirection.ltr,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 23.6,
              fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}

class webview extends StatelessWidget {
  const webview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Emmanuel Oladosu",
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: WebView(
        initialUrl: ("https://emmanueloladosu.com"),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
