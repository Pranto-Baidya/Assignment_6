import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled3/data/models/network_caller.dart';
import 'package:untitled3/data/services/network-response.dart';
import 'package:untitled3/ui/screens/set-pass_screen.dart';
import 'package:untitled3/ui/screens/sign-in_screen.dart';
import 'package:untitled3/ui/utils/app_Colors.dart';
import 'package:untitled3/ui/utils/spinkit.dart';
import 'package:untitled3/ui/utils/toastMessage.dart';
import 'package:untitled3/ui/widgets/screen_background.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class pinVerificationScreen extends StatefulWidget {
  final String email;

  const pinVerificationScreen({super.key, required this.email});

  @override
  State<pinVerificationScreen> createState() => _pinVerificationScreenState();
}

class _pinVerificationScreenState extends State<pinVerificationScreen> {
  String _enteredOtp = '';
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: screenBackground(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 180),
                Text(
                  'Pin verification',
                  style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 15),
                Text(
                  'A 6-digit verification pin has been sent to your email address',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 24),
                _buildForgotPassForm(),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(height: 40),
                _buildRichText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRichText() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Already have an account?",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          children: [
            TextSpan(
              text: " Sign In",
              style: TextStyle(color: AppColors.themeColor),
              recognizer: TapGestureRecognizer()..onTap = _onTapSignInButton,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotPassForm() {
    return Column(
      children: [
        PinCodeTextField(
          length: 6,
          obscureText: false,
          keyboardType: TextInputType.number,
          animationType: AnimationType.fade,
          onChanged: (value) {
            _enteredOtp = value;
          },
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            activeFillColor: Colors.white,
            inactiveFillColor: Colors.white,
            selectedColor: Colors.green,
            selectedFillColor: Colors.white,
          ),
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          enableActiveFill: true,
          appContext: context,
        ),
        SizedBox(height: 15),
        ElevatedButton(
          onPressed:  _onTapVerifyButton,
          child:  !_isLoading? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Verify', style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(width: 10),
              Icon(Icons.arrow_circle_right_outlined, color: Colors.white),
            ],
          ):Center(child: spinKit.normalLoader(),),
        ),
      ],
    );
  }

  void _onTapVerifyButton() async {
    if (_enteredOtp.length != 6) {
      setState(() {
        _errorMessage = "Please enter a valid 6-digit OTP.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String url = 'http://35.73.30.144:2005/api/v1/RecoverVerifyOtp/${widget.email}/$_enteredOtp';

    final networkResponse response = await networkCaller.getRequest(url);

    setState(() {
      _isLoading = false;
    });

    if(response.isSuccess){
      SuccessToast('Success');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => setPassScreen(email: widget.email,otp:_enteredOtp,)));
    }
    else{
      ErrorToast('Wrong verification pin');
    }
  }

  void _onTapSignInButton() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => signInScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
      ),
    );
  }
}
