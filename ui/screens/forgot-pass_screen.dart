import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled3/data/models/network_caller.dart';
import 'package:untitled3/data/services/network-response.dart';
import 'package:untitled3/ui/screens/pin-verification_screen.dart';
import 'package:untitled3/ui/utils/app_Colors.dart';
import 'package:untitled3/ui/utils/page_transition.dart';
import 'package:untitled3/ui/utils/spinkit.dart';
import 'package:untitled3/ui/utils/toastMessage.dart';
import 'package:untitled3/ui/widgets/screen_background.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  bool inProgress = false;

  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                const SizedBox(height: 180),
                Text(
                  'Your email address',
                  style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 15),
                Text(
                  'A 6-digit verification pin will be sent to your email address',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                _buildForgotPassForm(),
                const SizedBox(height: 40),
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your email address';
              }
              return null;
            },
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.green,
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: _onTapSubmitButton,
            child: !inProgress? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.arrow_circle_right_outlined,
                  color: Colors.white,
                ),
              ],
            ) : Center(child: spinKit.normalLoader(),),
          ),
        ],
      ),
    );
  }

  Future<void> verifyEmail() async {
    setState(() {
      inProgress = true;
    });

    final String email = _emailController.text.trim();
    final String url = 'http://35.73.30.144:2005/api/v1/RecoverVerifyEmail/$email';

    final networkResponse response = await networkCaller.getRequest(url);

    setState(() {
      inProgress = false;
    });

    if(response.isSuccess){
      SuccessToast('Success');
      Navigator.push(context, MaterialPageRoute(builder: (context)=>pinVerificationScreen(email: email)));
    }
    else{
      ErrorToast('The email is not registered');
    }
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      verifyEmail();
    }
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }
}
