

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
import 'phone_verification_page.dart';


class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscureText = true;
  final formKey = GlobalKey<FormState>();
  String errMsg = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey,
      body: Container(
          /*decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bg-1.png'),
              fit: BoxFit.cover,
            ),
          ),*/
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30,),
                    Image.asset('images/male.png',width: 100, height: 100, fit: BoxFit.cover,),
                    const SizedBox(height: 20,),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.name,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            //
                          },
                          child: const Text(
                              'Forget Password?'
                          ),
                        ),
                      ],
                    ),
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
                        child: const Text('Login',
                          style: TextStyle(color: Colors.white,),),
                      ),
                    ),
                    const SizedBox(height:10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account? '),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, PhoneVerificationPage.routeName);
                          },
                          child: const Text('Signup',
                            style: TextStyle(color: Colors.blue,),),
                        ),
                      ],
                    ),
                    Text(errMsg, style: const TextStyle(color: Colors.redAccent),),
                    const SizedBox(height:10),
                    const Text('OR', style: TextStyle(fontSize: 18),),
                    const SizedBox(height:5),
                    Container(
                      width: double.maxFinite,
                      height: 40,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.yellow, Colors.pink, Colors.deepOrangeAccent]),
                        //color: Colors.lightBlue,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextButton(
                        onPressed: () {
                          AuthService.signInWithGoogle().then((credential) async {
                            if(credential.user != null) {
                              if(!await Provider.of<UserProvider>(context, listen: false)
                                  .doseUserExist(credential.user!.uid)) {
                                EasyLoading.show(status: 'Please Wait....',dismissOnTap: false);
                                final userModel = UserModel(
                                  uid: AuthService.user!.uid,
                                  name: credential.user!.displayName,
                                  email: AuthService.user!.email!,
                                  userCreationTime: Timestamp.fromDate(credential.user!.metadata.creationTime!),
                                );
                                await Provider.of<UserProvider>(context, listen: false).addUser(userModel);
                                EasyLoading.dismiss();
                              }
                              Navigator.pushReplacementNamed(context, LauncherPage.routeName);
                            }
                          });
                        },
                        child: const Text('SIGN IN WITH GOOGLE',
                          style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    const SizedBox(height:30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('©Next Digit',
                  style: TextStyle(
                    //fontWeight: FontWeight.w500,
                    //color: Colors.pink,
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void authenticate()  async{
    if(formKey.currentState!.validate()) {
      try {
        final status = await AuthService.login(emailController.text, passwordController.text);
        if(status) {
          if(!mounted) return;
          Navigator.pushReplacementNamed(context, LauncherPage.routeName);
        }
      }on FirebaseAuthException catch(e) {
        errMsg = e.message!;
        print('User Not Found!');
        Fluttertoast.showToast(
          msg: 'User Not Found!',
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,);
      }
    }
  }



}
