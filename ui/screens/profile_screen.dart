import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitled3/data/auth_controllers/authentication.dart';
import 'package:untitled3/data/models/network_caller.dart';
import 'package:untitled3/data/models/user_model.dart';
import 'package:untitled3/data/services/network-response.dart';
import 'package:untitled3/data/utils/all_urls.dart';
import 'package:untitled3/ui/utils/controllers.dart';
import 'package:untitled3/ui/utils/spinkit.dart';
import 'package:untitled3/ui/utils/toastMessage.dart';
import 'package:untitled3/ui/widgets/TM_Appbar.dart';
import 'package:untitled3/ui/widgets/screen_background.dart';
import 'package:image_picker/image_picker.dart';

class profileScreen extends StatefulWidget {
  const profileScreen({super.key});

  @override
  State<profileScreen> createState() => _profileScreenState();
}




class _profileScreenState extends State<profileScreen> {


  @override
  void initState() {
    super.initState();
    _setUserData();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>() ;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  XFile? selectedImage;

  bool updateInProgress = false;

  @override
  Widget build(BuildContext context) {

    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: TM_AppBar(
        isProfileScreenOpen: true,
      ),
        resizeToAvoidBottomInset: false,
        body: screenBackground(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                          'Update profile',
                          style: textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w500
                          )
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      _buildPhotoPicker(),
                      SizedBox(
                        height: 15,
                      ),
                      _buildSignUpForm(),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 8,
                      ),

                    ],
                  ),
                ),
              ),
            )
        )
    );
  }

  Widget _buildPhotoPicker() {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                )
              ),
              child: Center(
                  child: Text('Photo',style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                  ),
                  )
              ),
            ),
            SizedBox(width: 15,),
            Text(_getSelectedPhotoTitle(),style: TextStyle(color: Colors.black45),)
          ],
        ),
      ),
    );
  }

  String _getSelectedPhotoTitle(){
    if(selectedImage!=null){
      return selectedImage!.name;
    }
    return 'Select photo';
  }

  Future<void> _pickImage()async{
    ImagePicker _imagePicker = ImagePicker();
    XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);

    if(pickedImage!=null){
      selectedImage = pickedImage;
      setState(() {

      });
    }
  }



  Widget _buildSignUpForm() {
    return Column(
      children: [
        TextFormField(
          enabled: false,
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
          validator: (value){
            if(value!.isEmpty){
              return 'Please type your first name';
            }
            return null;
          },
         controller: _firstNameController,
          keyboardType: TextInputType.text,
          cursorColor: Colors.green,
          decoration: InputDecoration(
            hintText: 'First Name',
          ),
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          validator: (value){
            if(value!.isEmpty){
              return 'Please type your last name';
            }
            return null;
          },
         controller: _lastNameController,
          keyboardType: TextInputType.text,
          cursorColor: Colors.green,
          decoration: InputDecoration(
            hintText: 'Last Name',
          ),
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          validator: (value){
            if(value!.isEmpty){
              return 'Please type your new mobile number';
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
        ElevatedButton(
          onPressed: _onTapUpdateButton,
          child: !updateInProgress? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Update',
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
        )
      ],
    );
  }

  Future<void> _updateProfile()async{
    updateInProgress = true;
    setState(() {

    });

    Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "mobile": _mobileController.text.trim(),

    };

    if(_passController.text.isNotEmpty){
      requestBody['password'] = _passController.text;
    }
    if(selectedImage!=null){
      List<int> imageBytes = await selectedImage!.readAsBytes();
      String convertedImage = base64Encode(imageBytes);
      requestBody['photo'] = convertedImage;
    }

    final networkResponse response = await networkCaller.postRequest(
        url: Urls.updateProfile,
        body: requestBody
    );
    updateInProgress = false;
    setState(() {

    });
    if(response.isSuccess){
      userModel model = userModel.fromJson(requestBody);
      authentication.saveUserData(model);
      SuccessToast('Profile has been updated successfully');
    }
    else{
      ErrorToast('An error occurred');
    }
  }

  void _setUserData(){
    _emailController.text = authentication.userData?.email ?? '';
    _firstNameController.text = authentication.userData?.firstName ?? '';
    _lastNameController.text = authentication.userData?.lastName ?? '';
    _mobileController.text = authentication.userData?.mobile ?? '';
  }

  void _onTapUpdateButton() {
    if(_formKey.currentState!.validate()){
     _updateProfile();
    }
  }
}
