import 'package:chatting_app/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repositories/authed_repository.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/pages/introduction/introduction.dart';
import '../models/user_model.dart';

class AuthedRepositoryImpl implements AuthedRepository {
  final FirebaseAuth? firebaseAuth;
  final GoogleSignIn? googleSignIn;
  AuthedRepositoryImpl({this.firebaseAuth, this.googleSignIn});
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Future<void> login(String email, String password) async {
    await firebaseAuth?.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'isOnline': true});
  }

  @override
  Future<UserCredential?> loginWithGoogle(String email) async {
    final googleUser = await googleSignIn?.signIn();
    if (googleUser == null) return null;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await firebaseAuth?.signInWithCredential(credential);
    final user = userCredential?.user;
    if (user == null) return null;

    // Check if user already exists in Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      String name = user.displayName!;
      UserModel newUser = UserModel(
        fullName: name,
        email: user.email!,
        isOnline: true,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set(newUser.toJson(newUser));
    } else {
      await FirebaseFirestore.instance.collection("users").doc(user.uid).update(
        {'isOnline': true},
      );
    }
    return userCredential;
  }

  @override
  Future<void> resetPassword(String email) async {
    await firebaseAuth?.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signUp(UserModel userModel, String password) async {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: userModel.email,
          password: password,
        );
    final saveUser = userCredential.user;
    final newUser = userModel.toJson(userModel);

    if (saveUser != null) {
      users.doc(saveUser.uid).set(newUser);
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    }
  }

  @override
  Stream<UserModel> getCurrentUser() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return const Stream.empty();
    final userDocStream = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .snapshots();

    final friendsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('friends')
        .snapshots();

    return Rx.combineLatest2<
      DocumentSnapshot<Map<String, dynamic>>,
      QuerySnapshot<Map<String, dynamic>>,
      UserModel
    >(userDocStream, friendsStream, (userSnap, friendsSnap) {
      final data = userSnap.data();
      final friendsCount = friendsSnap.size;

      return UserModel.fromJson(
        data!,
        userSnap.id,
        null,
        friendsCount: friendsCount,
      );
    });
  }

  @override
  Stream<int> getNumInvitations() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('receiveRequests')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  @override
  Future<void> changeUserInformation(String type, String value) async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(currentUser).update({
      type: value,
    });
  }

  @override
  Future<void> updateUserPhoto(String userId, String base64Image) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'photoUrl': base64Image,
    });
  }

  @override
  Future<void> logout() async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final currentUser = auth.currentUser;

    await firestore.collection('users').doc(currentUser?.uid).update({
      'isOnline': false,
      'lastSeen': Timestamp.now(),
    });
    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.disconnect();
    }
    await auth.signOut();
  }

  @override
  Future<String?> deleteAccount(BuildContext context) async {
    final authController = AuthController();
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user == null) return null;
    final providerId = user.providerData.isNotEmpty
        ? user.providerData.last.providerId
        : '';
    String? password;
    if (providerId == 'password') {
      Navigator.of(context).pop();
      password = await askPasswordDialog(context, authController);
      if (password == null || password.isEmpty) return null;
    }
    try {
      if (providerId == 'google.com') {
        final googleSignIn = GoogleSignIn();
        final googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
          throw FirebaseAuthException(
            code: 'cancelled',
            message: 'User cancelled Google sign-in.',
          );
        }
        if (googleUser.email != user.email) {
          throw FirebaseAuthException(
            code: 'user-mismatch',
            message: 'You selected a different Google account.',
          );
        }
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await user.reauthenticateWithCredential(credential);
      }
      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
            'email': '',
            'isDeleted': true,
            'isOnline': false,
            'lastSeen': Timestamp.now(),
            'photoUrl': "",
          });

      // Disconnect Google if needed
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.disconnect();
      }
      // Delete account
      await user.delete();
      await auth.signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Introduction()),
        (Route<dynamic> route) => false,
      );

      authController.isLoading.value = false;
      return AppLocalizations.of(context)!.successDeleteAccount;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'network-request-failed':
          return AppLocalizations.of(context)!.pleaseCheckYourNet;
        case 'user-mismatch':
          return "You selected a different Google account.";
        case 'cancelled':
          return "Google sign-in cancelled.";
        default:
          return AppLocalizations.of(context)!.pleaseTryAgain;
      }
    }
  }

  Future<String?> askPasswordDialog(
    BuildContext context,
    AuthController authController,
  ) async {
    final controller = TextEditingController();
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmPassword),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.password,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: authController.isLoading,
              builder: (context, isLoading, _) {
                return ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final password = controller.text;
                          if (password.isEmpty) return;
                          try {
                            authController.isLoading.value = true;
                            final user = FirebaseAuth.instance.currentUser;
                            final credential = EmailAuthProvider.credential(
                              email: user!.email!,
                              password: password,
                            );
                            await user.reauthenticateWithCredential(credential);
                            Navigator.pop(context, password);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'invalid-credential') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.incorrectPassword,
                                  ),
                                ),
                              );
                            } else {
                              if (e.code == 'network-request-failed') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.pleaseCheckYourNet,
                                    ),
                                  ),
                                );
                              }
                            }
                          } finally {
                            authController.isLoading.value = false;
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(AppLocalizations.of(context)!.ok),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
