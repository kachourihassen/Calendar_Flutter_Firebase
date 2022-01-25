import 'package:flutter/material.dart';

class MyApptest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool textBtnswitchState = true;
  bool elevatedBtnSwitchState = true;
  bool outlinedBtnState = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text('Text Button'),
                  onPressed: textBtnswitchState ? () {} : null,
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey;
                        } else {
                          return Colors.red;
                        }
                      },
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text('Change State'),
                    Switch(
                      value: textBtnswitchState,
                      onChanged: (newState) {
                        setState(() {
                          textBtnswitchState = !textBtnswitchState;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: Text('Text Button'),
                  onPressed: elevatedBtnSwitchState ? () {} : null,
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey;
                        } else {
                          return Colors.white;
                        }
                      },
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text('Change State'),
                    Switch(
                      value: elevatedBtnSwitchState,
                      onChanged: (newState) {
                        setState(() {
                          elevatedBtnSwitchState = !elevatedBtnSwitchState;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  child: Text('Outlined Button'),
                  onPressed: outlinedBtnState ? () {} : null,
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      } else {
                        return Colors.red;
                      }
                    },
                  ), side: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return BorderSide(color: Colors.grey);
                    } else {
                      return BorderSide(color: Colors.red);
                    }
                  })),
                ),
                Column(
                  children: [
                    Text('Change State'),
                    Switch(
                      value: outlinedBtnState,
                      onChanged: (newState) {
                        setState(() {
                          outlinedBtnState = !outlinedBtnState;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
