import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  Future<Stream<QuerySnapshot>> getUserByUserName(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .snapshots();
  }


  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  // createChatRoom(String chatRoomId, Map chatRoomMap){
  //   return FirebaseFirestore.instance.collection("chatRoom").doc(chatRoomId).set(chatRoomMap).catchError(e){
  //     print(e.toString);
  //   }
  // }

}