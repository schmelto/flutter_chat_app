import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/auth.dart';
import 'package:flutter_chat_app/services/database.dart';
import 'package:flutter_chat_app/views/chatRoomScreen.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';
import 'package:flutter_chat_app/helper/helperfunctions.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      HelperFunctions.saveUserEmailSharedPreference(
          emailEditingController.text);

      await authMethods
          .signInWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((value) async {
        if (value != null) {
          Stream userStream =
              await databaseMethods.getUserByEmail(emailEditingController.text);

          // TODO: refactor method -> not with for each -> only one result is necessary
          userStream.forEach((field) {
            QuerySnapshot snapshot = field;
            DocumentSnapshot ds = snapshot.docs[0];
            HelperFunctions.saveUserLoggedInSharedPreference(true);
            HelperFunctions.saveUserNameSharedPreference(ds["name"]);
            HelperFunctions.saveUserEmailSharedPreference(ds["email"]);
          });

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(child: Center(child: CircularProgressIndicator()),)
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 100,
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : "Please Enter Correct Email";
                            },
                            controller: emailEditingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("email"),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val.length > 6
                                  ? null
                                  : "Enter Password 6+ characters";
                            },
                            style: simpleTextStyle(),
                            controller: passwordEditingController,
                            decoration: textFieldInputDecoration("password"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // TODO: forget password
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ForgotPassword()));
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                "Forgot Password?",
                                style: simpleTextStyle(),
                              )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        signIn();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xff007EF4),
                                const Color(0xff2A75BC)
                              ],
                            )),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Sign In",
                          style: mediumTextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Sign In with Google",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account? ",
                          style: simpleTextStyle(),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toggleView();
                          },
                          child: Text(
                            "Register now",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
    ),);
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: appBarMain(context),
  //     body: SingleChildScrollView(
  //       child: Container(
  //         height: MediaQuery.of(context).size.height - 100,
  //         alignment: Alignment.center,
  //         child: Container(
  //           padding: EdgeInsets.symmetric(horizontal: 24),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               TextField(
  //                   style: simpleTextStyle(),
  //                   decoration: textFieldInputDecoration("email")),
  //               TextField(
  //                   style: simpleTextStyle(),
  //                   obscureText: true,
  //                   decoration: textFieldInputDecoration("password")),
  //               SizedBox(
  //                 height: 8,
  //               ),
  //               Container(
  //                 alignment: Alignment.centerRight,
  //                 child: Container(
  //                   padding: EdgeInsets.symmetric(
  //                     horizontal: 16,
  //                     vertical: 16,
  //                   ),
  //                   child: Text(
  //                     "Forgot Password?",
  //                     style: simpleTextStyle(),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 8,
  //               ),
  //               GestureDetector(
  //                 onTap: (value) {
  //                   SignIn();
  //                 },
  //                 child: Container(
  //                   alignment: Alignment.center,
  //                   width: MediaQuery.of(context).size.width,
  //                   padding: EdgeInsets.symmetric(vertical: 16),
  //                   decoration: BoxDecoration(
  //                     gradient: LinearGradient(
  //                       colors: [
  //                         const Color(0xff007EF4),
  //                         const Color(0xff2A75BC),
  //                       ],
  //                     ),
  //                     borderRadius: BorderRadius.circular(30),
  //                   ),
  //                   child: Text("Sign In", style: mediumTextStyle())),
  //               ),

  //               SizedBox(
  //                 height: 8,
  //               ),
  //               Container(
  //                   alignment: Alignment.center,
  //                   width: MediaQuery.of(context).size.width,
  //                   padding: EdgeInsets.symmetric(vertical: 16),
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.circular(30),
  //                   ),
  //                   child: Text(
  //                     "Sign In with Google",
  //                     style: TextStyle(
  //                       color: Colors.black87,
  //                       fontSize: 17,
  //                     ),
  //                   )),
  //               SizedBox(
  //                 height: 8,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     "Don't have an account? ",
  //                     style: simpleTextStyle(),
  //                   ),
  //                   GestureDetector(
  //                     onTap: () {
  //                       widget.toggleView();
  //                     },
  //                     child: Container(
  //                       padding: EdgeInsets.symmetric(vertical: 8),
  //                       child: Text("Register now",
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 17,
  //                             decoration: TextDecoration.underline,
  //                           )),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: 50,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
