import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../data/models/user_model.dart';

abstract class AuthedRepository {
  Future<void> login(String email, String password);
  Future<UserCredential?> loginWithGoogle(String email);
  Future<void> resetPassword(String email);
  Future<void> signUp(UserModel userModel, String password);
  Stream<UserModel> getCurrentUser();
  Stream<int> getNumInvitations();
  Future<void> changeUserInformation(String type, String value);
  Future<void> updateUserPhoto(String userId, String base64Image);
  Future<void> logout();
  Future<String?> deleteAccount(BuildContext context);
}
