abstract class Text {

  abstract String getText();

  int length() { return getText().length(); }
  boolean isEmpty() { return getText().isEmpty(); }

  public String toString() { return getText(); }

}
