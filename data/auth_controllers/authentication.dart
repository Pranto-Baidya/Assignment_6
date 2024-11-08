

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/data/models/user_model.dart';

class authentication{

  static const String _accessKey = 'access-token';
  static const String _userDataKey = 'user-data';

  static String? accessToken;
  static userModel? userData;

  static Future<void> saveAccessToken(String token)async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessKey, token);
    accessToken = token;

  }

  static Future<void> saveUserData(userModel model)async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_userDataKey, jsonEncode(model.toJson()));
    userData = model;
  }

  static Future<String?> getAccessToken()async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessKey);

    accessToken = token;
    return token;

  }

  static Future<userModel?> getUserData()async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? userEncodedData = sharedPreferences.getString(_userDataKey);

    if(userEncodedData==null){
      return null;
    }

    userModel model = userModel.fromJson(jsonDecode(userEncodedData));
    userData = model;
    return model;
  }

  static bool isLoggedIn(){
    return accessToken!=null;
  }

  static Future<void> clearUserData()async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    accessToken = null;

  }

}