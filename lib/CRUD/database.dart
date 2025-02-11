import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc()
        .set(userInfoMap);
  }
  Future<QuerySnapshot> getthisUserInfo(String name) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('firstName', isEqualTo: name)
        .get();

  }
}