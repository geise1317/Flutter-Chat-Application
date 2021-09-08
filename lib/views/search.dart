import 'package:chat_app_tutorial/helper/constants.dart';
import 'package:chat_app_tutorial/helper/helperFunctions.dart';
import 'package:chat_app_tutorial/services/database.dart';
import 'package:chat_app_tutorial/views/conversationScreen.dart';
import 'package:chat_app_tutorial/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchTextEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();


  QuerySnapshot? searchSnapshot;

  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot!.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return SearchTile(userName: searchSnapshot!.docs[index].get("name"), userEmail: searchSnapshot!.docs[index].get("email"));
        }) : Container();
  }

  initiateSearch(){
    databaseMethods.getUserByUserName(searchTextEditingController.text)
        .then((val){
          setState(() {
            searchSnapshot = val;
          });
    });
  }

  /// create chatRoom, send user to conversation screen, pushreplacement
  createChatroomAndStartConversation({required String username}){
    print("My name: ${Constants.myName}");
    if(username != Constants.myName){
      String chatRoomId = getChatRoomId(username, Constants.myName);
      List<String> users = [username, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users" : users,
        "chatRoomId" : chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId)));
    } else {
      print("you cannot send message to yourself");
    }
  }

  Widget SearchTile({required String userName, required String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: TextStyle(
                color: Colors.black
              ),),
              Text(userEmail, style: TextStyle(
                color: Colors.black
              ),)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatroomAndStartConversation(
                username: userName
              );
              HelperFunctions.saveTargetNameSharedPreference(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Message", style: TextStyle(
                  color: Colors.white
              )),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        style: TextStyle(
                          color: Colors.black
                        ),
                        decoration: InputDecoration(
                          hintText: "Search username...",
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          border: InputBorder.none
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                      },
                    child: Container(
                      height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x8C7CB232),
                              const Color(0x5F7CB232)
                            ]
                          ),
                          borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(12),
                        child: Image.asset("assets/images/search_white.png")),
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b){
  if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)){
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}