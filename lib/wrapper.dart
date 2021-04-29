import 'package:flutter/material.dart';
import 'package:cowifi/screens/authenticate_screen.dart';
import 'package:cowifi/screens/loading_screen.dart';
import 'package:cowifi/services/firebase_auth.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    return (user == null) ? Authenticate() : Loading(user);
  }
}
