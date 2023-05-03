import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:room_finder/screens/chat_screen/components/apis.dart';
import 'package:room_finder/screens/chat_screen/components/my_date_util.dart';

import '../../../model/message.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({Key? key,required this.message}) : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return currentUser!.uid == widget.message.fromId ?_receiverMessage() :_senderMessage();
  }
  Widget _senderMessage(){
    if(widget.message.read.isEmpty){
      APIs.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            decoration:  BoxDecoration(
              color: Colors.grey.shade300,
              border: Border.all(color: Colors.blueGrey),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),),
            ),
            child: Text(widget.message.msg,style: TextStyle(fontSize: 15,color: Colors.black87),),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent), style: TextStyle(fontSize: 15,color: Colors.black54),),
        )
      ],
    );
  }
//my_message == green_message
  Widget _receiverMessage(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Row(
          children: [
            SizedBox(width: 10,),
            if(widget.message.read.isNotEmpty)
            const Icon(Icons.done_all_rounded,color: Colors.lightBlue,size: 20,),
            SizedBox(width: 2,),
            Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),style: TextStyle(fontSize: 15,color: Colors.black54),),
          ],
        ),



        Flexible(
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            decoration:  BoxDecoration(
              color: Color.fromRGBO(158, 150, 253, 0.4),
              border: Border.all(color: Colors.deepPurple),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),),
            ),
            child: Text(widget.message.msg,style: TextStyle(fontSize: 15,color: Colors.black87),),
          ),
        ),
      ],
    );
  }
}
