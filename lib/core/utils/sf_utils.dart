import 'package:shared_preferences/shared_preferences.dart';

storeListToSF(String stringKey, List<String> stringVal) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList(stringKey, stringVal);
}

storeStringToSF(String stringKey, String stringVal) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(stringKey, stringVal);
}

storeIntToSF(String intKey, int intVal) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(intKey, intVal);
}

storeDoubleToSF(String doubleKey, double doubleVal) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble(doubleKey, doubleVal);
}

storeBoolToSF(String boolKey, bool boolVal) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(boolKey, boolVal);
}

Future<List<String>?> fetchListValuesSF(String stringKey) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(stringKey);
}

Future<String> fetchStringValuesSF(String stringKey) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(stringKey) ?? "";
}

Future<bool> fetchBoolValuesSF(String boolKey) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(boolKey) ?? false;
}

Future<void> clearValueFromSF(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}
