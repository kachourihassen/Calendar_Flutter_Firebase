import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:login_singup/config/palette.dart';
import 'package:login_singup/screen/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'google.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isSignupScreen = true;
  bool isRememberMe = false;
  bool isSignIn = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  FacebookLogin facebookLogin = FacebookLogin();

  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _prenomcontroller = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();

  //google

  void click() {
    signInWithGoogle().then((user) => {
          this.user = user,
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyHomePage())),
        });
  }

  checkAuthentification() async {
    FirebaseAuth.instance.authStateChanges().listen(((user) {
      if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
      }
    }));
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _prenomcontroller.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  Future<void> handleLogin() async {
    final FacebookLoginResult result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
      case FacebookLoginStatus.loggedIn:
        try {
          await loginWithfacebook(result);
        } catch (e) {
          print(e);
        }
        break;
    }
  }

  Future loginWithfacebook(FacebookLoginResult result) async {
    final FacebookAccessToken accessToken = result.accessToken;
    AuthCredential credential =
        FacebookAuthProvider.credential(accessToken.token);
    var a = await _auth.signInWithCredential(credential);
    setState(() {
      isSignIn = true;
      user = a.user;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 200,
              // decoration: BoxDecoration(
              //     // image: DecorationImage(
              //     //     image: AssetImage("images/background.jpg"),
              //     //     fit: BoxFit.fill)
              //     ),
              child: Container(
                padding: EdgeInsets.only(top: 120, left: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // children: [
                  //   Center(
                  //     child: Text(
                  //       "LOGO",
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         fontSize: 35,
                  //         fontWeight: FontWeight.bold,
                  //         color:  HexColor("#FFAC4F"),
                  //       ),
                  //     ),
                  //   ),
                  // ],
                ),
              ),
            ),
          ),

          buildBottomHalfContainer(true),

          AnimatedPositioned(
            duration: Duration(milliseconds: 700),
            curve: Curves.bounceInOut,
            top: isSignupScreen ? 150 : 150,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              height: isSignupScreen ? 320 : 320,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 1,
                        spreadRadius: 0),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = false;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 16,
                                  //fontWeight: FontWeight.bold,
                                  color: !isSignupScreen
                                      ? HexColor("#FFAC4F")
                                      : Palette.textColor1,
                                ),
                              ),
                              if (!isSignupScreen)
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color: HexColor("#FFAC4F"),
                                )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = true;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "SIGN UP",
                                style: TextStyle(
                                    fontSize: 16,
                                    //fontWeight: FontWeight.bold,
                                    color: isSignupScreen
                                        ? HexColor("#FFAC4F")
                                        : Palette.textColor1),
                              ),
                              if (isSignupScreen)
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color: HexColor("#FFAC4F"),
                                )
                            ],
                          ),
                        )
                      ],
                    ),
                    if (isSignupScreen) buildSignupSection(),
                    if (!isSignupScreen) buildSigninSection()
                  ],
                ),
              ),
            ),
          ),
          // Trick to add the submit button
          buildBottomHalfContainer(false),

          // Bottom buttons

          Positioned(
            top: (isSignupScreen
                ? MediaQuery.of(context).size.height - 160
                : MediaQuery.of(context).size.height - 160),
            right: 0,
            left: 0,
            child: Column(
              children: [
                Text(isSignupScreen ? "Sign Up with" : "Log In with"),
                const SizedBox(
                  height: 22,
                ),
                Container(
                  margin: EdgeInsets.only(right: 120, left: 120, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await handleLogin();
                        },
                        child: Container(
                          child: Image.asset(
                            "images/Facebook Logo.png",
                            width: 70,
                            height: 70,
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            click();
                          },
                          child: Container(
                            child: Image.asset(
                              "images/Google Logo.png",
                              width: 70,
                              height: 70,
                            ),
                          ))
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container buildSigninSection() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              buildTextField(
                  MaterialCommunityIcons.account_outline,
                  "Username or Email ",
                  false,
                  true,
                  'Saisie votre Email',
                  _emailcontroller),
              buildTextField(MaterialCommunityIcons.lock_outline, "Password",
                  true, false, "Verifier votre password", _passwordcontroller),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isRememberMe,
                        activeColor: HexColor("#8A8A8A"),
                        onChanged: (value) {
                          setState(() {
                            // checkAuthentification();
                            isRememberMe = !isRememberMe;
                          });
                        },
                      ),
                      Text("Remember me",
                          style: TextStyle(
                              fontSize: 12, color: HexColor("#8A8A8A")))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(55, 0, 0, 0),
                    child: TextButton(
                      onPressed: () {},
                      child: Text("Forgot Password?",
                          style: TextStyle(
                              fontSize: 12, color: HexColor("#8A8A8A"))),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              )
            ],
          ),
        ));
  }

  Container buildSignupSection() {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Form(
          key: _formkey1,
          child: Column(
            children: [
              buildTextField(
                  MaterialCommunityIcons.account_outline,
                  "Full Name",
                  false,
                  false,
                  "Saisier voter Prenom",
                  _prenomcontroller),
              buildTextField(MaterialCommunityIcons.email_outline, "Email",
                  false, true, "Saisie votre Email", _emailcontroller),
              buildTextField(MaterialCommunityIcons.lock_outline, "Password",
                  true, false, "Verifier votre password", _passwordcontroller),
            ],
          ),
        ));
  }

  validator() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
    }
  }

  validator1() async {
    if (_formkey1.currentState.validate()) {
      _formkey1.currentState.save();
    }
  }

  TextButton buildTextButton(
      IconData icon, String title, Color backgroundColor) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
          side: BorderSide(width: 1, color: Colors.grey),
          minimumSize: Size(145, 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.white,
          backgroundColor: backgroundColor),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
          )
        ],
      ),
    );
  }

  Future<dynamic> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailcontroller.text, password: _passwordcontroller.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } on FirebaseAuthException catch (e) {
      var msgerr = "";
      switch (e.code) {
        case "invalid-email":
          msgerr = "invalid-email";
          break;
        case "user-disabled":
          msgerr = "user-disabled";
          break;
        case "user-not-found":
          msgerr = "user-not-found";
          break;
        case "wrong-password":
          msgerr = "wrong-password";
          break;
      }
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: new Text("Error Login"),
              content: new Text(msgerr),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok"))
              ],
            );
          });
    }
  }

  Future<dynamic> signup() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailcontroller.text, password: _passwordcontroller.text);

      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set({'prenom': _prenomcontroller.text});
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } on FirebaseAuthException catch (e) {
      var msgerr = "";
      switch (e.code) {
        case "invalid-email":
          msgerr = "invalid-email";
          break;
        case "user-disabled":
          msgerr = "user-disabled";
          break;
        case "user-not-found":
          msgerr = "user-not-found";
          break;
        case "wrong-password":
          msgerr = "wrong-password";
          break;
      }
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: new Text("Error Login"),
              content: new Text(msgerr),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok"))
              ],
            );
          });
    }
  }

  Widget buildBottomHalfContainer(bool showShadow) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: isSignupScreen ? 430 : 430,
      right: 60,
      left: 60,
      child: Container(
        height: 80,
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
        child: new Row(
          children: <Widget>[
            Container(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
              // ignore: deprecated_member_use
              child: RaisedButton(
                elevation: 0,
                hoverElevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                color: Colors.transparent,
                onPressed: () {
                  if (!isSignupScreen) {
                    validator();
                    login();
                  }
                  if (isSignupScreen) {
                    validator1();
                    signup();
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(70.0)),
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),

                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [HexColor("#FFAC4F"), HexColor("#FFAC4F")],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(110.0)),
                  child: Container(
                    color: Colors.transparent,
                    constraints:
                        BoxConstraints(maxWidth: 250.0, minHeight: 0.0),
                    alignment: Alignment.center,
                    child: Text(
                      isSignupScreen ? "Sign Up" : "Log In",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                // ),
                // ),
              ),
            ))
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              if (showShadow)
                BoxShadow(
                  color: Colors.black.withOpacity(.3),
                  spreadRadius: 0,
                  blurRadius: 1,
                )
            ]),
      ),
    );
  }

  Widget buildTextField(IconData icon, String hintText, bool isPassword,
      bool isEmail, String msg, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return msg;
          }
          // if (isPassword == true && (!(value.length < 5) && value.isNotEmpty)) {
          //   return "Password moins de 5 characters!";
          // }

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
