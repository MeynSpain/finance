import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/status/tags_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/tag_model.dart';
import 'package:finance/core/services/database_service.dart';
import 'package:meta/meta.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'tags_event.dart';

part 'tags_state.dart';

class TagsBloc extends Bloc<TagsEvent, TagsState> {
  final DatabaseService databaseService = DatabaseService();

  TagsBloc() : super(TagsState.initial()) {
    on<TagsGetAllTagsEvent>(_getAllTags);
    on<TagsAddTagEvent>(_addTag);
    on<TagsToggleTagEvent>(_toggleTag);
  }

  Future<void> _getAllTags(
      TagsGetAllTagsEvent event, Emitter<TagsState> emit) async {
    emit(state.copyWith(
      status: TagsStatus.gettingAllTags,
    ));

    try {
      List<TagModel> tags = await databaseService.getTags(event.userUid);

      List<bool> selectedTags = List.filled(tags.length, false);

      emit(state.copyWith(
        status: TagsStatus.allTagsReceived,
        listTags: tags,
        listSelectedTags: selectedTags,
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: TagsStatus.error,
      ));
    }
  }

  Future<void> _addTag(TagsAddTagEvent event, Emitter<TagsState> emit) async {
    emit(state.copyWith(
      status: TagsStatus.addingTag,
    ));

    try {
      await databaseService.addTag(event.tagModel, event.userUid);

      emit(state.copyWith(
        status: TagsStatus.tagAdded,
        listTags: [...state.listTags, event.tagModel],
        listSelectedTags: [...state.listSelectedTags, true],
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);

      emit(state.copyWith(
        status: TagsStatus.error,
      ));
    }
  }

  Future<void> _toggleTag(
      TagsToggleTagEvent event, Emitter<TagsState> emit) async {
    emit(state.copyWith(
      status: TagsStatus.togglingTag,
    ));

    try {
      List<bool> selectedTags = state.listSelectedTags;

      selectedTags[event.index] = !selectedTags[event.index];

      emit(state.copyWith(
        status: TagsStatus.tagToggled,
        listSelectedTags: selectedTags,
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: TagsStatus.error,
      ));
    }
  }
}
