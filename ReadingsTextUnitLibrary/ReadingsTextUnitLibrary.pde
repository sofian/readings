final int N_COLUMNS   = 8;
final float MARGIN_WIDTH  = 2;
final float MARGIN_HEIGHT = 10;
final float TEXT_SIZE = 9;

final color START_COLOR = #1724FF;
final color END_COLOR   = #A50076;
final color BACKGROUND_COLOR = #FFFFF5;

final String FONT_FAMILY = "Georgia";
PFont FONT;

int N_EPOCHS_PER_COLUMN;
float COLUMN_OUTER_WIDTH;
float COLUMN_INNER_WIDTH;

int currentColumn;
float y;

Book book;

void setup() {
  //fullScreen(2);
  size(1920, 1080);
  smooth();
  book = new Book("wuthering-layers2-nhu256-e40-N500-Ssoftmax-T.5.txt", 35, 500);
//  book = new Book("horla_test_oneline.txt", 40, 1015);
//  book = new Book("test.txt", 5, 10);

  N_EPOCHS_PER_COLUMN = book.nTexts() / N_COLUMNS;
  COLUMN_OUTER_WIDTH = width/N_COLUMNS;
  COLUMN_INNER_WIDTH = COLUMN_OUTER_WIDTH-2*MARGIN_WIDTH;

  FONT = createFont(FONT_FAMILY, TEXT_SIZE);

  textFont(FONT);
  textSize(TEXT_SIZE);

  currentColumn = 0;
  y             = 0;

  background(BACKGROUND_COLOR);
  fill(0);
  textAlign(LEFT);
  println("Finished processing");
}

void draw() {
//  background(BACKGROUND_COLOR);

  y = 0;
  currentColumn = -1;
//  println("n texts: " + book.nTexts());
  for (int i=0; i<book.nTexts(); i++) {
    println("#" + i + " / " + book.nTexts());
    TextComposite epoch = (TextComposite)book.get(i);
    if (i % N_EPOCHS_PER_COLUMN == 0) {
      y = 0;
      currentColumn++;
    }

    //int currentColumn = i / N_EPOCHS_PER_COLUMN;
    float x = MARGIN_WIDTH + currentColumn*COLUMN_OUTER_WIDTH;

    // Iterate and print
    for (int j=0; j<epoch.nTexts(); j++) {
      TextComposite line = (TextComposite)epoch.get(j);
      // Print block.
      println("[" +line+"]");
      textSize(TEXT_SIZE);
      //float fontSize = TEXT_SIZE;
      float fontSize = TEXT_SIZE * COLUMN_INNER_WIDTH / textWidth(line.getText());
      // println("Font size: " + fontSize);
      textSize(fontSize);
      fill(lerpColor(START_COLOR, END_COLOR, (float)i / (float)book.nTexts()));
      println(y);
      text(line.getText(), x, y+=fontSize);
    }


  }

//  step();
}
//
// void step() {
//   if (book.hasNext()) {
//     TextComposite epoch = book.next();
//     if (book.hasNext())
//     {
//       if (book.peek().isEmpty()) {
//         book.next();
//       }
//       else {
//         String testBlock = (block.isEmpty() ? book.peek() : block + " " + book.peek());
//         textSize(TEXT_SIZE);
//         if (textWidth(testBlock) < COLUMN_INNER_WIDTH) {
//           block = testBlock;
//           book.next();
//         }
//         else {
//           // Print block.
//           println("[" +block+"]");
//           float fontSize = TEXT_SIZE * COLUMN_INNER_WIDTH / textWidth(block);
//           println(fontSize);
//           textSize(fontSize);
//           fill(lerpColor(START_COLOR, END_COLOR, (float)book.epoch() / (float)book.nEpochs()));
//           text(block, MARGIN_WIDTH + currentColumn*COLUMN_OUTER_WIDTH, y+=fontSize);
//           block = "";
//           currentLine++;
//         }
//       }
//     }
//     else if (book.hasNextEpoch())
//     {
//       book.nextEpoch();
//       //currentLine+=2;
//       if (book.epoch() % N_EPOCHS_PER_COLUMN == 0) {
//         currentColumn++;
//         currentLine = 0;
//         y=0;
//       }
//       //fill(lerpColor(START_COLOR, END_COLOR, (float)book.epoch() / (float)book.nEpochs()));
//       //textAlign(CENTER);
//       //textSize(TEXT_SIZE);
//       //text("EPOCH " + book.epoch(), COLUMN_OUTER_WIDTH/2 + currentColumn*COLUMN_OUTER_WIDTH, y+=TEXT_SIZE);
//       //currentLine+=2;
//       //y+=TEXT_SIZE;
//       textAlign(LEFT);
//     }
//   }
// }
