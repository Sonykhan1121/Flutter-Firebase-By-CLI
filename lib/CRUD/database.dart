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
  Future updateUserData(String fName , String lName ,String age, String id) async
  {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({"firstName":fName,"lastName":lName,"age":age});
  }
  Future DeleteUserData(String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .delete();

  }
}