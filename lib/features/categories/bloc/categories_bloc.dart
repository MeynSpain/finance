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

  Future<void> _getAllCategories(CategoriesGetAllCategoriesEvent event,
      Emitter<CategoriesState> emit) async {

  }
}
