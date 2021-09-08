import 'package:chat_app_tutorial/helper/constants.dart';
import 'package:chat_app_tutorial/services/database.dart';
import 'package:chat_app_tutorial/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageTextEditingController = new TextEditingController();
  ScrollController scrollController = new ScrollController();

  QuerySnapshot? snapshot;
  late Stream chatMessageStream;

  Widget chatMessageList(){
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot){
        return Container(
          padding: EdgeInsets.only(bottom: 60),
          height: MediaQuery.of(context).size.height-50,
          child: ListView.builder(
            controller: scrollController,
            reverse: true,
            itemCount: (snapshot.data as QuerySnapshot).docs.length,
              itemBuilder: (context, index){
                return MessageTile((snapshot.data as QuerySnapshot).docs[index]["message"], (snapshot.data as QuerySnapshot).docs[index]["sentBy"] == Constants.myName
                );
          }),
        );
      },
    );
  }

  sendMessage(){

    if(messageTextEditingController.text.isNotEmpty){
      Map<String, dynamic> messageMap = {
        "message" : messageTextEditingController.text,
        "sentBy" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageTextEditingController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val){
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x88000000),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: messageTextEditingController,
                          style: TextStyle(
                              color: Colors.white
                          ),
                          decoration: InputDecoration(
                              hintText: "Message...",
                              hintStyle: TextStyle(
                                color: Colors.white54,
                              ),
                              border: InputBorder.none
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: (){
                        sendMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/images/send.png")),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  MessageTile(this.message, this.isSentByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSentByMe ? 4 : 12, right: isSentByMe ? 12 : 4),
      margin: EdgeInsets.symmetric(vertical: 2),
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSentByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ] : [
                const Color(0xFF9EBBC1),
                const Color(0xFF9EBBC1)
              ],
            ),
          borderRadius: isSentByMe ?
              BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23),
              ) :
              BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23),
              )
          ),
          child: Text(message,
            style: TextStyle(
            color: Colors.white,
            fontSize: 17
            ),
          ),
        ),
    );
  }
}
