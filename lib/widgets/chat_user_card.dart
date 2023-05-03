import 'package:cached_network_image/cached_network_image.dart';
import 'package:chattingapp/api/apis.dart';
import 'package:chattingapp/helper/my_date_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      elevation: .5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: StreamBuilder(
          stream: APIs.getLastmessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) _message = list[0];
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      user: widget.user,
                    ),
                  ),
                );
              },
              // leading: const CircleAvatar(
              //   child: Icon(CupertinoIcons.person),
              // ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .03),
                child: CachedNetworkImage(
                  height: mq.height * .060,
                  width: mq.height * .060,
                  imageUrl: widget.user.image,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
              title: Text(widget.user.name),
              subtitle: Text(
                _message != null ? _message!.msg : widget.user.about,
                maxLines: 1,
              ),
              // trailing: const Text(
              //   "12:00 PM",
              //   style: TextStyle(color: Colors.black54),
              // ),
              trailing: _message == null
                  ? null
                  : _message!.read.isEmpty && _message!.fromId != APIs.user.uid
                      ? Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        )
                      : Text(
                MyDateUtils.getLastMessageTime(context: context, time: _message!.sent),
                          style: const TextStyle(color: Colors.black54),
                        ),
            );
          }),
    );
  }
}
