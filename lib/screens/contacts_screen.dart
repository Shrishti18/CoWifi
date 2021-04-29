import 'package:flutter/material.dart';
import 'package:cowifi/models/contact_list.dart';
import 'package:cowifi/models/shared.dart';
import 'package:cowifi/services/firebase_auth.dart';
import 'package:cowifi/services/firebase_firestore.dart';
import 'package:cowifi/services/sync_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';

class ContactScreen extends StatefulWidget {
  final MyUser user;
  ContactScreen(this.user);

  @override
  _ContactScreenState createState() => _ContactScreenState(user);
}

class _ContactScreenState extends State<ContactScreen> {
  final MyUser user;
  _ContactScreenState(this.user);

  bool _loading = false;
  int _totContacts;
  int _syncedContacts;
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: Database.userdata(user),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.brown[50],
            appBar: AppBar(
              title: Text("My Contacts"),
              actions: [
                TextButton.icon(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    _syncedContacts = 0;
                    setState(() {});
                    getContacts();
                  },
                  icon: Icon(Icons.sync),
                  label: Text("Sync"),
                )
              ],
            ),
            body: Column(
              children: [
                searchBar(),
                _loading || snapshot.data == null
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitFadingCircle(
                              color: Colors.blue,
                              size: 50.0,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _totContacts != null && _syncedContacts != null
                                ? Text(
                                    "Contacts Synced  ${_syncedContacts.toString()} out of ${_totContacts.toString()}")
                                : Container(),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Don't go back or change screen while syncing")
                          ],
                        ),
                      )
                    : ContactsList(snapshot.data, _searchText),
              ],
            ),
          );
        });
  }

  getContacts() async {
    PermissionStatus permission = await getContactPermission();
    if (permission == PermissionStatus.granted) {
      setState(() {
        _loading = true;
      });
      try {
        await syncContacts(user, setSyncProgress);
        Toast.show("Contacts synced successfully", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } catch (e) {
        Toast.show("something went wrong please try again", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
      setState(() {
        _loading = false;
      });
    } else {
      Toast.show(
          "Contacts permission is needed to continue, please allow", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  setSyncProgress(int tot, int synced) {
    setState(() {
      _totContacts = tot;
      _syncedContacts = synced;
    });
  }

  Widget searchBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: TextField(
        decoration: inputdecoration.copyWith(
            hintText: "search by products, name, city"),
        onChanged: (value) {
          _searchText = value.toString();
          setState(() {});
        },
      ),
    );
  }
}
