// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'package:fast_contacts/fast_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viserpay/core/utils/my_strings.dart';

//attention: use this package https://pub.dev/packages/fast_contacts
class ContactController extends GetxController {
  List<Contact> contacts = [];
  List<Contact> filterContact = [];
  bool isLoading = false;

  // @override
  // void onInit() async {
  //   await Permission.storage.request();
  //   getContact();
  //   super.onInit();
  // }

  //
  bool isPermissonGranted = false;
  Future<void> getContact() async {
    isLoading = true;
    isPermissonGranted = false;
    contacts = [];
    filterContact = [];
    update();

    if (await Permission.contacts.status.isGranted) {
      isPermissonGranted = true;

      final list = await FastContacts.getAllContacts(fields: [ContactField.displayName, ContactField.phoneNumbers]);
      contacts.clear();
      contacts.addAll(list);
      filterContact.addAll(list);
      update();
    } else {
      try {
        await Permission.contacts.request();
        if (await Permission.contacts.status.isGranted) {
          isPermissonGranted = true;
          final list = await FastContacts.getAllContacts(fields: [ContactField.displayName, ContactField.phoneNumbers]);
          contacts.clear();
          contacts.addAll(list);
          filterContact.addAll(list);
        }
      } catch (e) {
        print(e);
      }
    }
    isLoading = false;
    update();
  }

  void searchContact(String val) {
    if (filterContact.isEmpty) {
      filterContact.addAll(contacts);
    } else {
      filterContact.addAll(contacts.where((element) => element.displayName.toLowerCase().contains(val.toLowerCase())).toList());
      update();
    }
  }

  bool isSearching = false;
  void filterContacts(String query) {
    isSearching = true;
    update();

    if (query.isEmpty) {
      filterContact = contacts;
    } else {
      filterContact = contacts.where((country) => country.displayName.toLowerCase().contains(query.toLowerCase())).toList();
    }

    isSearching = false;
    update();
  }

  String getUserName(String mobileNumber) {
    String name = '';
    name = contacts
        .firstWhere(
          (country) => country.phones.any(
            (e) => e.number.toString() == mobileNumber,
            // Use any() instead of map() to check if any phone number matches
          ),
          orElse: () => Contact.fromMap(const {
            "structuredName": {"displayName": MyStrings.phoneNumber}
          }), // Handle the case where no match is found
        )
        .displayName;

    return name;
  }
}
