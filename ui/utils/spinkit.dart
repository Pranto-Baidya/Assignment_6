import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class spinKit{

  static  Widget mainLoader(){
    return SpinKitThreeBounce(
      color: Colors.green,
      size: 30,
    );
  }
  static Widget normalLoader(){
     return  SpinKitThreeBounce(
      color: Colors.white,
      size: 25,
    );
  }

  static Widget taskLoader(){
    return  SpinKitThreeBounce(
      color: Colors.green,
      size: 25,
    );
  }
}