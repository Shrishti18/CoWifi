import 'package:flutter/material.dart';
import 'package:cowifi/services/call_number.dart';
import 'package:cowifi/services/firebase_auth.dart';
import 'package:cowifi/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  set();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser>.value(
      value: FirebaseAuthenticate.user,
      initialData: null,
      child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.teal,
          ),
          home: Wrapper()),
    );
  }
}
