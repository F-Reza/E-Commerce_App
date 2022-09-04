
import 'package:e_com_admin/auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'launcher_page.dart';


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
      //backgroundColor: Colors.white,
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bg-1.png'),
              fit: BoxFit.cover,
            ),
          ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const Text('Admin Panel',
                      style: TextStyle(fontSize: 26,fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    const SizedBox(height: 30,),
                    Image.asset('images/admin.png',width: 150, height: 150, fit: BoxFit.cover,),
                    const SizedBox(height: 50,),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          //filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Email',
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
                      //height: 50,
                      //color: Colors.blue,
                      decoration: const BoxDecoration(
                        //gradient: LinearGradient(colors: [Colors.blue, Colors.yellow]),
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextButton(
                        onPressed: () {
                          //isLogin = true;
                          authenticate();
                        },
                        child: const Text('Login',
                          style: TextStyle(color: Colors.white,fontSize: 22),),
                      ),
                    ),
                    Text(errMsg,style: const TextStyle(color: Colors.redAccent),),
                    const SizedBox(height:20,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Card(
        color: Colors.lightBlue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('©Next Digit',
                  style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
              ),
            ],
          ),
        ),
      )
    );
  }

  void authenticate()  async{
    if(formKey.currentState!.validate()) {
      try {
        final status = await AuthService.login(emailController.text, passwordController.text);
        if(status) {
          if(!mounted) return;
          Navigator.pushReplacementNamed(context, LauncherPage.routeName);
        } else {
          await AuthService.logout();
          setState((){
            errMsg = 'This email dose not belong to an Admin account!';
          });
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
