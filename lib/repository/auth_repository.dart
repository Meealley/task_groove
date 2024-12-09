import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_groove/constants/constants.dart';
import 'package:task_groove/models/user_model.dart'; // Fix: Typo in 'user_moder'
// import 'package:task_groove/models/user_model.dart';
import 'package:task_groove/utils/custom_error.dart';

class AuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

// Function to create a welcome notification
  Future<void> _createWelcomeNotification(String userId) async {
    await firestore.collection('notifications').add({
      'userId': userId,
      'title': 'Welcome!',
      'message': 'Welcome to Task Groove! We’re glad to have you here.',
      // 'imageUrl': 'assets/images/welcome_notification.png',
      'isOpened': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Sign Up method
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    File? profileImage, // Make profileImage optional
  }) async {
    try {
      // Create the user with FirebaseAuth
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Initialize profile image URL
      String profileImageUrl = '';

      // Check if profileImage is provided and upload if available
      if (profileImage != null) {
        profileImageUrl = await _uploadProfileImage(profileImage);
      }

      // Get FCM Token
      String? fcmToken = await getFcmToken();

      // Create the UserModel object
      UserModel user = UserModel(
        userID: userCredential.user!.uid,
        name: name,
        email: email,
        profilePicsUrl: profileImageUrl, // Use the uploaded URL or default
        loginStreak: 1,
        points: 0,
        fcmToken: fcmToken,
        lastUsage: DateTime.now(),
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

      await _createWelcomeNotification(user.userID);

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

// Google Sign-In method
  Future<UserModel> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw const CustomError(
          code: "GoogleSignInError",
          message: "Google Sign-In was canceled by the user.",
        );
      }

      // Get the authentication details from the Google account
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential using the Google token
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      // Retrieve user data from Firestore (or create new user if not found)
      var userDoc = await firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .get();

      // Check if user exists
      UserModel user;
      if (!userDoc.exists) {
        // If the user doesn't exist, create a new user record
        user = UserModel(
          userID: userCredential.user!.uid,
          name: googleUser.displayName ?? 'No Name',
          email: googleUser.email,
          profilePicsUrl: googleUser.photoUrl ?? '',
          loginStreak: 1,
          points: 0,
          fcmToken: await getFcmToken(),
          lastUsage: DateTime.now(),
        );

        // Save the user to Firestore
        await firestore.collection('users').doc(user.userID).set({
          'name': user.name,
          'email': user.email,
          'userID': user.userID,
          'profilePicsUrl': user.profilePicsUrl,
          'loginStreak': 1,
          'points': 0,
          'fcmToken': user.fcmToken,
          'lastLogin': DateTime.now(),
        });

        // Optionally, send a welcome notification
        await _createWelcomeNotification(user.userID);
      } else {
        // If the user exists, get the existing data
        user = UserModel(
          userID: userDoc['userID'],
          name: userDoc['name'],
          email: userDoc['email'],
          profilePicsUrl: userDoc['profilePicsUrl'],
          loginStreak: userDoc['loginStreak'],
          points: userDoc['points'],
          fcmToken: await getFcmToken(),
          lastUsage: DateTime.now(),
        );
      }

      // Save the user data to SharedPreferences
      await _saveUserToPrefs(user);

      return user;
    } catch (e) {
      log('Error signing in with Google: $e');
      throw CustomError(
        code: "GoogleSignInError",
        message: e.toString(),
        plugin: "Firebase_Auth",
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
        lastUsage: DateTime.now(),
      );

      // await trackDailyAppUsage();

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

  // Function to update user profile image, name, and email
  // Future<void> updateUserProfile({
  //   String? newName,
  //   String? newEmail,
  //   File? newProfileImage,
  // }) async {
  //   try {
  //     final user = auth.currentUser;
  //     if (user == null) {
  //       throw const CustomError(
  //         code: 'NoUser',
  //         message: 'No authenticated user found',
  //         plugin: 'Firebase_Auth',
  //       );
  //     }

  //     // Update email if provided
  //     if (newEmail != null && newEmail.isNotEmpty) {
  //       await user.updateEmail(newEmail);
  //     }

  //     // Upload new profile image if provided
  //     String? profileImageUrl;
  //     if (newProfileImage != null) {
  //       profileImageUrl = await _uploadProfileImage(newProfileImage);
  //     }

  //     // Prepare the updates map for Firestore
  //     Map<String, dynamic> updates = {};
  //     if (newName != null && newName.isNotEmpty) {
  //       updates['name'] = newName;
  //     }
  //     if (newEmail != null && newEmail.isNotEmpty) {
  //       updates['email'] = newEmail;
  //     }
  //     if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
  //       updates['profilePicsUrl'] = profileImageUrl;
  //     }

  //     if (updates.isNotEmpty) {
  //       // Update user data in Firestore
  //       await firestore.collection('users').doc(user.uid).update(updates);

  //       // Update SharedPreferences with the new data
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       if (newName != null) {
  //         await prefs.setString('user_name', newName);
  //       }
  //       if (newEmail != null) {
  //         await prefs.setString('user_email', newEmail);
  //       }
  //       if (profileImageUrl != null) {
  //         await prefs.setString('user_profilePicsUrl', profileImageUrl);
  //       }
  //     }
  //   } catch (e) {
  //     log('Error updating profile: $e');
  //     throw CustomError(
  //       code: "ProfileUpdateError",
  //       message: "Failed to update profile: $e",
  //       plugin: "Firebase_Firestore",
  //     );
  //   }
  // }

// In auth_repository.dart
  Future<void> updateUserProfile({
    required String userId,
    required String name,
    required String email,
    required String? profileImageUrl,
  }) async {
    try {
      await firestore.collection('users').doc(userId).update({
        'name': name,
        'email': email,
        if (profileImageUrl != null) 'profilePicsUrl': profileImageUrl,
      });
    } catch (e) {
      log('Error updating user profile: $e');
      throw CustomError(
        code: 'UpdateProfileError',
        message: e.toString(),
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

// Track App usage
  // Future<void> trackDailyAppUsage() async {
  //   final uid = auth.currentUser?.uid;
  //   if (uid != null) {
  //     final userRef = firestore.collection("users").doc(uid);
  //     final userDoc = await userRef.get();
  //     final data = userDoc.data();

  //     final currentUsage = DateTime.now().toUtc();
  //     log("Start tracking App usage: $currentUsage");

  //     if (data != null) {
  //       final lastUsage = (data['lastUsage'] as Timestamp?)?.toDate().toUtc();

  //       log("Current App usage : $currentUsage");
  //       log('Last App usage: $lastUsage');

  //       try {
  //         if (lastUsage != null) {
  //           // Check if more than 24 hours have passed since last usage last usage

  //           final differenceInHours =
  //               currentUsage.difference(lastUsage).inHours;
  //           log("Difference in hours: $differenceInHours");

  //           if (differenceInHours >= 24) {
  //             // Increment if streak is more than 24 hours
  //             log("Incrementing App usage streak...");
  //             await userRef.update({
  //               'loginStreak': FieldValue.increment(1),
  //               'lastUsage': currentUsage,
  //             });

  //             // Update SharedPreferences with the new streak value
  //             final prefs = await SharedPreferences.getInstance();
  //             int currentStreak = data['loginStreak'] + 1; // Incremented streak
  //             await prefs.setInt('user_loginStreak', currentStreak);
  //           } else {
  //             // If less than 24 hours has passed, just update the lastUsage timestamp
  //             log("Less than 24 hours since last usage, only updating the timestamp....");
  //             await userRef.update({
  //               'lastUsage': currentUsage,
  //             });
  //           }
  //         } else {
  //           // Handle case where lastUsage is null (first time using app)
  //           log("Last app usage is null, setting initial streak...");
  //           await userRef.update({
  //             'loginStreak': 1,
  //             'lastUsage': currentUsage,
  //           });

  //           // Update SharedPreferences with the initial streak value
  //           final prefs = await SharedPreferences.getInstance();
  //           await prefs.setInt('user_loginStreak', 1);
  //         }
  //       } catch (e) {
  //         log('Error updating app usage streak: ${e.toString()}');
  //         throw CustomError(
  //           code: 'App Usage Streak Update Error',
  //           message: e.toString(),
  //         );
  //       }
  //     } else {
  //       // If user data doesn't exist, set initial streak and last usage
  //       log("No user data found, setting initial app usage streak...");
  //       await userRef.set({
  //         'loginStreak': 1,
  //         'lastUsage': currentUsage,
  //       }, SetOptions(merge: true));

  //       // Update SharedPreferences with the initial streak value
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setInt('user_loginStreak', 1);
  //     }
  //   } else {
  //     log("User ID not found");
  //   }
  // }

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
    await prefs.setInt('user_points', user.points);
    await prefs.setInt('user_loginStreak', user.loginStreak);

    // Save lastUsage as a string (ISO 8601 format)
    if (user.lastUsage != null) {
      await prefs.setString('last_usage', user.lastUsage!.toIso8601String());
    }
  }

// Clear user data from SharedPreferences
  Future<void> _clearUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_uid');
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('user_profilePicsUrl');
    await prefs.remove('user_points');
    await prefs.remove('user_loginStreak');

    // Remove lastUsage as well
    await prefs.remove('last_usage');
  }

  // Get the current user from FirebaseAuth and Firestore
  Future<UserModel?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_uid');

      if (userId != null) {
        // Fetch from SharedPreferences
        String name = prefs.getString('user_name') ?? '';
        String email = prefs.getString('user_email') ?? '';
        String profilePic = prefs.getString('user_profilePicsUrl') ?? '';
        int points = prefs.getInt('user_points') ?? 0;
        int loginStreak = prefs.getInt('user_loginStreak') ?? 0;
        String? lastUsageString = prefs.getString("last_usage");

        // Parse lastUsage from stored string
        DateTime? lastUsage =
            lastUsageString != null ? DateTime.parse(lastUsageString) : null;

        UserModel currentUser = UserModel(
          userID: userId,
          name: name,
          email: email,
          profilePicsUrl: profilePic,
          loginStreak: loginStreak,
          points: points,
          lastUsage: lastUsage,
          // Other fields, you can default to 0 or fetch from Firestore if needed
        );

        log("Fetched user from SharedPreferences: $currentUser");
        return currentUser;
      } else {
        // If no data in SharedPreferences, fallback to Firestore
        User? firebaseUser = auth.currentUser;
        if (firebaseUser != null) {
          DocumentSnapshot userDoc =
              await firestore.collection('users').doc(firebaseUser.uid).get();
          if (userDoc.exists) {
// Extract lastUsage from Firestore document
            Timestamp? lastUsageTimestamp = userDoc['lastUsage'] as Timestamp?;
            DateTime? lastUsage = lastUsageTimestamp?.toDate();

            UserModel currentUser = UserModel(
              userID: userDoc['userID'],
              name: userDoc['name'],
              email: userDoc['email'],
              profilePicsUrl: userDoc['profilePicsUrl'],
              loginStreak: userDoc['loginStreak'],
              points: userDoc['points'],
              lastUsage: lastUsage,
            );
            return currentUser;
          }
        }
      }
    } catch (e) {
      log('Error fetching current user: $e');
      throw const CustomError(
        code: "FetchUserError",
        message: "Failed to fetch the current user",
        plugin: "Firebase_Auth",
      );
    }
    return null;
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
