import 'package:flutter/material.dart';
import 'package:cowifi/services/call_number.dart';

InputDecoration inputdecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[600], width: 1.2),
      borderRadius: BorderRadius.circular(4.0)),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent[400]),
      borderRadius: BorderRadius.circular(4.0)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.lightBlue[900], width: 1.6),
      borderRadius: BorderRadius.circular(4.0)),
  focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent[400]),
      borderRadius: BorderRadius.circular(4.0)),
);

showPopUpDescription(BuildContext context, Map data) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(data["name"]),
            ],
          ),
          content: Text(data["description"]),
          actions: [
            ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.amber)),
                icon: Icon(Icons.call),
                onPressed: () {
                  CallService.call(data["number"]);
                },
                label: Text("Call")),
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
