import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finance/core/constants/globals.dart';
import 'package:finance/core/constants/status/categories_status.dart';
import 'package:finance/core/injection.dart';
import 'package:finance/core/models/category_model.dart';
import 'package:finance/core/models/tag_model.dart';
import 'package:finance/core/models/transaction_model.dart';
import 'package:finance/core/services/database_service.dart';
import 'package:meta/meta.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'categories_event.dart';

part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final DatabaseService databaseService = DatabaseService();

  CategoriesBloc() : super(CategoriesState.initial()) {
    on<CategoriesInitialEvent>(_initial);
    on<CategoriesAddingCategoryEvent>(_addingCategory);
    on<CategoriesGetAllCategoriesEvent>(_getAllCategories);
    on<CategoriesAddStartTemplateEvent>(_addStartTemplate);
    on<CategoriesAddTransactionEvent>(_addTransaction);
    on<CategoriesUpdateBalanceEvent>(_updateBalance);
    on<CategoriesAddTagEvent>(_addTag);
    on<CategoriesGetTagsEvent>(_getTags);
  }

  Future<void> _initial(
      CategoriesInitialEvent event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(
      status: CategoriesStatus.initial,
    ));

    try {
      emit(state.copyWith(
        status: CategoriesStatus.gettingAllCategories,
      ));

      List<CategoryModel> listUnsortedCategories =
          await databaseService.getAllCategories(event.userUid);

      List<CategoryModel> listSortedCategories =
          databaseService.sortCategoriesInTree(listUnsortedCategories);

      emit(state.copyWith(
        status: CategoriesStatus.allCategoriesReceived,
        listUnsortedCategories: listUnsortedCategories,
        listCategories: listSortedCategories,
        currentCategory: listSortedCategories.first,
      ));

      getIt<Talker>()
          .debug('Текущая категория : ${listSortedCategories.first}');

      getIt<Talker>()
          .info('Неотсортированные категории : ${listUnsortedCategories}');

      // emit(state.copyWith(
      //   status: CategoriesStatus.gettingTags,
      // ));
      //
      // List<TagModel> listTags = await databaseService.getTags(event.userUid);
      //
      // emit(state.copyWith(
      //   status: CategoriesStatus.tagsReceived,
      //   listTags: listTags,
      // ));

      emit(state.copyWith(
        status: CategoriesStatus.initialSuccess,
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: CategoriesStatus.errorInitial,
      ));
    }
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
        transactions: [],
      );

      // Добавление категории в бд
      DocumentReference? documentReference = await databaseService.addCategory(
          categoryModel: categoryModel, userUid: event.userUid);

      if (documentReference != null) {
        // Добавляем категорию в качестве тега
        TagModel tagModel =
            TagModel(name: categoryModel.name!, type: Globals.typeCategory);
        await databaseService.addTag(tagModel, event.userUid);

        // Проверяем есть ли родительская категория, если да, то добавляем к ней
        final parentCategory = event.parentCategory;
        if (parentCategory != null) {
          parentCategory.childrenCategory.add(categoryModel);
          // print('Список стейта:');
          // print(state.listCategories);
        } else {
          emit(state.copyWith(
            status: CategoriesStatus.addedCategory,
            listCategories: [...state.listCategories, categoryModel],
            listUnsortedCategories: [
              ...state.listUnsortedCategories,
              categoryModel
            ],
            listTags: [...?state.listTags, tagModel],
          ));
          return;
        }
        emit(state.copyWith(
          status: CategoriesStatus.addedCategory,
          listUnsortedCategories: [
            ...state.listUnsortedCategories,
            categoryModel
          ],
          listTags: [...?state.listTags, tagModel],
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
      listTags: [],
    ));

    try {
      List<CategoryModel> categories =
          await databaseService.getAllCategories(event.userUid);

      List<CategoryModel> listSortedCategories =
          databaseService.sortCategoriesInTree(categories);

      if (categories.isEmpty) {
        getIt<Talker>().debug('Почему то пустые категории');
      }

      emit(state.copyWith(
        status: CategoriesStatus.allCategoriesReceived,
        listCategories: listSortedCategories,
        listUnsortedCategories: categories,
        currentCategory: listSortedCategories.first,
      ));

      getIt<Talker>().info('Неотсортированные категории : ${categories}');
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

      // List<TagModel> listTags =
      //     await databaseService.addTagsTemplate(event.userUid);

      emit(state.copyWith(
        status: CategoriesStatus.startTemplateAdded,
        // listTags: listTags,
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
    }
  }

  /// Добавление транзакции
  Future<void> _addTransaction(CategoriesAddTransactionEvent event,
      Emitter<CategoriesState> emit) async {
    emit(state.copyWith(
      status: CategoriesStatus.addingTransaction,
    ));

    try {
      // Проверка на кол-во тегов типа Категория
      List<TagModel>? listTags = event.transactionModel.tags;
      int countTypeCategory = 0;
      if (listTags != null) {
        for (TagModel tag in listTags) {
          if (tag.type == Globals.typeCategory) {
            countTypeCategory++;
            if (countTypeCategory >= 2) {
              emit(state.copyWith(
                status: CategoriesStatus.errorManyTagCategory,
                messageError:
                    'Транзакция содержит больше одного тека типа Категория',
              ));
              return;
            }
          }
        }
      }

      await databaseService.addTransaction(
        userUid: event.userUid,
        categories: state.listUnsortedCategories,
        categoryUid: event.transactionModel.categoryUid!,
        rootCategoryUid: event.rootCategoryUid,
        transactionModel: event.transactionModel,
        isIncome: event.isIncome,
      );

      // int indexOfCurrentCategory = state.listCategories.indexWhere((element) => element.uid == categoryModel.uid);

      // state.listCategories[indexOfCurrentCategory] = categoryModel;

      CategoryModel? categoryModel = await databaseService.getCategory(categoryUid: event.rootCategoryUid, userUid: event.userUid);

      emit(state.copyWith(
        status: CategoriesStatus.transactionAdded,
        currentCategory: categoryModel,
        // listCategories: state.listCategories,
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
    }
  }

  Future<void> _updateBalance(
      CategoriesUpdateBalanceEvent event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(
      status: CategoriesStatus.updatingBalance,
    ));

    try {
      await databaseService.updateBalance(
          event.categoryModel, event.newBalance);
      emit(state.copyWith(
        status: CategoriesStatus.balanceUpdated,
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: CategoriesStatus.error,
      ));
    }
  }

  Future<void> _addTag(
      CategoriesAddTagEvent event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(
      status: CategoriesStatus.addingTag,
    ));

    try {
      await databaseService.addTag(event.tagModel, event.userUid);

      emit(state.copyWith(
        status: CategoriesStatus.tagAdded,
        listTags: [...?state.listTags, event.tagModel],
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: CategoriesStatus.errorAddingTag,
      ));
    }
  }

  Future<void> _getTags(
      CategoriesGetTagsEvent event, Emitter<CategoriesState> emit) async {
    emit(state.copyWith(
      status: CategoriesStatus.gettingTags,
    ));

    try {
      List<TagModel> listTags = await databaseService.getTags(event.useUid);

      emit(state.copyWith(
        status: CategoriesStatus.tagsReceived,
        listTags: listTags,
      ));
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      emit(state.copyWith(
        status: CategoriesStatus.errorGettingTags,
      ));
    }
  }
}
