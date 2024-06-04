enum CategoriesStatus {
  initial,

  error,
  errorInitial,
  errorCategoryNotAdded,
  errorGettingAllCategories,
  errorAddingStartTemplate,
  errorUpdatingBalance,
  errorAddingTag,
  errorGettingTags,
  errorManyTagCategory,
  errorAddingNewAccount,

  initialSuccess,


  addingNewAccount,
  newAccountAdded,

  selectingAccount,
  accountSelected,

  creatingCategory,
  addingCategory,
  addedCategory,

  gettingAllCategories,
  allCategoriesReceived,

  addingStartTemplate,
  startTemplateAdded,

  addingTagsTemplate,
  tagsTemplateAdded,

  addingTransaction,
  transactionAdded,

  updatingBalance,
  balanceUpdated,

  addingTag,
  tagAdded,

  gettingTags,
  tagsReceived,

  selectingNewDate,
  newDateSelected,

}