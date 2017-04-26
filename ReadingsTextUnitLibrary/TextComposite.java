import java.util.ArrayList;

class TextComposite extends Text {

  // The content of the unit.
  protected ArrayList<Text> subTexts;

  // For the iteratr.
  private int current;

  // The string used to join texts.
  protected String joiner;

  // Text cache.
  private String cache;

  TextComposite() {
    this("");
  }

  TextComposite(String joiner) {
    this.joiner = joiner;
    subTexts = new ArrayList<Text>();
    cache = null;
    reset();
  }

  String getText() {
    if (cache == null) {
      cache = "";
      for (int i=0; i<subTexts.size(); i++) {
        if (i>0)
          cache += joiner;
        cache += subTexts.get(i);
      }
    }
    return cache;
  }

  void reset() {
    current = 0;
  }

  boolean hasNext() {
    return (current < nTexts());
  }

  Text peek() {
    return get(current);
  }

  Text next() {
    return get(current++);
  }

  int current() { return current; }

  Text get(int index) {
    try {
      return subTexts.get(index);
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
  }

  void add(Text text) {
    subTexts.add(text);
    cache = null;
  }

  void remove(int index) {
    subTexts.remove(index);
    cache = null;
  }

  int nTexts() {
    return subTexts.size();
  }

	String debug(int indentationLevel) {
		String str = getIndented("(\n", indentationLevel);
		for (Text t : subTexts) {
      str += t.debug(indentationLevel+1);
		}
		str += getIndented(")\n", indentationLevel);
		return str;
	}

}
