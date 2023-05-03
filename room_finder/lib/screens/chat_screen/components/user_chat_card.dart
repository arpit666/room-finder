
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:room_finder/screens/chat_screen/components/apis.dart';
import 'package:room_finder/screens/chat_screen/components/user_chat_screen.dart';

import '../../../main.dart';
import '../../../model/message.dart';
import '../../../model/user_model.dart';
import 'my_date_util.dart';
class UserChatCard extends StatefulWidget {
  final UserModel chatUser;
  const UserChatCard({Key? key,required this.chatUser}) : super(key: key);

  @override
  State<UserChatCard> createState() => _UserChatCardState();
}

class _UserChatCardState extends State<UserChatCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Message? _message ;

  Future<String> getApplicationSupportDirectoryPath() async {
    final directory = await getApplicationSupportDirectory();
    return directory.path;
  }


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4,vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 1,
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=> UserChatScreen(chatUser: widget.chatUser)));
        },
        child:  StreamBuilder(
          stream: APIs.getLastMessage(widget.chatUser),
          builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
            final data = snapshot.data?.docs;
            final list = data
                ?.map((e) => Message.fromJson(e.data() as  Map<String, dynamic>))
                .toList() ??
                [];
            if(list.isNotEmpty) _message = list[0];
            return ListTile(
              leading: Container(
                width: 55,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image(
                    image: widget.chatUser.image != ''
                        ? NetworkImage(widget.chatUser.image)
                        : NetworkImage('https://picsum.photos/200')
                    as ImageProvider,
                  ),
                ),
              ),
              title: Text(widget.chatUser.userFullName),
              subtitle: Text(_message != null ? _message!.msg :widget.chatUser.about,maxLines: 1,),

                trailing: _message == null
                    ? null //show nothing when no message is sent
                    : _message!.read.isEmpty &&
                    _message!.fromId != APIs.user.uid
                    ?
                //show for unread message
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      color: Colors.greenAccent.shade400,
                      borderRadius: BorderRadius.circular(10)),
                )
                    :
                //message sent time
                Text(
                  MyDateUtil.getLastMessageTime(
                      context: context, time: _message!.sent),
                  style: const TextStyle(color: Colors.black54),
                )
            );
          }
        )
      ),
    );
  }
}
