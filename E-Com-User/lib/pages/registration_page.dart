

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/models/user_model.dart';
import 'package:e_com_user/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../auth/firebase_auth.dart';
import 'launcher_page.dart';


class RegistrationPage extends StatefulWidget {
  static const String routeName = '/registration';
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscureText = true;
  final formKey = GlobalKey<FormState>();
  String errMsg = '';

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    phoneController.text = ModalRoute.of(context)!.settings.arguments as String;
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      //filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: 'Name',
                        prefixIcon: const Icon(Icons.person)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name must not be empty!';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    enabled: false,
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      //filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: 'Phone',
                        prefixIcon: const Icon(Icons.call)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone must not be empty!';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      //filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email must not be empty!';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    controller: passwordController,
                    obscureText: isObscureText,
                    decoration: InputDecoration(
                      //filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: 'password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(isObscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              isObscureText = !isObscureText;
                            });
                          },
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password must not be empty!';
                      }
                      if (value.length < 6) {
                        return 'Password min 6 character';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 25,),
                  Container(
                    width: double.maxFinite,
                    height: 40,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.blue, Colors.yellow]),
                      //color: Colors.lightBlue,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextButton(
                      onPressed: () {
                        authenticate();
                      },
                      child: const Text('REGISTER',
                        style: TextStyle(color: Colors.white,),),
                    ),
                  ),
                  const SizedBox(height:10,),
                  Text(errMsg, style: const TextStyle(color: Colors.redAccent),),
                  const SizedBox(height:30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void authenticate()  async{
    if(formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please Wait....', dismissOnTap: false);
      try {
        if(await AuthService.register(emailController.text, passwordController.text)){
          final userModel = UserModel(
              uid: AuthService.user!.uid,
              name: nameController.text,
              email: AuthService.user!.email!,
              mobile: phoneController.text,
              userCreationTime: Timestamp.fromDate(AuthService.user!.metadata.creationTime!),
          );
          if(!mounted) return;
          Provider.of<UserProvider>(context, listen: false)
              .addUser(userModel).then((value) {
            EasyLoading.dismiss();
            Navigator.pushNamedAndRemoveUntil(context, LauncherPage.routeName, (route) => false);
          });
        }
      }on FirebaseAuthException catch(e) {
        errMsg = e.message!;
        print('User already exists');
        EasyLoading.dismiss();
        Fluttertoast.showToast(
          msg: 'User already exists',
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,);
      }
    }
  }



}
