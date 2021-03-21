import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  Future<Stream<QuerySnapshot>> getUserByUserName(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .snapshots();
  }

    Future getUserByEmail(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .snapshots();
  }


  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  createChatRoom(String chatRoomId, Map chatRoomInfoMap) async {

    final snapshot = await FirebaseFirestore.instance.collection("chatRoom").doc(chatRoomId).get();

    if (snapshot.exists) {
      // chatroom allready exists
      return true;
    } else {
      // chatroom does not exists
      return FirebaseFirestore.instance.collection("chatRoom").doc(chatRoomId).set(chatRoomInfoMap);
    }
  }

}