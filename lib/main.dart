import 'package:chat_app_tutorial/helper/authenticate.dart';
import 'package:chat_app_tutorial/helper/helperFunctions.dart';
import 'package:chat_app_tutorial/views/chatRoomScreen.dart';
import 'package:chat_app_tutorial/views/signin.dart';
import 'package:chat_app_tutorial/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool? userIsLoggedIn;

  @override
  void initState() {
    // TODO: implement initState
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    SharedPreferences.setMockInitialValues({});
    await HelperFunctions.getUserLoggedInSharedPreference().then((val){
      setState(() {
        userIsLoggedIn = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF00703C),
        scaffoldBackgroundColor: Color(0xFFE1E1E1),
        primarySwatch: Colors.blue,
      ),
      home: userIsLoggedIn != null ?
              userIsLoggedIn! ? ChatRoom() : Authenticate()
                : Authenticate(),
    );
  }
}

class IamBlank extends StatefulWidget {
  const IamBlank({Key? key}) : super(key: key);

  @override
  _IamBlankState createState() => _IamBlankState();
}

class _IamBlankState extends State<IamBlank> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
