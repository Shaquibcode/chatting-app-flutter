import 'package:chattingapp/api/apis.dart';
import 'package:chattingapp/screens/profile_screen.dart';
import 'package:chattingapp/widgets/chat_user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';
import '../models/chat_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];

  //list for storing searched items
  final List<ChatUser> _searchList = [];

  bool _isSearaching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) {
      print("Token $value");
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'fcmToken': value,
      });
    });
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    print("Home Screen");
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearaching) {
            setState(() {
              _isSearaching = !_isSearaching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: _isSearaching
                ? TextField(
                    onChanged: (val) {
                      _searchList.clear();
                      for (var i in list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                    style: const TextStyle(
                      fontSize: 17,
                      letterSpacing: .5,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name, Email...',
                    ),
                    autofocus: true,
                  )
                : const Text('Chat App'),
            leading: const Icon(CupertinoIcons.home),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearaching = !_isSearaching;
                  });
                },
                icon: _isSearaching
                    ? const Icon(CupertinoIcons.clear_circled_solid)
                    : const Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        user: APIs.me,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(10),
            child: FloatingActionButton(
              onPressed: () async {
                await APIs.auth.signOut();
                await GoogleSignIn().signOut();
              },
              child: const Icon(Icons.add_comment_rounded),
            ),
          ),
          body: StreamBuilder(
            stream: APIs.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                case ConnectionState.done:
                case ConnectionState.active:
                  final data = snapshot.data?.docs;
                  list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  if (list.isNotEmpty) {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: mq.height * .01),
                      physics: const BouncingScrollPhysics(),
                      itemCount:
                          _isSearaching ? _searchList.length : list.length,
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                          user:
                              _isSearaching ? _searchList[index] : list[index],
                        );
                        // return Text("name: ${list[index]}");
                      },
                    );
                  } else {
                    return const Center(child: Text('No Connection Found'));
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
