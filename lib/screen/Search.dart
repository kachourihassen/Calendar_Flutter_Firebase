import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:login_singup/model/event.dart';
import 'package:login_singup/res/event_firestore_service.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';

class Search extends StatefulWidget {
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  final _debouncer = Debouncer(milliseconds: 10000);
  final hashTagAtSignRegExp =
      RegExp("(?!\\n)(?:^|\\s)([#@]([$detectionContentLetters]+))");
  TextEditingController _desccontroller = TextEditingController();
   TextEditingController _searchcontroller = TextEditingController();
  String currentuser = FirebaseAuth.instance.currentUser.uid;
  bool checkedValue = false;
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('Tasks').doc();
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _desccontroller.dispose();
    _searchcontroller.dispose();
 
    super.dispose();
  }

  List<TasksModel> events;
  DateTime _chosenDateTime;
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    var firestoredb = FirebaseFirestore.instance
        .collection('Tasks')
        .orderBy('date', descending: true)
        .snapshots();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      body: Stack(children: <Widget>[
        (Column(children: [
          buildTextField(Icons.search, "Search...", false, false, '',_searchcontroller),
          Container(
            constraints: BoxConstraints.tightFor(height: 535.0),
            //height: 535,
            child: StreamBuilder(
                stream: firestoredb,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                            color: Colors.white,
                          ),
                      addAutomaticKeepAlives: true,
                      cacheExtent: 100,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, int index) {
                        if (snapshot.data.docs[index]['iduser'] ==
                            currentuser) {
                          return InkWell(
                            child: tasks(
                                snapshot.data.docs[index]['catigorie'],
                                snapshot.data.docs[index]['title'],
                                snapshot.data.docs[index]['description'],
                                snapshot.data.docs[index]['date'],
                                snapshot.data.docs[index].id,
                                selected,
                                index,snapshot.data.docs[index]['color'],),
                                
                            onTap: () {
                              setState(() {});
                            },
                          );
                          // );
                        } else {
                          return Container();
                        }
                      });
                }),
          )
        ])),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.44,
          //left: MediaQuery.of(context).size.height * 0.36,
          right: 0,
          bottom: 0,
          child: Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    onTap: () {
                      // print("voise");
                    },
                    child: Image.asset(
                      ('images/voice.png'),
                      height: 90,
                    ),
                  ),
                ]),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.615,
          //left: MediaQuery.of(context).size.height * 0.36,
          right: 0,
          bottom: 0,
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                    onTap: () async {
                      final ref =
                          FirebaseFirestore.instance.collection('Tasks').doc();
                      await eventDBS.create({
                        'docID': ref.id,
                        "iduser": FirebaseAuth.instance.currentUser.uid,
                        "catigorie": " ",
                        "title": "",
                        "description": "",
                        "date": DateTime.utc(1),
                        "color": " ",
                        "location": "",
                        "isChecked": false
                      });
                    },
                    child: Row(children: [
                      Image.asset(
                        ('images/add.png'),
                        height: 90,
                      ),
                    ])),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget tasks(String catigorie, String title, String description,
      Timestamp date, String id, bool selected, int index,String color) {
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Center(
          child: ExpandableNotifier(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color.fromRGBO(0, 0, 0, 0.06),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 2.50,
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: 20,
                            child: Row(
                              children: [
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 0, 0, 0)),
                               
                                 Icon(
                                  Icons.circle_outlined,
                                  color:  color == " " ? Colors.grey :Color(int.parse(color)) ,
                                  size: 24.0,
                                ),
                              
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(6, 0, 0, 0)),
                                Text(
                                  catigorie,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 220,
                                  child: TextFormField(
                                    //keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: null,
                                    initialValue: title,
                                    autofocus: false,
                                    style: TextStyle(
                                        fontSize: 17.0, color: Colors.black),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.only(
                                          left: 5.0, bottom: 8.0, top: 8.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(25.7),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(25.7),
                                      ),
                                    ),
                                    onChanged: (text) async {
                                      await FirebaseFirestore.instance
                                          .collection('Tasks')
                                          .doc(id)
                                          .set({
                                        'docID': id,
                                        "iduser": FirebaseAuth
                                            .instance.currentUser.uid,
                                        "catigorie": catigorie,
                                        "title": text,
                                        "description": description,
                                        "date": date,
                                        "color": color,
                                        "location": "",
                                        "isChecked": selected
                                      });

                                      print(text);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ScrollOnExpand(
                      scrollOnExpand: true,
                      scrollOnCollapse: false,
                      child: ExpandablePanel(
                        theme: const ExpandableThemeData(
                          hasIcon: false,
                          headerAlignment:
                              ExpandablePanelHeaderAlignment.center,
                          tapBodyToCollapse: true,
                        ),
                        header: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                        collapsed: Column(children: [
                          SizedBox(
                            height: 15,
                          ),
                          DetectableText(
                            text: description,
                            detectionRegExp: detectionRegExp(),
                            softWrap: true,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]),
                        expanded: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 15,
                            ),
                            DetectableTextField(
                              //autofocus: true,
                              maxLines: null,
                              detectionRegExp: detectionRegExp(),
                              controller: _desccontroller =
                                  TextEditingController.fromValue(
                                      new TextEditingValue(
                                          text: description,
                                          selection:
                                              new TextSelection.collapsed(
                                                  offset: description.length))),
                              onChanged: (text) async {
                                // var cursorPos =
                                //     _desccontroller.selection.base.offset;
                                // print(cursorPos);
                                _debouncer.run(() async {
                                  await FirebaseFirestore.instance
                                      .collection('Tasks')
                                      .doc(id)
                                      .set({
                                    'docID': id,
                                    "iduser":
                                        FirebaseAuth.instance.currentUser.uid,
                                    "catigorie": catigorie,
                                    "title": title,
                                    "description": text,
                                    "date": date,
                                    "color": color,
                                    "location": "",
                                    "isChecked": selected
                                  });
                                });
                              },
                            ),
                          ],
                        ),
                        builder: (_, collapsed, expanded) {
                          return Padding(
                            padding:
                                EdgeInsets.only(left: 20, right: 10, bottom: 0),
                            child: Expandable(
                              collapsed: collapsed,
                              expanded: expanded,
                              theme:
                                  const ExpandableThemeData(crossFadePoint: 0),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        if (DateTime.parse(date.toDate().toString()).year ==
                            1) ...[
                          SizedBox(
                            width: 143,
                          ),
                        ] else ...[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(17, 0, 5, 0),
                              child: Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.blue,
                                size: 16.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 34,
                          ),
                          Text(
                            DateTime.parse(date.toDate().toString())
                                    .day
                                    .toString() +
                                " " +
                                months[DateTime.parse(date.toDate().toString())
                                        .month -
                                    1],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Icon(
                                Icons.access_time,
                                color: Colors.blue,
                                size: 16.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            DateFormat.Hm().format(date.toDate()),
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                        SafeArea(
                          child: setting(catigorie, title, description, date,
                              id, selected, index,color),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

//FlutterClipboard.copy(item.code).then((value) {})
  Widget setting(String catigorie, String title, String description,
      Timestamp date, String id, bool selected, int index,String color) {
    var firestoredbCategorie =
        FirebaseFirestore.instance.collection('Categorie').snapshots();
    return Padding(
      padding: const EdgeInsets.fromLTRB(153, 0, 0, 0),
      child: Container(
        child: Row(children: [
          IconButton(
            icon: new Image.asset('images/Group 352@2x.png',
                width: 19, height: 19),
            onPressed: () {
              showModalBottomSheet<void>(
                  barrierColor: Colors.black12,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                        height: 400,
                        color: Colors.black12, // Color(0xFF737373),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0))),
                          child: ListView(children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(150, 0, 0, 0),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Container(
                                  child: Row(
                                    children: [
                                      // ignore: deprecated_member_use
                                      RaisedButton(
                                          elevation: 0,
                                          hoverElevation: 0,
                                          focusElevation: 0,
                                          highlightElevation: 0,
                                          color: Colors.white,
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Row(children: [
                                            Image.asset(('images/st.png'),
                                                width: 80),
                                          ])),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  // ignore: deprecated_member_use
                                  RaisedButton(
                                      elevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      color: Colors.white,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showModalBottomSheet<void>(
                                            barrierColor: Colors.black12,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                  height: 200,
                                                  color: Colors
                                                      .black12, //Color(0xFF737373),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          30.0))),
                                                      child: ListView(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      140,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child:
                                                                    Container(
                                                                  child: Row(
                                                                    children: [
                                                                      // ignore: deprecated_member_use
                                                                      RaisedButton(
                                                                          elevation:
                                                                              0,
                                                                          hoverElevation:
                                                                              0,
                                                                          focusElevation:
                                                                              0,
                                                                          highlightElevation:
                                                                              0,
                                                                          color: Colors
                                                                              .white,
                                                                          onPressed: () => Navigator.pop(
                                                                              context),
                                                                          child:
                                                                              Row(children: [
                                                                            Image.asset(('images/copierasmenu.png'),
                                                                                width: 80),
                                                                          ])),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      0,
                                                                      0),
                                                            ),
                                                            Container(
                                                              child: Row(
                                                                children: [
                                                                  // ignore: deprecated_member_use
                                                                  RaisedButton(
                                                                      elevation:
                                                                          0,
                                                                      hoverElevation:
                                                                          0,
                                                                      focusElevation:
                                                                          0,
                                                                      highlightElevation:
                                                                          0,
                                                                      color: Colors
                                                                          .white,
                                                                      onPressed:
                                                                          () {},
                                                                      child: Row(
                                                                          children: [
                                                                            Image.asset(
                                                                              ('images/HTML@3x.png'),
                                                                              width: 22,
                                                                            ),
                                                                            Padding(padding: const EdgeInsets.fromLTRB(13, 0, 0, 0)),
                                                                            Text('HTML'),
                                                                          ])),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      0,
                                                                      0),
                                                            ),
                                                            Container(
                                                              child: Row(
                                                                children: [
                                                                  // ignore: deprecated_member_use
                                                                  RaisedButton(
                                                                      elevation:
                                                                          0,
                                                                      hoverElevation:
                                                                          0,
                                                                      focusElevation:
                                                                          0,
                                                                      highlightElevation:
                                                                          0,
                                                                      color: Colors
                                                                          .white,
                                                                      onPressed:
                                                                          () {},
                                                                      child: Row(
                                                                          children: [
                                                                            Image.asset(('images/Text@3x.png'),
                                                                                width: 22),
                                                                            Padding(padding: const EdgeInsets.fromLTRB(13, 0, 0, 0)),
                                                                            Text('Plain Text'),
                                                                          ])),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      0,
                                                                      0),
                                                            ),
                                                            Container(
                                                              child: Row(
                                                                children: [
                                                                  // ignore: deprecated_member_use
                                                                  RaisedButton(
                                                                      elevation:
                                                                          0,
                                                                      hoverElevation:
                                                                          0,
                                                                      focusElevation:
                                                                          0,
                                                                      highlightElevation:
                                                                          0,
                                                                      color: Colors
                                                                          .white,
                                                                      onPressed:
                                                                          () {},
                                                                      child: Row(
                                                                          children: [
                                                                            Image.asset(('images/XML@3x.png'),
                                                                                width: 22),
                                                                            Padding(padding: const EdgeInsets.fromLTRB(13, 0, 0, 0)),
                                                                            Text('XML'),
                                                                          ])),
                                                                ],
                                                              ),
                                                            ),
                                                          ])));
                                            });
                                      },
                                      child: Row(children: [
                                        Image.asset(
                                          ('images/copieor.png'),
                                          width: 20,
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                13, 0, 0, 0)),
                                        Text('Copy As'),
                                      ])),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  // ignore: deprecated_member_use
                                  RaisedButton(
                                      elevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      color: Colors.white,
                                      onPressed: () {},
                                      child: Row(children: [
                                        Image.asset(('images/bell.png'),
                                            width: 18),
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                13, 0, 0, 0)),
                                        Text('Notification'),
                                      ])),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  // ignore: deprecated_member_use
                                  RaisedButton(
                                      elevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      color: Colors.white,
                                      onPressed: () {},
                                      child: Row(children: [
                                        Image.asset(('images/share.png'),
                                            width: 22),
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                13, 0, 0, 0)),
                                        Text('Share'),
                                      ])),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  // ignore: deprecated_member_use
                                  RaisedButton(
                                      elevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      color: Colors.white,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showModalBottomSheet<void>(
                                            barrierColor: Colors.black12,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                  height: 400,
                                                  color: Colors.black12,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          30.0))),
                                                      // child: Column(children: [
                                                      //   // GestureDetector(
                                                      //   //   onTap: () {
                                                      //   //     setState(
                                                      //   //       () {
                                                      //   //         Navigator.pop(
                                                      //   //             context);
                                                      //   //       },
                                                      //   //     );
                                                      //   //   },
                                                      //   //   // child: Center(
                                                      //   //   child: Text(
                                                      //   //       "Choose Catégorie"),
                                                      //   // ),
                                                      //   TextButton(
                                                      //     onPressed: () {
                                                      //       Navigator.pop(
                                                      //           context);
                                                      //     },
                                                      //     style: TextButton
                                                      //         .styleFrom(
                                                      //       primary:
                                                      //           Colors.black,
                                                      //     ),
                                                      //     child: Text(
                                                      //       'Choose Catégorie',
                                                      //       style: TextStyle(
                                                      //           fontSize: 20),
                                                      //     ),
                                                      //   ),
                                                      //   SizedBox(
                                                      //     height: 25,
                                                      //   ),

                                                      child: ListView(
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        physics:
                                                            ClampingScrollPhysics(),
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            style: TextButton
                                                                .styleFrom(
                                                              primary:
                                                                  Colors.black,
                                                            ),
                                                            child: Text(
                                                              'Choose Catégorie',
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 25,
                                                          ),
                                                          StreamBuilder(
                                                              stream:
                                                                  firestoredbCategorie,
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (!snapshot
                                                                    .hasData)
                                                                  return CircularProgressIndicator();
                                                                return new SizedBox(
                                                                  height: 300.0,
                                                                  child: new ListView
                                                                          .separated(
                                                                      separatorBuilder:
                                                                          (context, index) =>
                                                                              Divider(
                                                                                color: Colors.white,
                                                                              ),
                                                                      addAutomaticKeepAlives:
                                                                          true,
                                                                      cacheExtent:
                                                                          100,
                                                                      shrinkWrap:
                                                                          true,
                                                                      scrollDirection:
                                                                          Axis
                                                                              .vertical,
                                                                      itemCount: snapshot
                                                                          .data
                                                                          .docs
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              int index) {
                                                                        if (snapshot.data.docs[index]['iduser'] ==
                                                                            currentuser) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              setState(
                                                                                () {
                                                                                  FirebaseFirestore.instance.collection('Tasks').doc(id).set({
                                                                                    'docID': id,
                                                                                    "iduser": FirebaseAuth.instance.currentUser.uid,
                                                                                    "catigorie": catigorie,
                                                                                    "title": title,
                                                                                    "description": description,
                                                                                    "date": date,
                                                                                    "color": snapshot.data.docs[index]["color"].substring(6, 16),
                                                                                    "location": "",
                                                                                    "isChecked": selected
                                                                                  });
                                                                                  Navigator.pop(context);
                                                                                  print("color is" + snapshot.data.docs[index]["color"].substring(6, 16));
                                                                                },
                                                                              );
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              margin: EdgeInsets.only(left: 10, top: 1, right: 10, bottom: 1),
                                                                              height: 40,
                                                                              width: 15,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(1), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: Colors.grey.withOpacity(0.5),
                                                                                    spreadRadius: 2,
                                                                                    blurRadius: 7,
                                                                                    offset: Offset(0, 3),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                                                                                child: Row(children: [
                                                                                  Expanded(
                                                                                    child: Icon(
                                                                                      Icons.circle_outlined,
                                                                                      color: Color(int.parse(snapshot.data.docs[index]["color"].substring(6, 16))),
                                                                                      size: 20,
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                      child: Text(
                                                                                    snapshot.data.docs[index]['categorie'],
                                                                                    style: TextStyle(fontSize: 18),
                                                                                  )),
                                                                                ]),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          return Container();
                                                                        }
                                                                      }),
                                                                );
                                                              }),
                                                        ],
                                                      )));
                                            });
                                      },
                                      child: Row(children: [
                                        Image.asset(('images/moveto.png'),
                                            width: 24),
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                13, 0, 0, 0)),
                                        Text('Move To'),
                                      ])),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  // ignore: deprecated_member_use
                                  RaisedButton(
                                      elevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      color: Colors.white,
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        DocumentReference documentReferencer =
                                            FirebaseFirestore.instance
                                                .collection('Tasks')
                                                .doc(id);

                                        await documentReferencer
                                            .delete()
                                            .whenComplete(() => print(
                                                'Note item deleted from the database'))
                                            .catchError((e) => print(e));
                                      },
                                      child: Row(children: [
                                        Image.asset(('images/delete.png'),
                                            width: 18.0),
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                13, 0, 0, 0)),
                                        Text('Delete'),
                                      ])),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  // ignore: deprecated_member_use
                                  RaisedButton(
                                      elevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      color: Colors.white,
                                      onPressed: () {
                                        getImage();
                                      },
                                      child: Row(children: [
                                        Image.asset(('images/attache.png'),
                                            width: 24),
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                13, 0, 0, 0)),
                                        Text('Attach'),
                                      ])),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  // ignore: deprecated_member_use
                                  RaisedButton(
                                      elevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      color: Colors.white,
                                      onPressed: () => _showAddDialog(
                                          context,
                                          date,
                                          id,
                                          catigorie,
                                          title,
                                          description,color),
                                      child: Row(children: [
                                        Image.asset(('images/covert.png'),
                                            width: 22),
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                13, 0, 0, 0)),
                                        Text('Convert to Task'),
                                      ])),
                                ],
                              ),
                            ),
                          ]),
                        ));
                  });
            },
          ),
        ]),
      ),
    );
  }

  _showAddDialog(ctx, date, id, catigorie, title, description,color) async {
    await showDialog(
        barrierColor: Colors.black12,
        context: context,
        builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            title: Stack(children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                child: Text("Set Time and Date "),
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(60, 50, 0, 0),
              //   child: Text(_chosenDateTime.toString()),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(60, 50, 0, 0),
                child: Row(children: <Widget>[
                  if (DateTime.parse(date.toDate().toString()).year == 1) ...[
                    SizedBox(
                      width: 143,
                    ),
                  ] else ...[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 5, 0),
                        child: Text(
                          DateTime.parse(date.toDate().toString())
                                  .day
                                  .toString() +
                              " " +
                              months[DateTime.parse(date.toDate().toString())
                                      .month -
                                  1] +
                              " " +
                              DateTime.parse(date.toDate().toString())
                                  .hour
                                  .toString()
                                  .padLeft(2, '0') +
                              ":" +
                              (DateTime.parse(date.toDate().toString()).minute)
                                  .toString()
                                  .padLeft(2, '0'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ]
                ]),
              )
            ]),
            content: Container(
              height: 430,
              width: 3000,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 350,
                    child: CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (val) {
                          setState(() {
                            _chosenDateTime = val;
                          });
                        }),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                HexColor("#FFAC4F")),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.0),
                                    side: BorderSide(
                                        color: HexColor("#FFAC4F"))))),
                        child: Text('Confirm'),
                        onPressed: () async {
                          _chosenDateTime == null
                              ? _chosenDateTime = DateTime.now()
                              : await FirebaseFirestore.instance
                                  .collection('Tasks')
                                  .doc(id)
                                  .set({
                                  'docID': id,
                                  "iduser":
                                      FirebaseAuth.instance.currentUser.uid,
                                  "catigorie": catigorie,
                                  "title": title,
                                  "description": description,
                                  "date": _chosenDateTime,
                                  "color": color,
                                  "location": "",
                                  "isChecked": selected
                                });
                          Navigator.of(ctx).pop();
                        }),
                  )
                ],
              ),
            )));
  }
}

Widget buildTextField(
    IconData icon, String hintText, bool isPassword, bool isEmail, String msg,TextEditingController controller) {
  return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, left: 10, right: 10),
      child: TextFormField(
          obscureText: isPassword,
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: HexColor("#FFAC4F"),
            ),
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
            contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            hintStyle: TextStyle(
              fontSize: 14,
              color: HexColor("#8A8A8A"),
            ),

            suffixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: IconButton(
                onPressed: () {},
                // icon: new Image.asset('images/Vector.png', width: 30, height: 30),
                icon: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Image.asset('images/Line.png', width: 5, height: 30),
                      new Image.asset('images/Vector.png',
                          width: 20, height: 50),
                    ]),
              ),
            ),
          )));
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

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class CustomCard {
  final bool isActive;
  final String text;
  final IconData iconData;
  final VoidCallback onTap;

  const CustomCard({
    this.isActive,
    this.text,
    this.iconData,
    this.onTap,
  });
}
