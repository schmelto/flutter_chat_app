import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();

  QuerySnapshot searchSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if (searchEditingController.text.isEmpty) {
      setState(() {
        isLoading = true;
      });
    }
    await databaseMethods
        .getUserByName(searchEditingController.text)
        .then((value) {
      searchSnapshot = value;
      setState(() {
        isLoading = false;
        haveUserSearched = true;
      });
    });
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return userTile(
                searchSnapshot.docs[0].data()["username"],
                searchSnapshot.docs[0].data()["userEmail"],
              );
            },
          )
        : Container(
          child: Text("Text", style: simpleTextStyle(),),
        );
  }

  Widget userTile(String userName, String userEmail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                userEmail,
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              //TODO: sendMessage(userName);
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
                      // padding:
                      //     EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchEditingController,
                              style: simpleTextStyle(),
                              decoration: InputDecoration(
                                  hintText: "search username ...",
                                  hintStyle: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 16,
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () => {
                                            initiateSearch()
                                          }, //TODO: on pressed
                                      icon: Icon(Icons.search,
                                          color: Colors.white))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    userList()
                  ],
                ),
              ));
  }
}
