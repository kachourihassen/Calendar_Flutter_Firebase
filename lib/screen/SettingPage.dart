import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_singup/model/users.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser;
  final uid = FirebaseAuth.instance.currentUser.uid;
  TextEditingController _locationcontroller = TextEditingController();

  // var name = FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(FirebaseAuth.instance.currentUser.uid)
  //     .get()
  //     .then((value) {
  //   return value.data()['prenom'];
  // });

  final _uemail = FirebaseAuth.instance.currentUser.email;

  List<UsersModel> events;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        isAlwaysShown: true,
        showTrackOnHover: true,
        child: ListView(
            physics: PageScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 2, 0, 5),
                child: Text(
                  "Account",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        spreadRadius: 10,
                        blurRadius: 22,
                        offset: Offset(0, 1), // Shadow position
                      ),
                    ],
                  ),
                  child: Card(
                      elevation: 1.5,
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: new Row(children: <Widget>[
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 60.0),
                        ),
                        Tab(
                            child: new SizedBox(
                          child: Ink(
                            child: Row(
                              children: [
                                new Image.asset(
                                  'images/person.png',
                                  width: 20.0,
                                  height: 20.0,
                                  fit: BoxFit.cover,
                                ),
                                // Icon(
                                //   Icons.perm_identity,
                                //   color: Colors.grey,
                                //   size: 28,
                                // ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Name",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(120, 0, 0, 0),
                                  child: Text(
                                    "",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                      ])),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        spreadRadius: 0,
                        blurRadius: 12,
                        offset: Offset(0, 1), // Shadow position
                      ),
                    ],
                  ),
                  child: Card(
                      elevation: 1.5,
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: new Row(children: <Widget>[
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 60.0),
                        ),
                        Tab(
                            child: new SizedBox(
                          child: Ink(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.markunread_outlined,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Email",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(85, 0, 0, 0),
                                  child: Text(
                                    _uemail.toString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                      ])),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 10, 0, 10),
                child: Text(
                  "App Settings",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        spreadRadius: 0,
                        blurRadius: 12,
                        offset: Offset(0, 1), // Shadow position
                      ),
                    ],
                  ),
                  child: Card(
                      elevation: 1.5,
                      //shadowColor: Colors.black12,
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: new Row(children: <Widget>[
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 60.0),
                        ),
                        Tab(
                            child: new SizedBox(
                          child: Ink(
                            child: Row(
                              children: [
                                // new Image.asset(
                                //   'images/person.png',
                                //   width: 20.0,
                                //   height: 20.0,
                                //   fit: BoxFit.cover,
                                // ),
                                Icon(
                                  Icons.notifications_none,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Receive Notifications",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(130, 0, 0, 0),
                                  child: buildNotificationOptionRow("", false),
                                ),
                              ],
                            ),
                          ),
                        ))
                      ])),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        spreadRadius: 0,
                        blurRadius: 12,
                        offset: Offset(0, 1), // Shadow position
                      ),
                    ],
                  ),
                  child: Card(
                      elevation: 1.5,
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: new Row(children: <Widget>[
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 60.0),
                        ),
                        Tab(
                            child: new SizedBox(
                          child: Ink(
                            child: Row(
                              children: [
                                new Image.asset(
                                  'images/tailletext.png',
                                  width: 20.0,
                                  height: 20.0,
                                  fit: BoxFit.cover,
                                ),
                                // Icon(
                                //   Icons.text_fields_sharp,
                                //   color: Colors.grey,
                                // ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Text size",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(170, 0, 0, 0),
                                  //expand_more
                                  child:
                                      buildAccountOptionRow1(context, "Meduim"),
                                ),
                              ],
                            ),
                          ),
                        ))
                      ])),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        spreadRadius: 0,
                        blurRadius: 12,
                        offset: Offset(0, 1), // Shadow position
                      ),
                    ],
                  ),
                  child: Card(
                      elevation: 1.5,
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: new Row(children: <Widget>[
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 60.0),
                        ),
                        Tab(
                            child: new SizedBox(
                          child: Ink(
                            child: Row(
                              children: [
                                new Image.asset(
                                  'images/copie.png',
                                  width: 20.0,
                                  height: 20.0,
                                  fit: BoxFit.cover,
                                ),
                                // Icon(
                                //   Icons.file_copy_outlined,
                                //   color: Colors.grey,
                                // ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Terms of Service",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(180, 0, 0, 0),
                                  child: buildAccountOptionRow(context, ""),
                                ),
                              ],
                            ),
                          ),
                        ))
                      ])),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        spreadRadius: 0,
                        blurRadius: 12,
                        offset: Offset(0, 1), // Shadow position
                      ),
                    ],
                  ),
                  child: Card(
                      elevation: 1.5,
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: new Row(children: <Widget>[
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 60.0),
                        ),
                        Tab(
                            child: new SizedBox(
                          child: Ink(
                            child: Row(
                              children: [
                                new Image.asset(
                                  'images/hand.png',
                                  width: 25.0,
                                  height: 25.0,
                                  //fit: BoxFit.cover,
                                ),
                                // Icon(
                                //   Icons.pan_tool_outlined,
                                //   color: Colors.grey,
                                // ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Privacy Policy",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(187, 0, 0, 0),
                                  child: buildAccountOptionRow(context, ""),
                                ),
                              ],
                            ),
                          ),
                        ))
                      ])),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 10, 0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        spreadRadius: 0,
                        blurRadius: 12,
                        offset: Offset(0, 1), // Shadow position
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _showAddDialog(context);
                    },
                    child: Card(
                        elevation: 1.5,
                        shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: new Row(children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 0.0, 10.0, 60.0),
                          ),
                          Tab(
                              child: new SizedBox(
                            child: Ink(
                              child: Row(
                                children: [
                                  new Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.grey,
                                    size: 28,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Location",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          ))
                        ])),
                  ),
                ),
              ),
            ]),
      ),
    );
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
                  "Add New Location",
                  style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            content: Container(
              height: 150,
              width: 400,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: _locationcontroller,
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
                      hintText: "Location",
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
                      child: Text('Add Location'),
                      onPressed: () {
                        setState(() {
                          final ref = FirebaseFirestore.instance
                              .collection('Location')
                              .doc();
                          FirebaseFirestore.instance
                              .collection('Location')
                              .add({
                            'docID': ref.id,
                            "iduser": FirebaseAuth.instance.currentUser.uid,
                            "location": _locationcontroller.text,
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

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w100,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              trackColor: HexColor("#FFAC4F"),
              value: isActive,
              onChanged: (bool val) {},
            ))
      ],
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Option 1"),
                    Text("Option 2"),
                    Text("Option 3"),
                  ],
                ),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close")),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
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

GestureDetector buildAccountOptionRow1(BuildContext context, String title) {
  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Small"),
                  Text("Meduim"),
                  Text("large"),
                ],
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Close")),
              ],
            );
          });
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              color: Colors.grey[600],
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_outlined,
            color: Colors.grey,
            size: 36,
          ),
        ],
      ),
    ),
  );
}
