import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/user_model.dart';



class AuthController {
  static const String _accessTokenKey = "access-token";
  static const String _userDataKey = "user-data";
  static const String _rememberMeKey = "remember-me";

  static String accessToken = '';
  static UserModel? userData;

  //save token section
  static Future<void> saveUserAccessToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    accessToken = token;
  }

  static Future<String?> getUserAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_accessTokenKey);
  }

  //user data section
  static Future<void> saveUserData(UserModel userModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_userDataKey, jsonEncode(userModel.toJson()));
    userData = userModel;
  }

  static Future<UserModel?> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? data = sharedPreferences.getString(_userDataKey);

    if (data == null) return null;

    UserModel userModel = UserModel.fromJson(jsonDecode(data));
    return userModel;
  }

  //remember section
  static Future<void> saveRememberMeStatus(bool rememberMe) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(_rememberMeKey, rememberMe);
  }

  static Future<bool> getRememberMeStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(_rememberMeKey) ?? false;
  }

  //clear data section
  static Future<void> clearAllData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }

  //check status section
  static Future<bool> checkAuthState() async {
    String? token = await getUserAccessToken();
    bool rememberMe = await getRememberMeStatus();

    if (token == null || !rememberMe) return false;

    accessToken = token;
    userData = await getUserData();

    return true;
  }
}