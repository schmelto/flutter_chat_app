import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<Stream<QuerySnapshot>> getUserByUserName(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getUserByEmail(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .snapshots();
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  createChatRoom(String chatRoomId, Map chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .get();

    if (snapshot.exists) {
      // chatroom allready exists
      return true;
    } else {
      // chatroom does not exists
      return FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chat")
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(String chatroomId, messageMap) async {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatroomId)
        .collection("chat")
        .add(messageMap);
  }

    getUserChats(String itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }
}
