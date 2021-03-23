import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/constants.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:flutter_chat_app/views/conversationScreen.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();

  Stream usersStream;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
    }
    usersStream =
        await databaseMethods.getUserByUserName(searchEditingController.text);
    setState(() {
      isLoading = false;
      haveUserSearched = true;
    });
  }

  Widget searchUsersList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return userTile(name: ds["name"], email: ds["email"]);
                },
              )
            : Container(
                child: CircularProgressIndicator(), // wait for input
              );
      },
    );
  }

  Widget userTile({String name, email}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                email,
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              sendMessage(name);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(24)),
              child: Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  sendMessage(String userName) {
    List<String> users = [Constants.myName, userName];

    String chatRoomId = getChatRoomId(Constants.myName, userName);

    Map<String, dynamic> chatRoom = {
      // like the Firebase Document
      "users": users,
      "chatroomID": chatRoomId,
    };

    databaseMethods.createChatRoom(chatRoomId, chatRoom);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                  chatRoomId: chatRoomId,
                )));
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              textInputAction: TextInputAction.go,
                              onSubmitted: (value) => {initiateSearch()},
                              controller: searchEditingController,
                              style: simpleTextStyle(),
                              decoration: InputDecoration(
                                  hintText: "search username ...",
                                  hintStyle: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 16,
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () => {initiateSearch()},
                                      icon: Icon(Icons.search,
                                          color: Colors.white))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // userList()
                    searchUsersList()
                  ],
                ),
              ));
  }
}
