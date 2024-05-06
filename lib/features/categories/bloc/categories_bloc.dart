import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/status/categories_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/category_model.dart';
import 'package:finance/core/services/database_service.dart';
import 'package:meta/meta.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'categories_event.dart';

part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final DatabaseService databaseService = DatabaseService();

  CategoriesBloc() : super(CategoriesState.initial()) {
    on<CategoriesAddingCategoryEvent>(_addingCategory);
    on<CategoriesGetAllCategoriesEvent>(_getAllCategories);
    on<CategoriesAddStartTemplateEvent>(_addStartTemplate);
  }

  /// Добавление категории в базу данных
  Future<void> _addingCategory(CategoriesAddingCategoryEvent event,
      Emitter<CategoriesState> emit) async {
    // Сообщаем что идет добавление категории
    emit(state.copyWith(
      status: CategoriesStatus.addingCategory,
    ));

    try {
      CategoryModel categoryModel = CategoryModel(
        balance: 0,
        name: event.name,
        userUid: event.userUid,
        parentCategoryUid: event.parentCategory?.uid,
        childrenCategory: [],
      );

      // Добавление категории в бд
      DocumentReference? documentReference = await databaseService.addCategory(
          categoryModel: categoryModel, userUid: event.userUid);

      if (documentReference != null) {
        // Проверяем есть ли родительская категория, если да, то добавляем к ней
        final parentCategory = event.parentCategory;
        if (parentCategory != null) {
          parentCategory.childrenCategory.add(categoryModel);
          print('Список стейта:');
          print(state.listCategories);
        } else {
          emit(state.copyWith(
            status: CategoriesStatus.addedCategory,
            listCategories: [...state.listCategories, categoryModel],
          ));
          return;
        }
        emit(state.copyWith(
          status: CategoriesStatus.addedCategory,
        ));
      } else {
        // Категория не добавлена
        emit(state.copyWith(status: CategoriesStatus.errorCategoryNotAdded));
      }
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(status: CategoriesStatus.error));
    }
  }

  /// Получить все категории
  Future<void> _getAllCategories(CategoriesGetAllCategoriesEvent event,
      Emitter<CategoriesState> emit) async {
    emit(state.copyWith(
      status: CategoriesStatus.gettingAllCategories,
    ));

    try {
      List<CategoryModel> categories =
          await databaseService.getAllCategories(event.userUid);

      if (categories.isEmpty) {
        getIt<Talker>().debug('Почему то пустые категории');
      }

      emit(state.copyWith(
          status: CategoriesStatus.allCategoriesReceived,
          listCategories: categories));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(status: CategoriesStatus.errorGettingAllCategories));
    }
  }

  Future<void> _addStartTemplate(CategoriesAddStartTemplateEvent event,
      Emitter<CategoriesState> emit) async {
    emit(state.copyWith(
      status: CategoriesStatus.addingStartTemplate,
    ));

    try {
      CategoryModel startCategoryTemplate = await databaseService
          .addStartCategoryTemplate(userUid: event.userUid);

      emit(state.copyWith(
        status: CategoriesStatus.startTemplateAdded,
        listCategories: [startCategoryTemplate],
      ));

    } catch (e, st) {
      getIt<Talker>().handle(e, st);
    }
  }
}
