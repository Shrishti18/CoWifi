import 'package:flutter/material.dart';
import 'package:cowifi/screens/contacts_screen.dart';
import 'package:cowifi/screens/home_screen.dart';
import 'package:cowifi/screens/settings_screen.dart';
import 'package:cowifi/services/firebase_auth.dart';

class Main extends StatefulWidget {
  final MyUser user;
  Main(this.user);
  @override
  _MainState createState() => _MainState(user);
}

class _MainState extends State<Main> {
  final MyUser user;
  _MainState(this.user);

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'My Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
      body: [Home(user), ContactScreen(user), Settings(user)]
          .elementAt(_selectedIndex),
    );
  }
}
