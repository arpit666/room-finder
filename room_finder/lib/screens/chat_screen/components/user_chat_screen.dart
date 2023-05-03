
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:room_finder/model/message.dart';

import 'package:room_finder/model/user_model.dart';
import 'package:room_finder/screens/chat_screen/components/user_chat_card.dart';

import '../../../main.dart';
import 'apis.dart';
import 'message_card.dart';

class UserChatScreen extends StatefulWidget {
  final UserModel chatUser;
  const UserChatScreen({Key? key,required this.chatUser}) : super(key: key);

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

// chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

class _UserChatScreenState extends State<UserChatScreen> {
  bool _isTyping = true;
  List _list = [];

  late Size mq;

  bool _showEmoji = false;


  final _messageController = TextEditingController();

  User get user => FirebaseAuth.instance.currentUser!;

   String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserModel user) {
    return FirebaseFirestore.instance
        .collection('chats/${getConversationID(user.userId)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }
  Future sendMessage(UserModel chatUser,String msg) async{

    final time =  DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(msg: msg, toId: chatUser.userId, read: '', type: Type.text.name, sent: time, fromId: user.uid);
    final ref = FirebaseFirestore.instance.
    collection('chats/${getConversationID(chatUser.userId)}/messages/');
    await ref.doc().set(message.toJson());

  }
Future updateMessageReadStatus(Message message) async{
    FirebaseFirestore.instance.collection('chats/${getConversationID(message.fromId)}/messages/').doc(message.sent).update
      ({'read' : DateTime.now().millisecondsSinceEpoch.toString()});
}

@override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mq = MediaQuery.of(context).size;
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(child: WillPopScope(
        onWillPop: (){
          if(_showEmoji){
            setState(() {
              _showEmoji = !_showEmoji;
              
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.chatUser),
                    builder:(context,AsyncSnapshot<QuerySnapshot>snapshot) {
                      switch (snapshot.connectionState) {
                      //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                      //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data!.docs;

                          _list = data
                              ?.map((e) => Message.fromJson(e.data() as  Map<String, dynamic>))
                              .toList() ??
                              [];

                          if(_list.isNotEmpty){
                            return ListView.builder(


                                reverse: true,
                                itemCount: _list.length,
                                padding: EdgeInsets.only(top: 5),
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context,index){
                                  return MessageCard(message: _list[index],);
                                });
                          }else{
                            return Center(child: Text('Say Hi! 👋' ,style: TextStyle(fontSize: 20),));
                          }

                      }
                    }
                ),
              ),
              _chatInput(),

              if (_showEmoji)
                SizedBox(
                  height: mq.height * 0.35,
                  child: EmojiPicker(
                    textEditingController: _messageController,
                    config: Config(
                      bgColor: const Color.fromARGB(255, 234, 248, 255),
                      columns: 8,
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                    ),
                  ),
                )


            ],
          ),
        ),
      )),
    );
  }


  Widget _chatInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              child:
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              _showEmoji = !_showEmoji;
                            });
                          },
                          icon:
                          const Icon(Icons.emoji_emotions, color: Colors.deepPurple)),
                      Expanded(child: TextField(
                        onTap: (){

                          if(_showEmoji) setState(() {
                            _showEmoji = !_showEmoji;
                          });
                        },
                        controller: _messageController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(hintText: 'Type Something...',hintStyle: TextStyle(color: Colors.grey),border: InputBorder.none),
                        cursorColor: Colors.black45,
                      )),
                      if(_isTyping)
                      Row(children: [
                        IconButton(
                            onPressed: () {},
                            icon:
                            const Icon(Icons.image, color: Colors.deepPurple)),
                        IconButton(
                            onPressed: () {},
                            icon:
                            const Icon(Icons.camera_alt, color: Colors.deepPurple)),
                      ],)



                    ],
                  ),


            ),
          ),

          MaterialButton(onPressed: (){
            if(_messageController.text.isNotEmpty){
              APIs.sendMessage(widget.chatUser, _messageController.text);
              _messageController.text = '';
            }
          },
            minWidth: 0,
            shape: CircleBorder(),
            padding: EdgeInsets.only(left: 10,right: 5,top: 10,bottom: 10),
            color: Colors.deepPurple,
            child: Icon(Icons.send,color: Colors.white,),)
        ],
      ),
    );
  }
  Widget _appBar(){
    return InkWell(
      onTap: (){},
      child: Row(
        children: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon:
              const Icon(Icons.arrow_back, color: Colors.black54)),

          //user profile picture
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
                borderRadius: BorderRadius.circular(40),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image(
                  image: widget.chatUser.image != ''
                      ? NetworkImage(widget.chatUser.image)
                      : NetworkImage('https://picsum.photos/200')
                  as ImageProvider,
                ),
              ),
            ),
          ),

          //for adding some space
          const SizedBox(width: 20),

          Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text(widget.chatUser.userFullName,style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontSize: 17,),),
          ],),

        ],
      ),
    );
  }
}

