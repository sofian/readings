
class Book {
  ArrayList<ArrayList<String> > text;
  int epoch;
  int word;
  
  int nCharacters;
  int nLines;
  
  Book(String filename) {
    // Preprocess.
    nCharacters = 0;
    text = new ArrayList<ArrayList<String> >();
    String[] lines = loadStrings(filename);
    ArrayList<String> current = null;
    for (String l : lines) {
      if (l.startsWith("EPOCH "))
      {
        if (current != null)
          text.add(current);
        current = new ArrayList<String>();
      }
      else if (current != null)
      {
        String[] splitted = l.split(" ");
        for (String s : splitted)
          current.add(s);
        //current.add("\n");
        nCharacters += l.length() + 2; // add the \n\n
      }
    }
    
    epoch = 0;
    word = 0;
  }
  
  boolean hasNext() {
    return hasNextEpoch() && word < text.get(epoch).size();
  }
  
  boolean hasNextEpoch() {
    return epoch < text.size();    
  }
  
  boolean isFinished() {
    return !hasNextEpoch() && !hasNext();
  }
  
  int epoch() { return epoch; }
  
  String peek() {
    return text.get(epoch).get(word);
  }
  
  String next() {
    return text.get(epoch).get(word++);
  }
  
  void nextEpoch() {
    epoch++;
    word=0;
  }
  
  int nEpochs() {
    return text.size();
  }
}