import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cowifi/models/shared.dart';
import 'package:cowifi/services/firebase_auth.dart';
import 'package:cowifi/services/firebase_firestore.dart';
import 'package:toast/toast.dart';

class AddStatus extends StatefulWidget {
  final MyUser user;
  final String description;
  final Map data;
  AddStatus(this.user, this.description, this.data);
  @override
  _AddStatusState createState() => _AddStatusState(user, description, data);
}

class _AddStatusState extends State<AddStatus> {
  final MyUser user;
  String description;
  Map data;
  List<Widget> productsList = [];
  bool loading = true;

  _AddStatusState(this.user, this.description, this.data);

  final TextEditingController myController = TextEditingController();

  getProductList() async {
    try {
      List<dynamic> products = await Database.getProductsList();
      Map newData = {};
      products.forEach((product) {
        if (data.containsKey(product))
          newData[product] = data[product];
        else
          newData[product] = "none";
      });
      loading = false;
      data = newData;
      data.keys.forEach((product) {
        productsList.add(productTile(product));
      });
      setState(() {});
    } catch (e) {
      Toast.show("Couldn't reach server, check your connection", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  @override
  void initState() {
    super.initState();
    getProductList();
    myController.text = description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: loading
          ? Center(
              child: SpinKitFadingCircle(
                color: Colors.teal,
                size: 50.0,
              ),
            )
          : Container(
              color: Colors.blueGrey[50],
              child: ListView(
                children: [
                      editDescription(),
                      searchBar(),
                      Divider(),
                    ] +
                    productsList,
              ),
            ),
      floatingActionButton: ElevatedButton(
        child: Text("Update"),
        onPressed: () async {
          try {
            await Database.updateStatusAndDescription(user, data, description);
            Navigator.pop(context);
          } catch (e) {
            Toast.show(
                "Couldn't update, check your connection and try again", context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          }
        },
      ),
    );
  }

  Widget editDescription() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: myController,
        maxLength: 200,
        maxLines: 3, //wrap text
        autocorrect: true,
        decoration: InputDecoration(
          hintText:
              "(Optional) Details about the product that will be shown to other users.",
          border: OutlineInputBorder(),
          labelText: 'Description',
        ),
        onChanged: (newValue) {
          description = newValue;
          setState(() {});
        },
      ),
    );
  }

  Widget searchBar() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
      child: TextField(
        decoration: inputdecoration.copyWith(hintText: "Search product"),
        onChanged: (text) {
          List<Widget> newList = [];
          data.forEach((key, value) {
            if (text.toString() == null ||
                key
                    .toString()
                    .toLowerCase()
                    .startsWith(text.toString().toLowerCase()))
              newList.add(productTile(key));
          });
          productsList = newList;
          setState(() {});
        },
      ),
    );
  }

  Widget productTile(String product) {
    return Column(
      children: [
        ListTile(
          tileColor: Colors.white,
          leading: CircleAvatar(
            backgroundColor: (data[product] == "none")
                ? Colors.grey
                : (data[product] == "provider")
                    ? Colors.green
                    : Colors.red,
            radius: 20.0,
          ),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product,
                  style: TextStyle(fontSize: 18.0),
                ),
                Container(
                  width: 150.0,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: DropdownButtonFormField(
                    focusColor: Colors.white,
                    value: data[product],
                    items: ["provider", "requester", "none"]
                        .map<DropdownMenuItem<String>>(
                          (String label) => DropdownMenuItem<String>(
                            child: Text(label),
                            value: label,
                          ),
                        )
                        .toList(),
                    hint: Text("Pick Your Status"),
                    onChanged: (value) {
                      data[product] = value;
                      setState(() {});
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.grey[900],
        ),
      ],
    );
  }
}
