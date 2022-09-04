import 'package:e_com_user/auth/firebase_auth.dart';
import 'package:e_com_user/pages/login_page.dart';
import 'package:e_com_user/pages/registration_page.dart';
import 'package:e_com_user/utils/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PhoneVerificationPage extends StatefulWidget {
  static const String routeName = '/phone_verification';
  const PhoneVerificationPage({Key? key}) : super(key: key);

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {

  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  bool isFirst = true;
  String vId = '';

  /*@override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Verification'),
      ),
      body: Center(
        child: AnimatedCrossFade(
          duration: const Duration(seconds: 3),
          firstChild: phoneVerificationSection(),
          secondChild: otpSection(),
          crossFadeState: isFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        ),
      ),
    );
  }

  Card phoneVerificationSection() {
    return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration:  InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                  labelText: 'Enter Mobile Number...',
                  filled: true,
                ),
              ),
              const SizedBox(height: 5,),
              ElevatedButton(
                  onPressed: () {
                    if(phoneController.text.isEmpty) {
                      showMessage(context, 'Invalid Phone Number');
                      return;
                    }
                    setState(() {
                      isFirst = false;
                    });
                    _verifyPhone();
                  },
                  child: const Text('SEND CODE'),
              ),
            ],
          ),
        ),
      );
  }

  Card otpSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(phoneController.text,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height:25,),
            PinCodeTextField(
              appContext: context,
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
              ),
              animationDuration: Duration(milliseconds: 300),
              backgroundColor: Colors.blue.shade50,
              enableActiveFill: true,
              controller: otpController,
              onChanged: (value) {
                if(value.length == 6) {
                  EasyLoading.show(status: 'Please Wait....', dismissOnTap: false);
                  sendOtp();
                }

              },
            ),
          ],
        ),
      ),
    );
  }

  void _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) {
        //await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          showMessage(context, 'The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        vId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void sendOtp() {
    PhoneAuthCredential credential = PhoneAuthProvider
        .credential(verificationId: vId, smsCode: otpController.text);
    FirebaseAuth.instance.signInWithCredential(credential)
        .then((credentialUser) {
          if(credentialUser != null) {
            EasyLoading.dismiss();
            AuthService.logout();
            Navigator.pushReplacementNamed(context, RegistrationPage.routeName,
                arguments: phoneController.text);
          }
          if(credentialUser == null) {
            EasyLoading.dismiss();
            Fluttertoast.showToast(
              msg: 'Invalid Code',
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,);
            Navigator.pop(context);
          }
    });
  }


}
