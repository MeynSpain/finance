import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/globals.dart';

class TagModel extends Equatable {
  String? uid;
  String name;
  String type;

  TagModel({this.uid, required this.name, required this.type});

  Map<String, dynamic> toMap() {
    return {
      Globals.uid: uid,
      Globals.name: name,
      Globals.type: type,
    };
  }

  factory TagModel.fromMap(Map<String, dynamic> mapData) {
    return TagModel(
      uid: mapData[Globals.uid],
      name: mapData[Globals.name],
      type: mapData[Globals.type],
    );
  }


  @override
  String toString() {
    return 'TagModel{uid: $uid, name: $name, type: $type}';
  }

  @override
  List<Object?> get props => [uid, name, type];
}
