import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_singup/screen/Search.dart';

import 'package:login_singup/screen/login_signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Calendra.dart';
import 'ListPage.dart';
import 'SettingPage.dart';
import 'dart:ui' as ui;
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import 'google.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  String isCheckedcolor;
  String categorie;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _titlecontroller = TextEditingController();
  bool isCheck = true;
  final List<String> titleList = ["Timeline", "Inbox", "Settings", "Search"];
  String currentTitle;
  List<Widget> interfaces = [TasksPage(), ListPage(), SettingsPage(),Search()];
  int x = 0;
  int y = 0;
  double screenWidth =
      ui.window.physicalSize.width / ui.window.devicePixelRatio;
  double screenHeight =
      ui.window.physicalSize.height / ui.window.devicePixelRatio;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future getdata() async {
    var fireb = FirebaseFirestore.instance;
    QuerySnapshot qn = await fireb.collection("Categorie").get();
    return qn.docs;
  }

  Future getdataupdate() async {
    var fireb = FirebaseFirestore.instance;
    QuerySnapshot qn = await fireb.collection("Tasks").get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.grey[50],
          title: Text(
            titleList[x],
            style: TextStyle(
              backgroundColor: Colors.grey[50],
              fontWeight: FontWeight.w400,
              color: Colors.black54,
              //fontStyle: FontStyle.italic,
              fontSize: 20.0,
            ),
          ),
          actions: x == 2
              ? <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: HexColor("#FFAC4F"),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs?.clear();
                        await _firebaseAuth.signOut();
                        signOutGoogle();
                        fbSignout();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginSignupScreen()));
                      })
                ]
              : null,
          leading: new IconButton(
            icon: Image.asset('images/HamburgerMenugouche.png',
                fit: BoxFit.contain, width: 25, height: 25),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
          centerTitle: true,
          //backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(
            color: HexColor("#FFAC4F"),
            size: 10,
          ),
        ),
        drawer: Drawer(
            child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  actions: <Widget>[
                    IconButton(
                      icon: new Image.asset('images/HamburgerMenudroit.png',
                          width: 25, height: 25),
                      color: HexColor("#FFAC4F"),
                      onPressed: () {
                        _scaffoldKey.currentState.openEndDrawer();
                      },
                    ),
                  ],
                  iconTheme: IconThemeData(
                    color: HexColor("#FFAC4F"),
                    size: 10,
                  ),
                ),
                body: InkWell(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 180, 0),
                        child: Text("Recent Notes"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 150,
                        child: FutureBuilder(
                            future: getdataupdate(),
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: Text("Loading"),
                                );
                              } else {
                                snapshot.data.length > 3
                                    ? y = 3
                                    : y = snapshot.data.length;
                                return ListView.builder(
                                    itemCount: y,
                                    itemBuilder: (_, index) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 10, 0, 0),
                                        child: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.circle_outlined,
                                              color: Colors.grey,
                                              size: 18,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              snapshot.data[index]["title"],
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: HexColor("#696969"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              }
                            }),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              'images/displaynote.png',
                              fit: BoxFit.cover,
                              height: 84.6,
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 0, 0),
                                child: Text("Categories",
                                    style: TextStyle(
                                      // fontSize: 18.0,
                                      color: HexColor("#000000"),
                                    ))),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: IconButton(
                              icon: new Image.asset('images/category.png',
                                  width: 25, height: 25),
                              onPressed: () {
                                _scaffoldKey.currentState.openEndDrawer();
                                _showAddDialog(context);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      Expanded(
                          child: Container(
                        child: FutureBuilder(
                            future: getdata(),
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: Text("Loading"),
                                );
                              } else {
                                return ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (_, index) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 10, 0, 0),
                                        child: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.circle_outlined,
                                              color: Color(int.parse(snapshot
                                                  .data[index]["color"]
                                                  .substring(6, 16))),
                                              size: 18,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              snapshot.data[index]["categorie"],
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: HexColor("#696969"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              }
                            }),
                      )),
                    ],
                  ),
                ))),

        // body: ListView(padding: EdgeInsets.zero, children: <Widget>[
        body: Stack(children: <Widget>[
          interfaces[x],
          Stack(
              alignment: Alignment.center,
              textDirection: TextDirection.rtl,
              fit: StackFit.loose,
              overflow: Overflow.visible,
              clipBehavior: Clip.hardEdge,
              children: <Widget>[
                Positioned(
                    //top: MediaQuery.of(context).size.height * 0.790,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                child: Column(children: [
                              Container(
                                  width: 390,
                                  child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Card(
                                        elevation: 2,
                                        shape: new RoundedRectangleBorder(
                                            side: new BorderSide(
                                                color: HexColor("#FFAC4F"),
                                                width: 0.7),
                                            borderRadius:
                                                BorderRadius.circular(40.0)),
                                        child: new Row(
                                          children: <Widget>[
                                            new Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0.0, 0.0, 10.0, 60.0),
                                            ),
                                            Tab(
                                                child: new SizedBox(
                                                    child: Ink(
                                                        decoration: x == 0
                                                            ? BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: HexColor(
                                                                      "#FFAC4F"),
                                                                  width: 0.0,
                                                                ),
                                                                color: HexColor(
                                                                    "#FFAC4F"),
                                                                shape: BoxShape
                                                                    .circle,
                                                              )
                                                            : null,
                                                        height: 45.0,
                                                        width: 45.0,
                                                        child: new IconButton(
                                                          padding:
                                                              new EdgeInsets
                                                                  .all(0.0),
                                                          color: Colors.white,
                                                          icon: x == 0
                                                              ? new Image.asset(
                                                                  'images/listblanc.png',
                                                                  width: 30,
                                                                  height: 30)
                                                              : Image.asset(
                                                                  'images/list.png',
                                                                  width: 35,
                                                                  height: 35),
                                                          onPressed: () {
                                                            x = 0;
                                                            setState(() {});
                                                          },
                                                        )))),
                                            new Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      102.0, 0.0, 10.0, 0.0),
                                            ),
                                            Tab(
                                                // child: new SizedBox(
                                                //     // height: 45.0,
                                                //     // width: 45.0,
                                                child: Ink(
                                                    decoration: x == 1
                                                        ? BoxDecoration(
                                                            border: Border.all(
                                                              color: HexColor(
                                                                  "#FFAC4F"),
                                                              width: 0.0,
                                                            ),
                                                            color: HexColor(
                                                                "#FFAC4F"),
                                                            shape:
                                                                BoxShape.circle,
                                                          )
                                                        : null,
                                                    height: 45.0,
                                                    width: 45.0,
                                                    child: new IconButton(
                                                      padding:
                                                          new EdgeInsets.all(
                                                              0.0),
                                                      icon: x == 1
                                                          ? new Image.asset(
                                                              'images/homeblanc.png',
                                                              width: 35,
                                                              height: 35)
                                                          : Image.asset(
                                                              'images/home.png',
                                                              width: 35,
                                                              height: 35),
                                                      onPressed: () {
                                                        x = 1;
                                                        setState(() {});
                                                      },
                                                    ))),
                                            new Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      105.0, 0.0, 10.0, 0.0),
                                            ),
                                            Tab(
                                              child: new SizedBox(
                                                  height: 45.0,
                                                  width: 45.0,
                                                  child: Ink(
                                                      decoration: x == 2
                                                          ? BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                color: HexColor(
                                                                    "#FFAC4F"),
                                                                width: 0.0,
                                                              ),
                                                              color: HexColor(
                                                                  "#FFAC4F"),
                                                              shape: BoxShape
                                                                  .circle,
                                                            )
                                                          : null,
                                                      child: new IconButton(
                                                        padding:
                                                            new EdgeInsets.all(
                                                                0.0),
                                                        icon: x == 2
                                                            ? new Image.asset(
                                                                'images/settingblanc.png',
                                                                width: 35,
                                                                height: 35)
                                                            : Image.asset(
                                                                'images/setting.png',
                                                                width: 35,
                                                                height: 35),
                                                        onPressed: () {
                                                          x = 2;
                                                          setState(() {});
                                                        },
                                                      ))),
                                            )
                                          ],
                                        ),
                                      )))
                            ])),
                          ]),
                    )
                    //)
                    )
              ]),
        ]));
  }

  _showAddDialog(ctx) async {
    await showDialog(
        barrierColor: Colors.black12,
        context: context,
        builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 12),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            title: Stack(children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
                child: Text(
                  "Add New Category",
                  style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            content: Container(
              height: 350,
              width: 400,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: _titlecontroller,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor("#8A8A8A")),
                        borderRadius: BorderRadius.all(Radius.circular(35.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HexColor("#8A8A8A"),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(35.0)),
                      ),
                      //contentPadding: EdgeInsets.all(10),
                      hintText: "Title",
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10.0),
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: HexColor("#8A8A8A"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 110, 0),
                    child: Text("Choose a Category Color"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                    child: MaterialColorPicker(
                      onColorChange: (Color color) {
                        isCheckedcolor = color.toString();
                      },
                      selectedColor: Colors.blue,
                      colors: [
                        Colors.blue,
                        Colors.red,
                        Colors.green,
                        Colors.orange
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              HexColor("#FFAC4F")),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                      side: BorderSide(
                                          color: HexColor("#FFAC4F"))))),
                      child: Text('Add Category'),
                      onPressed: () {
                        setState(() {
                          final ref = FirebaseFirestore.instance
                              .collection('Categorie')
                              .doc();
                          FirebaseFirestore.instance
                              .collection('Categorie')
                              .add({
                            'docID': ref.id,
                            "iduser": FirebaseAuth.instance.currentUser.uid,
                            "categorie": _titlecontroller.text,
                            "color": isCheckedcolor,
                          });
                          print(ref.id);
                          Navigator.of(ctx).pop();
                        });
                      },
                    ),
                  )
                ],
              ),
            )));
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

Widget buildTextFieldAlert(String hintText, bool isPassword, bool isEmail,
    String msg, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: HexColor("#8A8A8A")),
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: HexColor("#8A8A8A"),
          ),
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
        ),
        //contentPadding: EdgeInsets.all(10),
        hintText: hintText,
        contentPadding:
            new EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
        hintStyle: TextStyle(
          fontSize: 14,
          color: HexColor("#8A8A8A"),
        ),
      ),
    ),
  );
}
