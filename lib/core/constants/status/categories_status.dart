enum CategoriesStatus {
  initial,

  error,
  errorCategoryNotAdded,
  errorGettingAllCategories,
  errorAddingStartTemplate,

  creatingCategory,
  addingCategory,
  addedCategory,

  gettingAllCategories,
  allCategoriesReceived,

  addingStartTemplate,
  startTemplateAdded,

  addingTransaction,
  transactionAdded,

  updatingBalance,
  balanceUpdated,
}