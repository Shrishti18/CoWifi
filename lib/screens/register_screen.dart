import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:cowifi/services/location_service.dart';
import 'package:cowifi/models/shared.dart';
import 'package:cowifi/services/firebase_auth.dart';
import 'package:cowifi/services/firebase_firestore.dart';
import 'package:cowifi/wrapper.dart';
import 'package:toast/toast.dart';

class Register extends StatefulWidget {
  final MyUser user;
  Register(this.user);

  @override
  _RegisterState createState() => _RegisterState(user);
}

class _RegisterState extends State<Register> {
  final MyUser user;
  _RegisterState(this.user);

  final _formkey = GlobalKey<FormState>();
  String _name = '';
  String _city = '';
  double _latitude;
  double _longitude;

  bool loading;

  @override
  void initState() {
    super.initState();
    loading = false;
  }

  uploadDetails() async {
    setState(() {
      loading = true;
    });
    try {
      await Database.setUserDetails(_name, _city, _latitude, _longitude, user);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Wrapper()));
    } catch (e) {
      setState(() {
        loading = false;
        Toast.show("Couldn't reach server, check your connection", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      });
    }
  }

  getCurrentLocation() async {
    loading = true;
    setState(() {});
    LocationData myLocation =
        await LocationService(context).getCurrentLocation();
    if (myLocation == null) {
      Toast.show("Please allow app to read location to continue", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      _latitude = myLocation.latitude;
      _longitude = myLocation.longitude;
    }
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3ebdb),
      appBar: AppBar(
        title: Text("Enter Details"),
      ),
      body: loading
          ? Center(child: Text("Loading..."))
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 60.0, horizontal: 30.0),
              child: (_latitude == null && _longitude == null)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.warning),
                        Text(
                          "By providing your location you are accepting to able to seen by other users",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.0),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green)),
                          onPressed: () {
                            getCurrentLocation();
                          },
                          icon: Icon(Icons.gps_fixed),
                          label: Text("Use Current Location"),
                        ),
                      ],
                    )
                  : Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                              decoration:
                                  inputdecoration.copyWith(hintText: 'Name'),
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
                              decoration: inputdecoration.copyWith(
                                  hintText: 'City name'),
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
                          SizedBox(height: 20.0),
                          ElevatedButton(
                              onPressed: () async {
                                if (_formkey.currentState.validate()) {
                                  await _showMyDialog();
                                  uploadDetails();
                                }
                              },
                              child: Text("Register"))
                        ],
                      ),
                    ),
            ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            Icon(Icons.warning_amber_outlined),
            SizedBox(width: 10),
            Text('DISCLAMER')
          ]),
          content: Text(
              'The services deal with location and contacts, so to work, the service needs to keep your location and contacts public'),
          actions: <Widget>[
            TextButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
