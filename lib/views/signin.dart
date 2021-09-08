import 'package:chat_app_tutorial/helper/helperFunctions.dart';
import 'package:chat_app_tutorial/services/auth.dart';
import 'package:chat_app_tutorial/services/database.dart';
import 'package:chat_app_tutorial/views/chatRoomScreen.dart';
import 'package:chat_app_tutorial/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditorController = new TextEditingController();
  TextEditingController passwordTextEditorController = new TextEditingController();

  bool isLoading = false;
  late QuerySnapshot snapshotUserInfo;

  signIn(){
    if(formKey.currentState!.validate()){

      HelperFunctions.saveUserEmailSharedPreference(emailTextEditorController.text);

      databaseMethods.getUserByUserEmail(emailTextEditorController.text).then((val){
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.docs[0].get("name"));
        print("My name is ${snapshotUserInfo.docs[0].get("name")}");
      });

      setState(() {
        isLoading = true;
      });

      authMethods.sinInWithEmailAndPassword(emailTextEditorController.text, passwordTextEditorController.text).then((value) {
        if(value!=null){
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
        body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val){
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ?
                        null : "Enter correct email";
                      },
                      controller: emailTextEditorController,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("Email"),
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (val){
                        return val!.length > 6 ? null : "Please provide password more than 6 digits";
                      },
                      controller: passwordTextEditorController,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("Password"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8,),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("ForgotPassword?", style: simpleTextStyle(),),
                )
              ),
              SizedBox(height: 8,),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xff007EF4),
                      const Color(0xff2A75BC)
                    ]
                  ),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: GestureDetector(
                  onTap: (){
                    signIn();
                  },
                  child: Column(
                    children: [
                      Text("Sign In", style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16,),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Column(
                  children: [
                    Text("Sign In with Google", style: TextStyle(
                      color: Colors.black,
                      fontSize: 16
                    ),)
                  ],
                ),
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have account?", style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),),
                  GestureDetector(
                    onTap: (){
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(" Register Now", style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline
                      ),),
                    ),
                  )
                ],
              ),
              SizedBox(height: 50,)
            ],
          ),
        )
      )
    );
  }
}
