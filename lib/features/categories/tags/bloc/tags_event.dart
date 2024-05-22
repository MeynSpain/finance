part of 'tags_bloc.dart';

@immutable
abstract class TagsEvent {}

class TagsGetAllTagsEvent extends TagsEvent {
  final String userUid;

  TagsGetAllTagsEvent({required this.userUid});
}

class TagsAddTagEvent extends TagsEvent {
  final String userUid;
  final TagModel tagModel;

  TagsAddTagEvent({required this.userUid, required this.tagModel});
}

class TagsToggleTagEvent extends TagsEvent {
  final int index;

  TagsToggleTagEvent({required this.index});
}
