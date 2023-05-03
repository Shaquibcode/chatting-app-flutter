import 'dart:io';

import 'package:chattingapp/models/chat_user.dart';
import 'package:chattingapp/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  static late ChatUser me;

  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static User get user => auth.currentUser!;

  //checking if user exist or not
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //creating user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      image: user.photoURL.toString(),
      about: 'Hey Using Chat App',
      name: user.displayName.toString(),
      createdAt: time,
      lastActive: time,
      isOnline: false,
      id: user.uid,
      pushToken: '',
      email: user.email.toString(),
    );

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  //for getting all users
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection("users")
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  static Future<void> updateProfilePic(File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then(
          (p0) =>
              debugPrint('Data Transfered: ${p0.bytesTransferred / 1000} kb'),
        );

    //updating image in firestore
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }


  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  //*******************Chat Screen related Apis********************************//

  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';
  //for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection("chats/${getConversationId(user.id)}/messages/")
        .snapshots();
  }

  //for sending messages
  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
        msg: msg,
        read: '',
        told: chatUser.id,
        type: Type.text,
        fromId: user.uid,
        sent: time);

    final ref = firestore
        .collection("chats/${getConversationId(chatUser.id)}/messages/");
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection("chats/${getConversationId(message.fromId)}/messages/")
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastmessage(ChatUser user){
    return firestore.collection('chats/${getConversationId(user.id)}/messages/').orderBy('sent').limit(1).snapshots();
  }

}
