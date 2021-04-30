import 'package:flutter/material.dart';
import 'package:cowifi/models/shared.dart';
import 'package:cowifi/services/firebase_auth.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final _formkey = GlobalKey<FormState>();
  String _number = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3ebdb),
      appBar: AppBar(
        title: Text("Log In"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 30.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                  decoration:
                      inputdecoration.copyWith(hintText: 'Phone Number'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.characters.length != 10) {
                      return 'Phone number length should be 10';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    _number = val;
                    setState(() {});
                  }),
              SizedBox(height: 20.0),
              ElevatedButton.icon(
                icon: Icon(Icons.person),
                onPressed: () {
                  if (_formkey.currentState.validate()) {
                    FirebaseAuthenticate.verifyPhoneNumber(_number, context);
                  }
                },
                label: Text("Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
