import 'package:contacts_service/contacts_service.dart';
import 'package:cowifi/services/firebase_auth.dart';
import 'package:cowifi/services/firebase_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

/// check if the string contains only numbers
bool isNumeric(String str) {
  RegExp _numeric = RegExp(r'^-?[0-9]+$');
  return _numeric.hasMatch(str);
}

Future<PermissionStatus> getContactPermission() async {
  final permission = await Permission.contacts.status;

  if (permission != PermissionStatus.granted &&
      permission != PermissionStatus.permanentlyDenied) {
    final newPermission = await Permission.contacts.request();

    return newPermission ?? PermissionStatus.restricted;
  } else {
    return permission;
  }
}

Future<void> syncContacts(MyUser user, Function setProgress) async {
  Iterable<Contact> contacts = await ContactsService.getContacts();
  List<String> phoneNumbers = [];
  contacts.forEach((contact) {
    Iterable<Item> numbers = contact.phones;
    numbers.forEach((element) {
      String number = element.value.trim().replaceAll("-", "");
      if (number.startsWith("+91") &&
          number.length == 13 &&
          isNumeric(number.substring(3))) {
        phoneNumbers.add(number);
      }
      if (number.length == 10 && isNumeric(number)) {
        phoneNumbers.add("+91" + number);
      }
    });
  });
  List<String> userList =
      await Database.getUserIdList(phoneNumbers.toSet(), setProgress);

  await Database.updateContacts(user, userList);
}
