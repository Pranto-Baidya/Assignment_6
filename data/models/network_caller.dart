import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:untitled3/data/auth_controllers/authentication.dart';
import 'package:untitled3/data/services/network-response.dart';
import 'package:untitled3/main.dart';
import 'package:untitled3/ui/screens/sign-in_screen.dart';

class networkCaller {
  static Future<networkResponse> getRequest(String url) async {
    Uri uri = Uri.parse(url);
    Map<String,String> headers = {
      'token' : authentication.accessToken.toString()
    };
    final Response response = await get(uri,headers: headers);

    printRequest(url,null,headers);
    printResponse(url,response);

    try {
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        if (decodedData['status'] == 'success') {
          return networkResponse(
              statusCode: response.statusCode,
              isSuccess: true,
              responseData: decodedData
          );
        }
        return networkResponse(
            statusCode: response.statusCode,
            isSuccess: true,
            responseData: decodedData);
      }
      else if(response.statusCode==401){
        _moveToLogin();
        return networkResponse(
            statusCode: response.statusCode,
            isSuccess: false,
            errorMsg: 'Unauthenticated'
        );
      }
      else {
        return networkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      }
    } catch (e) {
      return networkResponse(
          statusCode: -1, isSuccess: false, errorMsg: e.toString());
    }
  }

  static Future<networkResponse> postRequest(
      {required String url, Map<String, dynamic>? body}) async {
    Uri uri = Uri.parse(url);

    Map<String,String> headers = {
      'Content-Type': 'application/json',
      'token' : authentication.accessToken.toString()
    };
    debugPrint(url);

    final Response response = await post(uri,
        headers: headers,
        body: jsonEncode(body)
    );
    printRequest(url, body, headers);
    printResponse(url,response);

    try {
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        if (decodedData["status"] == "fail") {
          return networkResponse(
              statusCode: response.statusCode,
              isSuccess: false,
              errorMsg: decodedData["data"]
          );
        }

        return networkResponse(
            statusCode: response.statusCode,
            isSuccess: true,
            responseData: decodedData
        );
      }

      else if(response.statusCode==401){
        _moveToLogin();
        return networkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          errorMsg: 'Unauthenticated'
        );
      }

      else {
        return networkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
        );
      }
    } catch (e) {
      return networkResponse(
          statusCode: -1,
          isSuccess: false,
          errorMsg: e.toString()
      );
    }
  }

  static void printRequest(String url , Map<String,dynamic>? body, Map<String,dynamic>? headers ) {

    debugPrint('Url : $url\nBody : ${body}\nHeaders : ${headers}');
  }

  static void printResponse(String url , Response response) {

    debugPrint('Url : $url\nStatus : ${response.statusCode}\nBody : ${response.body}');
  }

  static Future _moveToLogin()async{
    await authentication.clearUserData();
     Navigator.pushAndRemoveUntil(
        MyApp.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context)=>signInScreen()),
        (_)=>false
    );
  }
}
