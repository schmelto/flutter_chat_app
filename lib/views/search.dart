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

  initiateSearch() async {
    databaseMethods.getUserByName(searchEditingController.text).then((value) {
      print(value.toString());
    });
  }

  Widget userList(){
    //TODO
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                                onPressed: (){
                                  initiateSearch();
                                },
                                icon: Icon(Icons.search, color: Colors.white))),
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
