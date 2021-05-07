import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:cowifi/screens/about_screen.dart';
import 'package:cowifi/services/location_service.dart';
import 'package:cowifi/models/shared.dart';
import 'package:cowifi/services/firebase_auth.dart';
import 'package:cowifi/services/firebase_firestore.dart';
import 'package:toast/toast.dart';

class Settings extends StatefulWidget {
  final MyUser user;
  Settings(this.user);
  @override
  _SettingsState createState() => _SettingsState(user);
}

class _SettingsState extends State<Settings> {
  final MyUser user;
  _SettingsState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3ebdb),
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Edit Details"),
            subtitle: Text("change name and city"),
            leading: Icon(Icons.edit_attributes_rounded),
            onTap: () {
              showEditNameAndCityPopup();
            },
          ),
          Divider(),
          ListTile(
              title: Text("Edit Current Location"),
              subtitle:
                  Text("update your current location to search nearby users"),
              leading: Icon(Icons.edit_location_rounded),
              onTap: () {
                showEditCurrentLocationPopup();
              }),
          Divider(),
          ListTile(
            leading: Icon(Icons.person_remove),
            title: Text("Sign Out"),
            subtitle: Text("sign out of your account"),
            onTap: () {
              showConfirmSignOutPopup();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Help"),
            subtitle: Text("How to use app, contact us"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => About()));
            },
          ),
        ],
      ),
    );
  }

  showEditNameAndCityPopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final _formkey = GlobalKey<FormState>();
          String _name = '';
          String _city = '';
          return AlertDialog(
            title: Row(
              children: [
                Text("Edit Name and City"),
              ],
            ),
            content: Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                        decoration: inputdecoration.copyWith(hintText: 'Name'),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value.characters.length > 15) {
                            return 'Name should be below 15 characters';
                          } else if (value.characters.length <= 0) {
                            return 'Name should not be empty';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          _name = val;
                          setState(() {});
                        }),
                    SizedBox(height: 20.0),
                    TextFormField(
                        decoration:
                            inputdecoration.copyWith(hintText: 'City name'),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value.characters.length <= 0) {
                            return 'City name should not be empty';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          _city = val;
                          setState(() {});
                        }),
                  ],
                )),
            actions: [
              ElevatedButton.icon(
                  icon: Icon(Icons.upgrade),
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      try {
                        await Database.update(user, "name", _name);
                        await Database.update(user, "city", _city);
                        Navigator.pop(context);
                        Toast.show("updated", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                      } catch (e) {
                        Toast.show("Couldn't update try again", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      }
                    }
                  },
                  label: Text("Update")),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.cancel,
                  size: 35.0,
                ),
              )
            ],
          );
        });
  }

  showEditCurrentLocationPopup() {
    getCurrentLocation() async {
      LocationData myLocation =
          await LocationService(context).getCurrentLocation();
      if (myLocation == null) {
        throw Error();
      } else {
        await Database.updateLocation(
            user, myLocation.latitude, myLocation.longitude);
      }
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Text("Edit GPS Location"),
              ],
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning),
                Text(
                  "By providing your location you are accepting to able to seen by other users",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green)),
                onPressed: () async {
                  try {
                    await getCurrentLocation();
                    Navigator.pop(context);
                    Toast.show("updated", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  } catch (e) {
                    Toast.show(
                        "Couldn't update location, please make sure to allow all requests and try again",
                        context,
                        duration: Toast.LENGTH_LONG,
                        gravity: Toast.BOTTOM);
                  }
                },
                icon: Icon(Icons.gps_fixed),
                label: Text("Use Current Location"),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.cancel,
                  size: 35.0,
                ),
              )
            ],
          );
        });
  }

  showConfirmSignOutPopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Text("Confirm Sign-Out"),
              ],
            ),
            content: Text(
                "You are about to sign-out of the app and if done so, you will have to enter phone number and otp to sign in agian."),
            actions: [
              TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.teal),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    FirebaseAuthenticate.signout();
                    Navigator.pop(context);
                  },
                  child: Text("Confirm")),
            ],
          );
        });
  }
}
