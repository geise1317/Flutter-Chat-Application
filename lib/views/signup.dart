import 'package:chat_app_tutorial/helper/helperFunctions.dart';
import 'package:chat_app_tutorial/services/auth.dart';
import 'package:chat_app_tutorial/services/database.dart';
import 'package:chat_app_tutorial/views/chatRoomScreen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_tutorial/widgets/widget.dart';

class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  HelperFunctions helperFunctions = new HelperFunctions();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditorController = new TextEditingController();
  TextEditingController emailTextEditorController = new TextEditingController();
  TextEditingController passwordTextEditorController = new TextEditingController();

  signMeUP(){
    if(formKey.currentState!.validate()){
      setState(() {
        isLoading = true;
      });


      authMethods.signUpWithEmailAndPassword(emailTextEditorController.text, passwordTextEditorController.text)
      .then((value){
        Map<String, String> userInfoMap = {
          "name" : userNameTextEditorController.text,
          "email" : emailTextEditorController.text
        };
        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserNameSharedPreference(userNameTextEditorController.text);
        HelperFunctions.saveUserEmailSharedPreference(emailTextEditorController.text);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ?  Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) : SingleChildScrollView(
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
                          return val!.isEmpty || val.length < 4 ? "username is empty" : null;
                        },
                        controller: userNameTextEditorController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("Username"),
                      ),
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
                SizedBox(height: 30,),
                GestureDetector(
                  onTap: (){
                    signMeUP();
                  },
                  child: Container(
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
                    child: Column(
                      children: [
                        Text("Sign Up", style: TextStyle(
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
                      Text("Sign Up with Google", style: TextStyle(
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
                    Text("Already have an account?", style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Sign in now", style: TextStyle(
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
      ),
    );
  }
}
