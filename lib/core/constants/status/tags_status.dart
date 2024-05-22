enum TagsStatus {
  initial,

  gettingAllTags,
  allTagsReceived,

  addingTag,
  tagAdded,

  togglingTag,
  tagToggled,

  // success,

  error,
}