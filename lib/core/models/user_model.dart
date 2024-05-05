import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  final String? email;
  bool? isVerified;

  UserModel({
    this.uid,
    this.email,
    this.isVerified,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    };
  }

  factory UserModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserModel(
      uid: doc.id,
      email: doc.data()!['email'],
      isVerified: doc.data()?['isVerified'],
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    bool? isVerified,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
