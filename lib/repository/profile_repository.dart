// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:task_groove/constants/constants.dart';
// import 'package:task_groove/models/user_model.dart';
// import 'package:task_groove/repository/auth_repository.dart';

// class ProfileRepository {
//   final AuthRepository authRepository;

//   ProfileRepository(this.authRepository);

//   // Get the current logged-in user's profile
//   UserModel? get currentUserProfile {
//     return authRepository.currentUser;
//   }

//   // Get the user's name from the current profile

//   // Update last login date and track login streak
//   Future<void> trackLogin() async {
//     final uid = auth.currentUser?.uid;;
//     if (uid != null) {
//       final userRef = firestore.collection('users').doc(uid);

//       final userDoc = await userRef.get();
//       final data = userDoc.data();

//       final currentLogin = DateTime.now(); // Define currentLogin here

//       if (data != null) {
//         final lastLogin = (data['lastLogin'] as Timestamp?)?.toDate();

//         if (lastLogin != null &&
//             currentLogin.difference(lastLogin).inDays == 1) {
//           // Increment streak if the login is consecutive
//           await userRef.update({
//             'loginStreak': FieldValue.increment(1),
//             'lastLogin': currentLogin,
//           });
//         } else if (lastLogin == null ||
//             currentLogin.difference(lastLogin).inDays > 1) {
//           // Reset streak if not consecutive
//           await userRef.update({
//             'loginStreak': 1,
//             'lastLogin': currentLogin,
//           });
//         }
//       } else {
//         // Initialize login streak if it doesn't exist
//         await userRef.set({
//           'loginStreak': 1,
//           'lastLogin': currentLogin, // Use currentLogin here
//         }, SetOptions(merge: true));
//       }
//     }
//   }

//   // Award points for completing tasks
//   Future<void> awardPoints(int points) async {
//     final user = currentUserProfile;
//     if (user != null) {
//       final userRef = firestore.collection('users').doc(user.userID);
//       await userRef.update({
//         'points': FieldValue.increment(points),
//       });
//     }
//   }
// }
