

import 'package:e_com_admin/db/db_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? get user => _auth.currentUser;

  //Login
  static Future<bool> login(String email, String password) async{
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return DbHelper.isAdmin(credential.user!.uid);
  }


  //LogOut
  static Future<void> logout() => _auth.signOut();




}