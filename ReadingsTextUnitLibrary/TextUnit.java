class TextUnit extends Text {

  // The content of the unit.
  protected String str;

  TextUnit() {
    this("");
  }

  TextUnit(String str) {
    this.str = str;
  }

  String getText() { return str; }

}
