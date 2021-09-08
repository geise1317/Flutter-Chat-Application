import 'package:chat_app_tutorial/helper/authenticate.dart';
import 'package:chat_app_tutorial/helper/constants.dart';
import 'package:chat_app_tutorial/helper/helperFunctions.dart';
import 'package:chat_app_tutorial/services/auth.dart';
import 'package:chat_app_tutorial/services/database.dart';
import 'package:chat_app_tutorial/views/conversationScreen.dart';
import 'package:chat_app_tutorial/views/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  late Stream chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder(stream: chatRoomsStream,
    builder: (context, snapshot){
      return ListView.builder(
        itemCount: (snapshot.data as QuerySnapshot).docs.length,
        itemBuilder: (context, index){
          return ChatRoomTile((snapshot.data as QuerySnapshot).docs[index].get("chatRoomId")
          .toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
              (snapshot.data as QuerySnapshot).docs[index].get("chatRoomId"));
        });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    databaseMethods.getChatRooms(Constants.myName).then((val){
      setState(() {
        chatRoomsStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/ufv_logo.png", height: 30,),
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId)));
        HelperFunctions.saveTargetNameSharedPreference(userName);
      },
      child: Container(
        color: Color(0xFF7CB232),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}",
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),),
            ),
            SizedBox(width: 8,),
            Text(userName, style: TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),)
          ],
        ),
      ),
    );
  }
}
