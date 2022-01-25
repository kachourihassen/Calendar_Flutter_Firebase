import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_singup/model/event.dart';
import 'package:login_singup/res/event_firestore_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class TasksPage extends StatefulWidget {
  final Function(BuildContext) builder;
  const TasksPage({Key key, this.builder}) : super(key: key);
  @override
  _TasksPageState createState() => _TasksPageState();
  static _TasksPageState of(BuildContext context) {
    return context.findAncestorStateOfType<_TasksPageState>();
    //return context.ancestorStateOfType(const TypeMatcher<AppBuilderState>());
  }
}

class _TasksPageState extends State<TasksPage> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  DateTime _chosenDate = DateTime.now();
  String currentuser = FirebaseAuth.instance.currentUser.uid;
  final ref = FirebaseDatabase.instance.reference();
  bool isChecked = true;
  var firestoredb = FirebaseFirestore.instance.collection('Tasks').snapshots();
  final databaseReferenceTest =
      FirebaseDatabase.instance.reference().child('Tasks');

  void main() {
    runApp(
      Phoenix(
        child: TasksPage(),
      ),
    );
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
  List<Offset> pointList = <Offset>[];

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
  }

// listenDataFromFireBase() {
//     var db = FirebaseDatabase.instance.reference().child("messages");
//     db.child(chatroom.chatId).onChildAdded.listen((data) {
//       print("GET_NEW_DATA");
//       print(data.snapshot.value["message"] ?? '');
//       print(data.snapshot.value["fromUser"] ?? false);
//       print(data.snapshot.value["timestamp"] ?? '');
//     });
//   }
  Map<DateTime, List<dynamic>> _groupTasks(List<TasksModel> events) {
    Map<DateTime, List<dynamic>> data = {};

    events.forEach((event) {
      if (event.iduser == currentuser) {
        DateTime date =
            DateTime(event.date.year, event.date.month, event.date.day, 12);
        if (data[date] == null) data[date] = [];

        data[date].add(event);
      }
    });

    return data;
  }

  fetchData() {
    databaseReferenceTest.child('Tasks').onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        String value = snapshot.value['title'];
        print('Value is $value');
      });
    });
  }

  // DocumentSnapshot snapshot;
  // dynamic data;

  Future<Null> load() async {
    await Future.delayed(Duration(seconds: 1));
  }

  void _onDaySelected(date, events, holidays) {
    setState(() {
      _selectedEvents = events;
      _chosenDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,

        // backgroundColor: Colors.grey[100],
        body: RefreshIndicator(
            onRefresh: load,
            child: ListView(children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    StreamBuilder<List<TasksModel>>(
                        stream: eventDBS.streamList(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<TasksModel> allEvents = snapshot.data;
                            if (allEvents.isEmpty) {
                              _events = _groupTasks(allEvents);
                            } else {
                              _events = _groupTasks(allEvents);
                            }
                          }
                          return Stack(children: <Widget>[
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  buildTextField(Icons.search, "Search...",
                                      false, false, ''),
                                  TableCalendar(
                                    initialSelectedDay: _chosenDate,
                                    events: _events,
                                    initialCalendarFormat: CalendarFormat.week,
                                    calendarStyle: CalendarStyle(
                                        canEventMarkersOverflow: true,
                                        todayColor: Colors.orange,
                                        selectedColor:
                                            Theme.of(context).primaryColor,
                                        todayStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: Colors.white)),
                                    headerStyle: HeaderStyle(
                                      centerHeaderTitle: true,
                                      formatButtonDecoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      formatButtonTextStyle:
                                          TextStyle(color: Colors.white),
                                      formatButtonShowsNext: false,
                                    ),
                                    startingDayOfWeek: StartingDayOfWeek.sunday,
                                    onDaySelected: _onDaySelected,
                                    builders: CalendarBuilders(
                                      selectedDayBuilder:
                                          (context, date, events) => Container(
                                              margin: const EdgeInsets.all(4.0),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[1],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                  border: Border.all(
                                                      color:
                                                          HexColor("#FFAC4F"),
                                                      width: 2)),
                                              child: Text(
                                                date.day.toString(),
                                                style: TextStyle(
                                                    color: HexColor("#FFAC4F")),
                                              )),
                                      todayDayBuilder:
                                          (context, date, events) => Container(
                                              margin: const EdgeInsets.all(4.0),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: HexColor("#FFAC4F"),
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                              child: Text(
                                                date.day.toString(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                    ),
                                    calendarController: _controller,
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Stack(
                                      alignment: Alignment.center,
                                      textDirection: TextDirection.rtl,
                                      fit: StackFit.loose,
                                      clipBehavior: Clip.hardEdge,
                                      children: <Widget>[
                                        Container(
                                          //constraints: BoxConstraints.tightFor(height: 535.0),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2.08,

                                          child: new ListView(
                                              scrollDirection: Axis.vertical,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          320, 5, 0, 0),
                                                  child: Text(
                                                    _chosenDate.day.toString() +
                                                        " " +
                                                        months[
                                                            _chosenDate.month -
                                                                1],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                ),
                                                ..._selectedEvents.map(
                                                  (_event) => ListView(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    children: <Widget>[
                                                      Row(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        20,
                                                                        30),
                                                                child: Text(
                                                                  _event.date
                                                                          .hour
                                                                          .toString()
                                                                          .padLeft(
                                                                              2,
                                                                              '0') +
                                                                      ":" +
                                                                      (_event.date
                                                                              .minute)
                                                                          .toString()
                                                                          .padLeft(
                                                                              2,
                                                                              '0') +
                                                                      ' -',
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15.0,
                                                                      color: Colors
                                                                          .black,
                                                                      letterSpacing:
                                                                          2),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: GestureDetector(
                                                                onTap: () {
                                                                  setState(
                                                                    () {},
                                                                  );
                                                                },
                                                                // child: Center(
                                                                child: ExpandableNotifier(
                                                                    child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          0,
                                                                          30,
                                                                          10,
                                                                          0),
                                                                  child: Card(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .white70,
                                                                          width:
                                                                              1),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                    ),
                                                                    elevation:
                                                                        7.50,
                                                                    color: Colors
                                                                        .white,
                                                                    clipBehavior:
                                                                        Clip.antiAlias,
                                                                    child:
                                                                        Column(
                                                                      children: <
                                                                          Widget>[
                                                                        ScrollOnExpand(
                                                                          scrollOnExpand:
                                                                              true,
                                                                          scrollOnCollapse:
                                                                              false,
                                                                          child:
                                                                              ExpandablePanel(
                                                                            theme:
                                                                                const ExpandableThemeData(
                                                                              headerAlignment: ExpandablePanelHeaderAlignment.center,
                                                                              tapBodyToCollapse: true,
                                                                            ),
                                                                            header:
                                                                                Padding(
                                                                              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                                                              child: Text(
                                                                                _event.title,
                                                                                softWrap: true,
                                                                                maxLines: 2,
                                                                                overflow: TextOverflow.fade,
                                                                              ),
                                                                            ),
                                                                            collapsed:
                                                                                Divider(
                                                                              color: Colors.grey[700],
                                                                            ),
                                                                            expanded:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: <Widget>[
                                                                                Divider(
                                                                                  color: Colors.black,
                                                                                ),
                                                                                for (var _ in Iterable.generate(1))
                                                                                  Padding(
                                                                                      padding: EdgeInsets.only(bottom: 0), //Text(e.Event.fromSnapshot(snapshot).startDate)
                                                                                      child: Text(
                                                                                        _event.description,
                                                                                        softWrap: true,
                                                                                        overflow: TextOverflow.fade,
                                                                                      )),
                                                                              ],
                                                                            ),
                                                                            builder: (_,
                                                                                collapsed,
                                                                                expanded) {
                                                                              return Padding(
                                                                                padding: EdgeInsets.only(left: 20, right: 10, bottom: 0),
                                                                                child: Expandable(
                                                                                  collapsed: collapsed,
                                                                                  expanded: expanded,
                                                                                  theme: const ExpandableThemeData(crossFadePoint: 0),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                            padding: EdgeInsets.fromLTRB(
                                                                                10,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                //location_on_outlined
                                                                                Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.location_on_outlined,
                                                                                  color: Colors.blue,
                                                                                  size: 28,
                                                                                ),
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child: CheckboxListTile(
                                                                                    title: Text(_event.location),
                                                                                    value: _event.isChecked,
                                                                                    // activeColor: _event
                                                                                    //         .isChecked
                                                                                    //     ? Colors
                                                                                    //         .green
                                                                                    //     : Colors
                                                                                    //         .grey,

                                                                                    onChanged: (bool val) async {
                                                                                      await eventDBS.updateData(_event.id, {
                                                                                        "isChecked": val
                                                                                      });
                                                                                      //ref.child('Tasks').child("isChecked").set(val).asStream();

                                                                                      //setState(() { customEvents[_controller.selectedDay].removeAt(index);  });
                                                                                      setState(() async* {
                                                                                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Tasks").get();
                                                                                        for (int i = 0; i < querySnapshot.docs.length; i++) {
                                                                                          var a = querySnapshot.docs[i];
                                                                                          if (a.id == _event.id) print("##############1");
                                                                                          print(_event.isChecked);

                                                                                          print("##############1");
                                                                                          print(a.id);
                                                                                        }
                                                                                      });

                                                                                      print("Updated ~&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
                                                                                      print(_event.isChecked);
                                                                                      print("Updated ~&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
                                                                                    },
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ))),
                                                          ),
                                                          // )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ]),
                                        ),
                                      ]),
                                ]),
                            Positioned(
                              top: MediaQuery.of(context).size.height * 0.44,
                              //left: MediaQuery.of(context).siload()ze.height * 0.36,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          print("voise");
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
                              top: MediaQuery.of(context).size.height * 0.60,
                              //left: MediaQuery.of(context).size.height * 0.36,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    GestureDetector(
                                        onTap: () async {
                                          final ref = FirebaseFirestore.instance
                                              .collection('Tasks')
                                              .doc();
                                          await eventDBS.create({
                                            'docID': ref.id,
                                            "iduser": FirebaseAuth
                                                .instance.currentUser.uid,
                                            "catigorie": " ",
                                            "title": "",
                                            "description": "",
                                            "date": _chosenDate,
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
                          ]);
                        })
                  ]),
            ])));
  }
}

Widget buildTextField(
    IconData icon, String hintText, bool isPassword, bool isEmail, String msg) {
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
                icon: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Image.asset('images/Line.png', width: 5, height: 40),
                      new Image.asset('images/Vector.png',
                          width: 20, height: 50),
                    ]),
              ),
            ),
          )));
}

Widget buildTextFieldAlert(IconData icon, String hintText, bool isPassword,
    bool isEmail, String msg, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15.0),
    child: TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return msg;
        }

        return null;
      },
      obscureText: isPassword,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: HexColor("#8A8A8A"),
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
