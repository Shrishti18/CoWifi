import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cowifi/models/shared.dart';
import 'package:cowifi/services/call_number.dart';
import 'package:cowifi/services/firebase_firestore.dart';

class PublicContactTile extends StatelessWidget {
  PublicContactTile(
      this.userLocation, this.status, this.contactId, this.searchText);
  final GeoPoint userLocation;
  final Map status;
  final String contactId;
  final String searchText;

  call(String number) {
    CallService.call(number);
  }

  bool _isProviderOrRequesterOfProductStartsWith(
      Map status, String searchText) {
    bool result = false;
    status.forEach((key, value) {
      if (key.toString().toLowerCase().startsWith(searchText.toLowerCase()) &&
          value.toString() != "none") result = true;
    });
    return result;
  }

  bool _isProviderofmyrequestOrRequesterofmyprovision(
      Map myStatus, Map contactStatus) {
    bool result = false;
    myStatus.forEach((key, value) {
      if ((value == "provider" && contactStatus[key] == "requester") ||
          (value == "requester" && contactStatus[key] == "provider")) {
        result = true;
        return;
      }
    });
    return result;
  }

  String distanceFromUserTo(GeoPoint contactLocation) {
    return Geoflutterfire()
            .point(
                latitude: userLocation.latitude,
                longitude: userLocation.longitude)
            .distance(
                lat: contactLocation.latitude, lng: contactLocation.longitude)
            .toString() +
        " km";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: Database.getContactInfo(contactId),
        builder: (context, snapshot) {
          Map data = snapshot.data;
          if (data != null) {
            if (_isProviderofmyrequestOrRequesterofmyprovision(
                status, data["status"])) {
              if (searchText == null ||
                  _isProviderOrRequesterOfProductStartsWith(
                      data["status"], searchText)) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        showPopUpDescription(context, data);
                      },
                      tileColor: Colors.white,
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.person,
                          size: 20.0,
                        ),
                      ),
                      subtitle: Text(data["city"]),
                      title: Text(
                        data["name"],
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18.0),
                      ),
                      trailing: Text(
                        distanceFromUserTo(data["location"]["geopoint"]),
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14.0),
                      ),
                    ),
                    showContactStatus(data["status"]),
                    Divider(),
                  ],
                );
              }
            }
          }
          return Container();
        });
  }

  Widget showContactStatus(Map status) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: status.entries.map((entry) {
          if (entry.value == "none") return Container();
          return Container(
            padding: EdgeInsets.only(right: 25.0),
            child: Text(
              entry.key,
              style: TextStyle(
                  color: entry.value == "provider" ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w700),
            ),
          );
        }).toList(),
      ),
    );
  }
}
