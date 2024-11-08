import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:untitled3/data/models/network_caller.dart';
import 'package:untitled3/data/services/network-response.dart';

import 'package:untitled3/data/utils/all_urls.dart';
import 'package:untitled3/ui/utils/controllers.dart';
import 'package:untitled3/ui/utils/app_Colors.dart';
import 'package:untitled3/ui/utils/spinkit.dart';
import 'package:untitled3/ui/utils/toastMessage.dart';
import 'package:untitled3/ui/widgets/screen_background.dart';
import 'package:fluttertoast/fluttertoast.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>() ;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();


  bool _inProgress = false;

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
                SizedBox(
                  height: 100,
                ),
                Text(
                  'Join with us',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w500
                  )
                ),
                SizedBox(
                  height: 24,
                ),
                _buildSignUpForm(),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 8,
                ),
                _buildRichText()
              ],
            ),
          ),
        )
        )
    );
  }

  Widget _buildRichText() {
    return Center(
      child: RichText(
          text: TextSpan(
              text: "Already have an account?",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              children: [
            TextSpan(
                text: " Sign In",
                style: TextStyle(color: AppColors.themeColor),
                recognizer: TapGestureRecognizer()..onTap = _onTapSignInButton)
          ])),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value){

              String? nonCaseSensitive = value?.toLowerCase();

              if(nonCaseSensitive!.isEmpty) {
                return 'Please enter an email address';
              }
              if(!nonCaseSensitive.contains('@')){
                return 'Please enter a valid email address';
              }
              if(!nonCaseSensitive.contains('.com')){
                return 'Email address must end with ".com "';
              }

              return null;
            },
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.green,
            decoration: InputDecoration(
              hintText: 'Email',
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value){
              String? nonCaseSensitive = value?.toLowerCase();
              if(nonCaseSensitive!.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
            controller: _firstNameController ,
            keyboardType: TextInputType.text,
            cursorColor: Colors.green,
            decoration: InputDecoration(
              hintText: 'First name',
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value){
              String? nonCaseSensitive = value?.toLowerCase();

              if(nonCaseSensitive!.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
            controller: _lastNameController,
            keyboardType: TextInputType.text,
            cursorColor: Colors.green,
            decoration: InputDecoration(
              hintText: 'Last name',
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value){
              if(value!.isEmpty) {
                return 'Please enter your mobile number';
              }
              return null;
            },
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            cursorColor: Colors.green,
            decoration: InputDecoration(
              hintText: 'Mobile',
            ),
          ),
          SizedBox(
            height: 15,
          ),

          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value){
              if(value!.isEmpty) {
                return 'Please enter your password';
              }
              if(value.length<6){
                return 'Password must contain a minimum of 6 characters';
              }
              return null;
            },
            controller: _passController,
            cursorColor: Colors.green,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
            ),
          ),
          SizedBox(
            height: 15,
          ),

          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value){
              if(value!.isEmpty ) {
                return 'Enter password first';
              }
              if(value!= _passController.text){
                return 'Passwords do not match';
              }
              return null;
            },
            controller: _confirmPassController,
            cursorColor: Colors.green,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Confirm password',
            ),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: _onTapRegisterButton,
            child: !_inProgress?Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Register',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.arrow_circle_right_outlined,
                  color: Colors.white,
                )
              ],
            ) : Center(
              child: spinKit.normalLoader()
            ),
          ),
        ],
      ),
    );

  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _onTapRegisterButton() {
    if(_formKey.currentState!.validate()){
     signUp();
    }
  }

  Future<void> signUp()async{
    setState(() {
      _inProgress = true;
    });

    Map<String,dynamic> requestBody = {

        "email":_emailController.text.trim(),
        "firstName":_firstNameController.text.trim(),
        "lastName":_lastNameController.text.trim(),
        "mobile":_mobileController.text.trim(),
        "password":_passController.text

    };

  networkResponse response = await networkCaller.postRequest(
      url: Urls.registration,
      body: requestBody
      );
  setState(() {
    _inProgress = false;
  });

  if(response.isSuccess){
    SuccessToast('Registration successful');

    Navigator.pop(context);

  }
  else{
    ErrorToast('Something went wrong');
  }

  }


  void _onTapSignInButton() {
    Navigator.pop(context);
  }

}
