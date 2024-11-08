
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/data/auth_controllers/authentication.dart';
import 'package:untitled3/data/models/network_caller.dart';
import 'package:untitled3/data/services/network-response.dart';
import 'package:untitled3/data/utils/all_urls.dart';
import 'package:untitled3/ui/screens/sign-in_screen.dart';
import 'package:untitled3/ui/utils/controllers.dart';
import 'package:untitled3/ui/utils/app_Colors.dart';
import 'package:untitled3/ui/utils/spinkit.dart';
import 'package:untitled3/ui/utils/toastMessage.dart';
import 'package:untitled3/ui/widgets/screen_background.dart';

class setPassScreen extends StatefulWidget {
  final String email;
  final String otp;
  const setPassScreen({super.key, required this.email, required this.otp});

  @override
  State<setPassScreen> createState() => _setPassScreenState();
}

class _setPassScreenState extends State<setPassScreen> {

  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>() ;

  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

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
                  height: 180,
                ),
                Text(
                  'Set password',
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w500
                  )
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                    'Minimum length of password should be 8 characters with the combination of letters & numbers',
                    style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                         color: Colors.black54
                    )
                ),
                SizedBox(
                  height: 24,
                ),
                _buildSetPassForm(),
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

  Widget _buildSetPassForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [

          TextFormField(
            validator: (value){
              if(value!.isEmpty){
                return 'Please enter your new password';
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
            validator: (value){
              if(value!.isEmpty){
                return 'Please confirm your password';
              }
              if(value!=_passController.text){
                return 'Passwords do not match';
              }
              return null;
            },
            controller: _confirmPassController,
            cursorColor: Colors.green,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Confirm Password',
            ),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: _onTapConfirmButton,
            child: !_isLoading? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Confirm',
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
            ):Center(child: spinKit.normalLoader(),),
          ),
        ],
      ),
    );
  }

  Future<void> _resetPassword()async{
    setState(() {
      _isLoading = true;
    });

    Map<String,dynamic> data = {
      'email' : widget.email,
      'OTP' : widget.otp,
      'password' : _passController.text
    };

    final networkResponse response = await networkCaller.postRequest(
       url:Urls.resetPass,
      body: data
   );

    setState(() {
     _isLoading = false;
   });

    if(response.isSuccess){
     SuccessToast('Password has been reset successfully');
     Navigator.push(context, MaterialPageRoute(builder: (context)=>signInScreen()));
   }
   else{
     ErrorToast('Something went wrong');
   }
  }

  void _onTapConfirmButton() {
    if(_formKey.currentState!.validate()){
      _resetPassword();
    }
  }
  void _onTapSignInButton() {
    Navigator.pop(context);
  }
}
