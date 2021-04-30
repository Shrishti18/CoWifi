import 'package:flutter/material.dart';
import 'package:cowifi/models/shared.dart';
import 'package:cowifi/services/call_number.dart';
import 'package:cowifi/services/firebase_firestore.dart';

class ContactTile extends StatelessWidget {
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

  ContactTile(this.contactId, this.searchText);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: Database.getContactInfo(contactId),
        builder: (context, snapshot) {
          Map data = snapshot.data;
          if (data != null) {
            if (data["name"]
                    .toString()
                    .toLowerCase()
                    .startsWith(searchText.toLowerCase()) ||
                data["city"]
                    .toString()
                    .toLowerCase()
                    .startsWith(searchText.toLowerCase()) ||
                _isProviderOrRequesterOfProductStartsWith(
                    data["status"], searchText)) {
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      showPopUpDescription(context, data);
                    },
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.person,
                        size: 20.0,
                      ),
                    ),
                    title: Text(
                      data["name"],
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 18.0),
                    ),
                    trailing: Text(data["city"]),
                  ),
                  data == null
                      ? Text("Loading...")
                      : showContactStatus(data["status"]),
                  Divider(),
                ],
              );
            }
          }
          return Container();
        });
  }

  Widget showContactStatus(Map status) {
    return Container(
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
