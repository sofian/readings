abstract class Text {

  abstract String getText();

  int length() { return getText().length(); }
  boolean isEmpty() { return getText().isEmpty(); }

  public String toString() { return getText(); }

	String debug() { return debug(0); }
	String debug(int indentationLevel) { return getIndented(toString() + "\n", indentationLevel); }

	static String getIndented(String str, int indentationLevel) {
		String indentSpace = new String(new char[indentationLevel*2]).replace('\0', ' ');
		return indentSpace + str;
	}
}
