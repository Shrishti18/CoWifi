import 'package:flutter/material.dart';
import 'package:cowifi/models/public_contacts_list.dart';
import 'package:cowifi/screens/add_status_screen.dart';
import 'package:cowifi/services/firebase_auth.dart';
import 'package:cowifi/services/firebase_firestore.dart';
import 'package:toast/toast.dart';

class Home extends StatefulWidget {
  final MyUser user;
  Home(this.user);

  @override
  _HomeState createState() => _HomeState(user);
}

class _HomeState extends State<Home> {
  final MyUser user;
  _HomeState(this.user);

  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: Database.userdata(user),
        builder: (context, snapshot) {
          return Scaffold(
              backgroundColor: Colors.brown[50],
              appBar: AppBar(
                title: Text("Home"),
              ),
              body: Column(
                children: [
                  userProfile(snapshot.data),
                  snapshot.data == null
                      ? Container()
                      : Expanded(child: PublicContactsList(user)),
                ],
              ));
        });
  }

  Widget userProfile(Map data) {
    return Card(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    child: Icon(Icons.person_rounded,
                        size: 25.0, color: Colors.grey[800]),
                    radius: 25.0,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data != null ? data["name"] : "Loading..",
                            style: TextStyle(fontSize: 20.0)),
                        SizedBox(height: 5.0),
                        Text("Click on \"+ Product\" to add status",
                            style: TextStyle(color: Colors.grey[700]))
                      ],
                    ),
                  ],
                ),
                TextButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey[200])),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddStatus(
                                user, data["description"], data["status"])));
                  },
                  icon: Icon(Icons.add),
                  label: Text("Product"),
                )
              ],
            ),
          ),
          data != null
              ? showStatus(data["status"])
              : Center(
                  child: Text("Loading"),
                ),
        ],
      ),
    );
  }

  Widget showStatus(Map status) {
    return Container(
      height: 120.0,
      child: Scrollbar(
        isAlwaysShown: true,
        thickness: 10.0,
        radius: Radius.circular(5.0),
        child: SingleChildScrollView(
            child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceEvenly,
                children: status.entries
                        .map((e) => statusButton(e.key, e.value, status))
                        .toList() +
                    [Text("Longpress on status to remove it")])),
      ),
    );
  }

  Widget statusButton(String product, String productStatus, Map status) {
    return productStatus == "none"
        ? Container()
        : Container(
            margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0))),
                    backgroundColor: MaterialStateProperty.all(
                        productStatus == "requester"
                            ? Colors.red
                            : Colors.green)),
                onLongPress: () async {
                  try {
                    await Database.removeStatus(user, product, status);
                  } catch (e) {
                    Toast.show(
                        "something went wrong, check your connection and try again",
                        context,
                        duration: Toast.LENGTH_SHORT,
                        gravity: Toast.BOTTOM);
                  }
                },
                onPressed: () {},
                child: Text(product)),
          );
  }
}
