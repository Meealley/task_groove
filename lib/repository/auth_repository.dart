import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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

      // Get FCM Token
      String? fcmToken = await getFcmToken();

      // Create the UserModel object
      UserModel user = UserModel(
        userID: userCredential.user!.uid,
        name: name,
        email: email,
        profilePicsUrl: profileImageUrl,
        loginStreak: 1,
        points: 0,
        fcmToken: fcmToken,
      );

      // Save user to Firestore
      await firestore.collection('users').doc(auth.currentUser!.uid).set({
        'name': user.name,
        'email': user.email,
        'userID': user.userID,
        'profilePicsUrl': user.profilePicsUrl,
        'loginStreak': 1,
        'points': 0,
        'lastLogin': DateTime.now(),
        'fcmToken': fcmToken,
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

      // Get FCM Token
      String? fcmToken = await getFcmToken();

// Update Firestore with the FCM token
      await firestore.collection('users').doc(userCredential.user!.uid).update({
        'fcmToken': fcmToken, // Update FCM token on login
      });

      // Map the data to a UserModel
      UserModel user = UserModel(
        name: userDoc['name'],
        email: userDoc['email'],
        userID: userDoc['userID'],
        profilePicsUrl: userDoc['profilePicsUrl'],
        loginStreak: userDoc['loginStreak'],
        points: userDoc['points'],
        fcmToken: fcmToken,
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
// Check if user exists in Firestore
      var userDoc = await firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .get();

      if (userDoc.docs.isEmpty) {
        throw const CustomError(
          code: "UserNotFound",
          message: "No user found with this email address.",
        );
      }

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

// Track login streak
  Future<void> trackLogin() async {
    final uid = auth.currentUser?.uid;
    if (uid != null) {
      final userRef = firestore.collection('users').doc(uid);
      final userDoc = await userRef.get();
      final data = userDoc.data();

      final currentLogin = DateTime.now().toUtc(); // Ensure UTC timezone
      log("Start tracking login : $currentLogin");

      if (data != null) {
        final lastLogin = (data['lastLogin'] as Timestamp?)
            ?.toDate()
            .toUtc(); // Convert lastLogin to UTC
        log("Current Login: $currentLogin");
        log("Last Login: $lastLogin");

        try {
          if (lastLogin != null) {
            final differenceInHours =
                currentLogin.difference(lastLogin).inHours;
            log("Difference in hours: $differenceInHours");

            if (differenceInHours >= 24 && differenceInHours < 48) {
              // Continue streak if last login was between 24 and 48 hours ago
              log("Incrementing login streak...");
              await userRef.update({
                'loginStreak': FieldValue.increment(1),
                'lastLogin': currentLogin,
              });
            } else if (currentLogin.difference(lastLogin).inDays >= 1) {
              // Reset streak if last login was more than 1 day ago
              log("Resetting login streak...");
              await userRef.update({
                'loginStreak': 1,
                'lastLogin': currentLogin,
              });
            }
          } else {
            // Handle case where lastLogin is null
            log("Last login is null, setting initial streak...");
            await userRef.update({
              'loginStreak': 1,
              'lastLogin': currentLogin,
            });
          }
        } catch (e) {
          log('Error updating login streak: ${e.toString()}');
          throw CustomError(
            code: 'Login Streak Update Error',
            message: e.toString(),
          );
        }
      } else {
        // If user data doesn't exist, set initial streak and last login
        log("No user data found, setting initial login streak...");
        await userRef.set({
          'loginStreak': 1,
          'lastLogin': currentLogin,
        }, SetOptions(merge: true));
      }
    } else {
      log("User ID not found.");
    }
  }

// Award points for completing tasks
  Future<void> awardPoints(int points) async {
    final user = auth.currentUser?.uid;
    if (user != null) {
      final userRef = firestore.collection('users').doc(user);
      await userRef.update({
        'points': FieldValue.increment(points),
      });
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

  // Get the current user from FirebaseAuth and Firestore
  Future<UserModel?> getCurrentUser() async {
    try {
      // Get the currently signed-in user from FirebaseAuth
      User? firebaseUser = auth.currentUser;

      // Check if the user is logged in
      if (firebaseUser != null) {
        // Fetch the user data from Firestore using the user's UID
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(firebaseUser.uid).get();

        if (userDoc.exists) {
          // Map the Firestore data to a UserModel
          UserModel currentUser = UserModel(
            userID: userDoc['userID'],
            name: userDoc['name'],
            email: userDoc['email'],
            profilePicsUrl: userDoc['profilePicsUrl'],
            loginStreak: userDoc['loginStreak'],
            points: userDoc['points'],
          );
          return currentUser;
        } else {
          log('User document not found in Firestore');
          return null; // User data not found in Firestore
        }
      } else {
        log('No user is currently logged in');
        return null; // No user is logged in
      }
    } catch (e) {
      log('Error fetching current user: $e');
      throw const CustomError(
        code: "FetchUserError",
        message: "Failed to fetch the current user",
        plugin: "Firebase_Auth",
      );
    }
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      // await FirebaseAuth.instance.signOut();
      await auth.signOut();
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

// Function to retrieve FCM Token
  Future<String?> getFcmToken() async {
    String? token = await firebaseMessaging.getToken();
    if (token != null) {
      log("FCM Token: $token");
    } else {
      log("Failed to get FCM Token");
    }
    return token;
  }
}
