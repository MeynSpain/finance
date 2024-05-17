enum CategoriesStatus {
  initial,

  error,
  errorCategoryNotAdded,
  errorGettingAllCategories,
  errorAddingStartTemplate,
  errorUpdatingBalance,
  errorAddingTag,
  errorGettingTags,

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
}