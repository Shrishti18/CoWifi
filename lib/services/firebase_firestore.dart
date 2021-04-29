import 'firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static final CollectionReference myCollection =
      FirebaseFirestore.instance.collection('users');
  static final geo = Geoflutterfire();

  static Stream<Map> userdata(MyUser user) {
    final DocumentReference myDoc = myCollection.doc(user.uid);
    return myDoc.snapshots().map((snapshot) => snapshot.data());
  }

  static Stream<Map> getContactInfo(dynamic contactId) {
    final DocumentReference myDoc = myCollection.doc(contactId);
    return myDoc.snapshots().map((snapshot) => snapshot.data());
  }

  static Stream<List<String>> getUsersNearMe(
      dynamic data, double searchRadius) {
    GeoPoint center = data["geopoint"];
    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: myCollection)
        .within(
            center: geo.point(
                latitude: center.latitude, longitude: center.longitude),
            radius: searchRadius,
            strictMode: (searchRadius > 20.0),
            field: "location");
    return stream.map(_snaphotListToUserIdList);
  }

  static List<String> _snaphotListToUserIdList(
      List<DocumentSnapshot> snapshots) {
    List<String> userList = [];
    snapshots.forEach((element) {
      userList.add(element.id);
    });
    return userList;
  }

  static Future<bool> isRegistered(MyUser user) async {
    final DocumentSnapshot snap = await myCollection.doc(user.uid).get();
    if (snap == null || !snap.exists) return false;
    return true;
  }

  static Future<void> setUserDetails(
      //sync contacts
      String name,
      String city,
      double latitude,
      double longitude,
      MyUser user) async {
    final DocumentReference myDoc = myCollection.doc(user.uid);
    GeoFirePoint myLocation =
        geo.point(latitude: latitude, longitude: longitude);
    DocumentSnapshot snapshot = await myCollection.doc("general").get();
    Map<String, dynamic> status = {};
    List<dynamic> products = snapshot.data()["products"];
    products.forEach((element) {
      status[element] = "none";
    });
    Map<String, dynamic> myData = {
      "name": name,
      "location": myLocation.data,
      "number": user.phone,
      "status": status,
      "contacts": [],
      "city": city,
      "description": ""
    };
    await myDoc.set(myData);
  }

  static Future<void> updateStatusAndDescription(
      MyUser user, Map status, String description) async {
    DocumentReference myDoc = myCollection.doc(user.uid);
    await myDoc.update({"status": status, "description": description});
  }

  static Future<void> removeStatus(
      MyUser user, String product, Map status) async {
    try {
      DocumentReference myDoc = myCollection.doc(user.uid);
      status[product] = "none";
      await myDoc.update({"status": status});
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<List<String>> getUserIdList(
      Set<String> phoneNumbers, Function setProgress) async {
    Query query = myCollection;
    List<String> userList = [];
    for (int i = 0; i < phoneNumbers.length; i++) {
      setProgress(phoneNumbers.length - 1, i);
      QuerySnapshot snapshot = await query
          .where("number", isEqualTo: phoneNumbers.elementAt(i))
          .get();
      snapshot.docs.forEach((element) {
        userList.add(element.id);
      });
    }
    return userList;
  }

  static Future<void> updateContacts(MyUser user, List<String> userList) async {
    DocumentReference myDoc = myCollection.doc(user.uid);
    try {
      await myDoc.update({"contacts": userList});
    } catch (e) {
      print(e.toString());
      return;
    }
    print("Success");
  }

  static Future<List<dynamic>> getProductsList() async {
    DocumentSnapshot snapshot = await myCollection.doc("general").get();
    return snapshot.data()["products"];
  }

  static Future<void> update(MyUser user, String field, String value) async {
    DocumentReference myDoc = myCollection.doc(user.uid);
    await myDoc.update({field: value});
  }

  static Future<void> updateLocation(
      MyUser user, double latitude, double longitude) async {
    DocumentReference myDoc = myCollection.doc(user.uid);
    await myDoc.update(
        {"location": geo.point(latitude: latitude, longitude: longitude).data});
  }
}
