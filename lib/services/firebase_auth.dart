import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class MyUser {
  String uid;
  String phone;

  MyUser(User user) {
    this.uid = user.uid;
    this.phone = user.phoneNumber;
  }
}

class FirebaseAuthenticate {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Stream<MyUser> get user {
    return _auth.authStateChanges().map((User user) {
      return (user == null) ? null : MyUser(user);
    });
  }

  static signout() {
    _auth.signOut();
  }

  static verifyPhoneNumber(String phoneNumber, BuildContext context) async {
    String otp = '';
    _auth.verifyPhoneNumber(
        phoneNumber: "+91" + phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Toast.show("logged in", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        },
        verificationFailed: (FirebaseAuthException e) {
          Toast.show(e.code, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        },
        codeSent: (String verificationId, int resendToken) async {
          Toast.show("Code Sent", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          otp = await _showEnterOtpPopup(context);
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: otp);

          // Sign the user in (or link) with the credential
          try {
            await _auth.signInWithCredential(credential);
            Toast.show("logged in", context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          } on PlatformException catch (e) {
            Toast.show(e.toString(), context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          } catch (e) {
            Toast.show(
                "Some error occured, try again and make sure to enter correct otp",
                context,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.BOTTOM);
          }
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          print("Auto retrival timeout");
        });
  }
}

Future<String> _showEnterOtpPopup(BuildContext context) {
  TextEditingController myController = TextEditingController();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter OTP"),
          content: TextField(
            controller: myController,
            keyboardType: TextInputType.number,
            maxLength: 6,
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(myController.text.toString());
                },
                child: Text("Verify"))
          ],
        );
      });
}
