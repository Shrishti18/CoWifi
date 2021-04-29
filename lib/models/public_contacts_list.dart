import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cowifi/models/public_contact_tile.dart';
import 'package:cowifi/models/shared.dart';
import 'package:cowifi/services/firebase_auth.dart';
import 'package:cowifi/services/firebase_firestore.dart';

class PublicContactsList extends StatefulWidget {
  final MyUser user;
  PublicContactsList(this.user);
  @override
  _PublicContactsListState createState() => _PublicContactsListState(user);
}

class _PublicContactsListState extends State<PublicContactsList> {
  final MyUser user;
  _PublicContactsListState(this.user);

  String searchText;
  double _radius = 1.0;
  double _sliderPos = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: Database.userdata(user),
        builder: (context, _snapshot) {
          Map data = _snapshot.data;
          return data == null
              ? Container()
              : Container(
                  child: StreamBuilder<Object>(
                      stream:
                          Database.getUsersNearMe(data["location"], _radius),
                      builder: (context, snapshot) {
                        List<String> userList = snapshot.data;
                        Map status = data["status"];
                        GeoPoint userLocation = data["location"]["geopoint"];
                        return Column(
                          children: [
                            searchBar(),
                            searchRadiusPicker(),
                            (userList == null || userList.length == 1)
                                ? Expanded(
                                    child: Center(
                                      child: Text("No results found"),
                                    ),
                                  )
                                : Expanded(
                                    child: Scrollbar(
                                      isAlwaysShown: true,
                                      thickness: 10.0,
                                      child: ListView.builder(
                                          controller: new ScrollController(),
                                          itemCount: userList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return PublicContactTile(
                                                userLocation,
                                                status,
                                                userList[index],
                                                searchText);
                                          }),
                                    ),
                                  ),
                          ],
                        );
                      }),
                );
        });
  }

  Widget searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: TextField(
        decoration: inputdecoration.copyWith(hintText: "search for product"),
        onChanged: (value) {
          searchText = value.toString();
          setState(() {});
        },
      ),
    );
  }

  Widget searchRadiusPicker() {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10.0),
          child: Text(
            "Search Radius: ${_radius.round().toString()} Km",
            style: TextStyle(fontSize: 16.0, letterSpacing: 1.2),
          ),
        ),
        Slider(
            value: _sliderPos,
            min: 0.0,
            max: 11.55075,
            onChanged: (value) {
              _sliderPos = value;
              _radius = pow(2.0, _sliderPos);
              setState(() {});
            }),
      ],
    ));
  }
}
