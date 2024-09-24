import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_groove/constants/constants.dart';
import 'package:task_groove/models/user_model.dart'; // Fix: Typo in 'user_moder'
// import 'package:task_groove/models/user_model.dart';
import 'package:task_groove/utils/custom_error.dart';

class AuthRepository {
  // Sign Up method
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required File profileImage,
  }) async {
    try {
      // Create the user with FirebaseAuth
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Upload profile image to Firebase Storage
      String profileImageUrl = await _uploadProfileImage(profileImage);

      // Create the UserModel object
      UserModel user = UserModel(
        userID: userCredential.user!.uid,
        name: name,
        email: email,
        profilePicsUrl: profileImageUrl,
      );

      // Save user to Firestore
      await firestore.collection('users').doc(auth.currentUser!.uid).set({
        'name': user.name,
        'email': user.email,
        'userID': user.userID,
        'profilePicsUrl': user.profilePicsUrl,
      });

      // Save user data to SharedPreferences
      await _saveUserToPrefs(user);

      return user;
    } catch (e) {
      log(e.toString());
      throw CustomError(
        code: "Exception",
        message: e.toString(),
        plugin: "Flutter_error",
      );
    }
  }

// Login User with Email and Password
  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
// Sign in the User with FirebaseAuth
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Retrieve user data from Firestore
      var userDoc = await firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw const CustomError(
          code: "UserNotFound",
          message: "User Not Found",
          // plugin: "Firebase_FireStore",
        );
      }

      // Map the data to a UserModel
      UserModel user = UserModel(
        name: userDoc['name'],
        email: userDoc['email'],
        userID: userDoc['userID'],
        profilePicsUrl: userDoc['profilePicsUrl'],
      );

      //Save user to shared preferences
      await _saveUserToPrefs(user);

      return user;
    } catch (e) {
      log('Error logging in user $e');
      throw CustomError(
        code: "LoginError",
        message: e.toString(),
        plugin: "Firebase_Auth",
      );
    }
  }

// Forgot password method
  Future<void> forgotPassword({required String email}) async {
    try {
      // Send password reset email
      await auth.sendPasswordResetEmail(email: email);
      log("Password reset email sent to $email");
    } catch (e) {
      log("Error in forgotPassword: $e");
      throw CustomError(
        code: "ForgotPasswordError",
        message: e.toString(),
        plugin: "Firebase_Auth",
      );
    }
  }

  // Upload profile image to Firebase Storage
  Future<String> _uploadProfileImage(File profileImage) async {
    try {
      // Create a unique file name for the image
      String fileName = "${auth.currentUser!.uid}/profile_image_${uuid.v4()}";

      // Reference to Firebase Storage
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

      // Upload the file
      await storageRef.putFile(profileImage);

      // Get the download URL
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      log("Error uploading profile image: $e");
      throw const CustomError(
        code: "StorageError",
        message: "Failed to upload profile image",
        plugin: "Firebase_Storage",
      );
    }
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserToPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_uid', user.userID);
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_profilePicsUrl', user.profilePicsUrl);
  }

  // Clear user data from SharedPreferences
  Future<void> _clearUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_uid');
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('user_profilePicsUrl');
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    User? firebaseUser = auth.currentUser;
    if (firebaseUser != null) {
      return UserModel.fromFirebaseUser(firebaseUser);
    }
    return null;
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await _clearUserFromPrefs(); // Clear stored user data
    } catch (e) {
      log("Error signing out: $e");
      throw const CustomError(
        code: "SignOutError",
        message: "Failed to sign out",
        plugin: "Firebase_Auth",
      );
    }
  }
}
