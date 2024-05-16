import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/globals.dart';

class TagModel extends Equatable {
  String? uid;
  String name;

  TagModel({this.uid, required this.name});

  Map<String, dynamic> toMap() {
    return {
      Globals.uid: uid,
      Globals.name: name,
    };
  }

  factory TagModel.fromMap(Map<String, dynamic> mapData) {
    return TagModel(
      uid: mapData[Globals.uid],
      name: mapData[Globals.name],
    );
  }


  @override
  String toString() {
    return 'TagModel{uid: $uid, name: $name}';
  }

  @override
  List<Object?> get props => [uid, name];
}
