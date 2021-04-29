import 'package:flutter/material.dart';
import 'package:cowifi/models/contact_tile.dart';

class ContactsList extends StatelessWidget {
  final Map data;
  final String searchText;
  ContactsList(this.data, this.searchText);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: data["contacts"].length,
          itemBuilder: (BuildContext context, int index) {
            return ContactTile(data["contacts"][index], searchText);
          }),
    );
  }
}
