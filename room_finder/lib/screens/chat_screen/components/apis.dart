import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:room_finder/model/user_model.dart';

import '../../../model/message.dart';


class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // for storing self information
  static late UserModel me;

  // to return current user
  static User get user => auth.currentUser!;




  // for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // for adding an chat user for our conversation
  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    log('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //user exists

      log('user exists: ${data.docs.first.data()}');

      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      //user doesn't exists

      return false;
    }
  }

  // for getting current user info
  // static Future<void> getSelfInfo() async {
  //   await firestore.collection('users').doc(user.uid).get().then((user) async {
  //     if (user.exists) {
  //       me = ChatUser.fromJson(user.data()!);
  //       await getFirebaseMessagingToken();
  //
  //       //for setting user status to active
  //       APIs.updateActiveStatus(true);
  //       log('My Data: ${user.data()}');
  //     } else {
  //       await createUser().then((value) => getSelfInfo());
  //     }
  //   });
  // }

  // // for creating a new user
  // static Future<void> createUser() async {
  //   final time = DateTime.now().millisecondsSinceEpoch.toString();
  //
  //   final chatUser = UserModel(
  //       userId: user.uid,
  //       name: user.displayName.toString(),
  //       email: user.email.toString(),
  //       about: "Hey, I'm using We Chat!",
  //       image: user.photoURL.toString(),
  //       createdAt: time,
  //       isOnline: false,
  //       lastActive: time,
  //       pushToken: '');
  //
  //   return await firestore
  //       .collection('users')
  //       .doc(user.uid)
  //       .set(chatUser.toJson());
  // }

  // for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  // for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    log('\nUserIds: $userIds');

    return firestore
        .collection('users')
        .where('id',
        whereIn: userIds.isEmpty
            ? ['']
            : userIds) //because empty list throws an error
    // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for adding an user to my user when first message is send




  // update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      UserModel chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.userId)
        .snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  ///************** Chat Screen Related APIs **************
  // chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

  // useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserModel user) {
    return firestore
        .collection('chats/${getConversationID(user.userId)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }



  //update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final snapshot = await firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .where('sent', isEqualTo: message.sent).get();
    if (snapshot.docs.length > 0) {
      final doc = snapshot.docs[0];
      await doc.reference.update({'read': time});
    }

  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      UserModel user) {
    return firestore
        .collection('chats/${getConversationID(user.userId)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //send chat image
  // static Future<void> sendChatImage(UserModel chatUser, File file) async {
  //   //getting image file extension
  //   final ext = file.path.split('.').last;
  //
  //   //storage file ref with path
  //   final ref = storage.ref().child(
  //       'images/${getConversationID(chatUser.userId)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
  //
  //   //uploading image
  //   await ref
  //       .putFile(file, SettableMetadata(contentType: 'image/$ext'))
  //       .then((p0) {
  //     log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
  //   });
  //
  //   //updating image in firestore database
  //   final imageUrl = await ref.getDownloadURL();
  //   await sendMessage(chatUser, imageUrl, Type.image);
  // }

  //delete message
  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  //update message
  static Future<void> updateMessage(Message message, String updatedMsg) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }
  static Future sendMessage(UserModel chatUser,String msg) async{

    final time =  DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(msg: msg, toId: chatUser.userId, read: '', type: Type.text.name, sent: time, fromId: user.uid);
    final chatId = getConversationID(chatUser.userId);
    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    final chatDoc = await chatRef.get();




    if(!chatDoc.exists){
      final userDocRefSender = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userDocSnapshotSender = await userDocRefSender.get();
      final userDocDataSender = userDocSnapshotSender.data() as Map<String, dynamic>;
      final chatIdsSender= List<String>.from(userDocDataSender['chatIds']);
      chatIdsSender.add(chatUser.userId);


      final userDocRefReceiver = FirebaseFirestore.instance.collection('users').doc(chatUser.userId);
      final userDocSnapshotReceiver = await userDocRefReceiver.get();
      final userDocDataReceiver = userDocSnapshotReceiver.data() as Map<String, dynamic>;
      final chatIdsReceiver= List<String>.from(userDocDataReceiver['chatIds']);
      chatIdsReceiver.add(user.uid);

      userDocRefSender.update({'chatIds': chatIdsSender});
      userDocRefReceiver.update({'chatIds': chatIdsReceiver});
    }


    final ref = FirebaseFirestore.instance.
    collection('chats/${getConversationID(chatUser.userId)}/messages/');
    await ref.doc().set(message.toJson());

  }
}