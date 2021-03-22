import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';
import 'package:flutter_chat_app/services/auth.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController emailEditingController = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  AuthMethods authMethods = new AuthMethods();

  resetPassword(){
    authMethods.resetPassword(emailEditingController.text);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("forgot password")),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  // key: formKey,
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
                    ],
                  ),
                ),
                SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        resetPassword();
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
                          "Reset Password",
                          style: mediumTextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
