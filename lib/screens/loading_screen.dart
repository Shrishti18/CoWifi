import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cowifi/screens/main_screen.dart';
import 'package:cowifi/screens/register_screen.dart';
import 'package:cowifi/services/firebase_auth.dart';
import 'package:cowifi/services/firebase_firestore.dart';
import 'package:toast/toast.dart';

class Loading extends StatefulWidget {
  final MyUser user;
  Loading(this.user);
  @override
  _LoadingState createState() => _LoadingState(user);
}

class _LoadingState extends State<Loading> {
  final MyUser user;
  _LoadingState(this.user);

  bool loading;
  bool isRegistered;

  @override
  void initState() {
    loading = true;
    super.initState();
    getUserStatus();
  }

  getUserStatus() async {
    try {
      isRegistered = await Database.isRegistered(user);
      loading = false;
      setState(() {});
    } catch (e) {
      Toast.show("Couldn't reach server, check your connection", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            color: Color(0xfff3ebdb),
            child: Center(
              child: SpinKitRing(
                color: Colors.teal,
                size: 50.0,
              ),
            ),
          )
        : isRegistered
            ? Main(user)
            : Register(user);
  }
}
