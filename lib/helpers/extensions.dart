extension ToUpperCase on String {
  firstCharToUpperCase() {
    return this[0].toUpperCase() + replaceRange(0, 1, "");
  }
}
