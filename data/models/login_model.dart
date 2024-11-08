import 'package:untitled3/data/models/user_model.dart';

class LoginModel {
  String? status;
  userModel? data;
  String? token;

  LoginModel({this.status, this.data, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new userModel.fromJson(json['data']) : null;
    token = json['token'];
  }
}


