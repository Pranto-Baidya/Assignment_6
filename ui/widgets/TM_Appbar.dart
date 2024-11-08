import 'dart:async';

import 'package:flutter/material.dart';
import 'package:untitled3/data/auth_controllers/authentication.dart';
import 'package:untitled3/ui/screens/add-new-task-screen.dart';
import 'package:untitled3/ui/screens/new-task-screen.dart';

import 'package:untitled3/ui/screens/profile_screen.dart';
import 'package:untitled3/ui/screens/sign-in_screen.dart';
import 'package:untitled3/ui/utils/app_Colors.dart';
import 'package:untitled3/ui/utils/spinkit.dart';
import 'package:untitled3/ui/utils/toastMessage.dart';

class TM_AppBar extends StatefulWidget implements PreferredSizeWidget {
  const TM_AppBar({
    super.key,
    this.isProfileScreenOpen = false,

  });

  final bool isProfileScreenOpen;


  @override
  _TM_AppBarState createState() => _TM_AppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _TM_AppBarState extends State<TM_AppBar> {
  bool _isLoggingOut = false;

  alert(context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Wait!',style: TextStyle(color: Colors.red,fontSize: 25,fontWeight: FontWeight.w600),),
            content: Text('Are you sure you want to log out?',style: TextStyle(color: Colors.black,fontSize: 16,),),
            actions: [
              TextButton(
                  onPressed: ()async{
                    setState(() {
                      _isLoggingOut = true;
                    });

                    await Future.delayed(Duration(seconds: 2));
                    await authentication.clearUserData();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => signInScreen()),
                          (_) => false,
                    );
                    SuccessToast('Successfully logged out');

                    setState(() {
                      _isLoggingOut = false;
                    });
                  },
                  child: Text('Yes',style: TextStyle(color: Colors.black),)
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('No',style: TextStyle(color: Colors.black),)
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isProfileScreenOpen) {
          return;
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => profileScreen()));
      },
      child: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: 40,
        backgroundColor: AppColors.themeColor,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFFAF6F8),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authentication.userData?.fullName ?? 'Guest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    authentication.userData?.email ?? 'No email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.refresh, color: Colors.white),
            ),
            IconButton(
              onPressed: () async {
                alert(context);
              },
              icon: _isLoggingOut
                  ? spinKit.normalLoader()
                  : Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.green, Colors.green]),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
