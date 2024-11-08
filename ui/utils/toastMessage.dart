import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void SuccessToast(msg){

    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16
    );
  }
  void ErrorToast(msg){
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16
    );
  }
