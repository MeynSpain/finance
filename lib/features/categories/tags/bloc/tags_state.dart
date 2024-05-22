part of 'tags_bloc.dart';

class TagsState extends Equatable {
  final TagsStatus status;
  final List<TagModel> listTags;
  final List<bool> listSelectedTags;

  TagsState._({
    required this.status,
    required this.listTags,
    required this.listSelectedTags,
  });

  factory TagsState.initial() {
    return TagsState._(
      status: TagsStatus.initial,
      listTags: [],
      listSelectedTags: [],
    );
  }

  TagsState copyWith({
    TagsStatus? status,
    List<TagModel>? listTags,
    List<bool>? listSelectedTags,
  }) {
    return TagsState._(
      status: status ?? this.status,
      listTags: listTags ?? this.listTags,
      listSelectedTags: listSelectedTags ?? this.listSelectedTags,
    );
  }

  @override
  List<Object?> get props => [status, listTags, listSelectedTags];
}
