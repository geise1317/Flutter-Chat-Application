import 'package:flutter/material.dart';

PreferredSizeWidget appBarMain(BuildContext context){
  return AppBar(
    title: Image.asset("assets/images/ufv_logo.png", height: 30,),
  );
}

InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
          color: Colors.black
      ),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black54)
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black54)
      )
  );
}

TextStyle simpleTextStyle(){
  return TextStyle(
      color: Colors.black,
      fontSize: 16
  );
}