import 'package:chattingapp/api/apis.dart';
import 'package:flutter/material.dart';

import '../helper/my_date_utils.dart';
import '../main.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

//senders message
  Widget _blueMessage() {
    if(widget.message.read.isNotEmpty){
      APIs.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 221, 245, 255),
              border: Border.all(color: Colors.blueAccent),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            child: Text(
              widget.message.msg,
              style: const TextStyle(color: Colors.black87, fontSize: 15),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            MyDateUtils.getFormattedTime(context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),

      ],
    );
  }

  //our message
  Widget _greenMessage() {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(width: mq.width * .04),
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20,),
              const SizedBox(width:  2,),
              Text(
               MyDateUtils.getFormattedTime(context: context, time: widget.message.sent),
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 201, 236, 222),
              border: Border.all(color: Colors.blueAccent),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            child: Text(
              widget.message.msg,
              style: const TextStyle(color: Colors.black87, fontSize: 15),
            ),
          ),
        ),

      ],
    );
  }
}
