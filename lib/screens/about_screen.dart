import 'package:flutter/material.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("How to Use"),
            tileColor: Colors.blueGrey[100],
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Home",
                    style: TextStyle(fontSize: 18.0, color: Colors.teal),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "1. Click on Add Product",
                  ),
                  SizedBox(height: 10),
                  Text(
                      "2. Select the product as a requester or provider from the dropdown, You can add a description like units of plasma, quantities of oxygen cylinders, etc."),
                  SizedBox(height: 10),
                  Text(
                    "3. You can simply use the location slider to see people who can fulfill your requirements in more range. \n\nNow keep calm, our application will show you the nearest provider/requester, on tap, you can simply call them, and read the description about the product if any",
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "My Contacts",
                    style: TextStyle(fontSize: 18.0, color: Colors.teal),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "where all your contacts who have registered with us would be seen upon syncing ",
                  ),
                  SizedBox(height: 10),
                  Text("Note :"),
                  SizedBox(height: 10),
                  Text(
                    "you can sync your contacts if you have added new contacts, it might take few minutes.",
                  ),
                ],
              ),
            ),
          ),
          ListTile(
              title: Text("Contact Us"),
              tileColor: Colors.blueGrey[100],
              trailing: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.email,
                    size: 15.0,
                  ),
                  label: Text("locus02021@gmail.com"))),
        ],
      ),
    );
  }
}
