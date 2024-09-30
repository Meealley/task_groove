import 'package:task_groove/constants/constants.dart';

class ProfileRepository {
  Future<Map<String, dynamic>?> getUserProfile() async {
    final uid = auth.currentUser?.uid;
    if (uid != null) {
      final userDoc = await firestore.collection('users').doc(uid).get();
      return userDoc.data();
    }
    return null;
  }

  Future<void> trackLogin() async {}
}
