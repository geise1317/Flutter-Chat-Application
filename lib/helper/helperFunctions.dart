import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{

  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";
  static String sharedPreferenceTargetNameKey = "TARGETKEY";

  // saving data to sharedPreference
  static Future<void> saveUserLoggedInSharedPreference(bool isUserLoggedIn) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<void> saveUserNameSharedPreference(String userName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<void> saveUserEmailSharedPreference(String userEmail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<void> saveTargetNameSharedPreference(String targetName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(sharedPreferenceTargetNameKey, targetName);
  }

  // getting data from sharedPreference
  static Future<bool?> getUserLoggedInSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String?> getUserNameSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future<String?> getUserEmailSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserEmailKey);
  }

  static Future<String?> getTargetNameSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceTargetNameKey);
  }
}