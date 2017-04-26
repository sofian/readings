final int N_COLUMNS   = 8;
final float MARGIN_WIDTH  = 4;
final float MARGIN_HEIGHT = 10;
final float TEXT_SIZE = 9;

final color START_COLOR = #1724FF;
final color END_COLOR   = #A50076;
final color BACKGROUND_COLOR = #000000;
//final color BACKGROUND_COLOR = #FFFFF5;

final String BOOK_FILES_PATH = "/home/tats/Documents/workspace/deep-learning-sandbox/lstm_text_generation/experiments/wuthering-layers2-nhu256/";

final String FONT_FAMILY = "Georgia";
PFont FONT;

int N_EPOCHS_PER_COLUMN;
float COLUMN_OUTER_WIDTH;
float COLUMN_INNER_WIDTH;

int currentColumn;
float y;

Book book;

final boolean ANIMATE = true;

void setup() {
  fullScreen(2);
  // size(1920, 1080);
  smooth();
//  book = new Book(BOOK_FILES_PATH + "/wuthering-layers2-nhu256-e40-N500-Ssoftmax-T.25.txt", 35, 500);
//  book = new Book(BOOK_FILES_PATH + "/wuthering-layers2-nhu256-e40-N500-Ssoftmax-T.5.txt", 35, 500);
	 book = new Book(BOOK_FILES_PATH + "/wuthering-layers2-nhu256-e40-N500-Ssoftmax-T.05-E.5-seed_end.txt", 20, 500); // good!
//	 book = new Book("test2.txt", 15, 75); // good!
//	 book = new Book(BOOK_FILES_PATH + "/wuthering-layers2-nhu256-beginning+w40-N75-Ssoftmax-T.05-E.5-seed_end.txt", 15, 75); // good!
//  book = new Book(BOOK_FILES_PATH + "/wuthering-layers2-nhu256-e40-N500-Sargmax.txt", 35, 500);

//  book = new Book("horla_test_oneline.txt", 40, 1015);
//  book = new Book("test.txt", 5, 10);

//	println(book.debug());

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

	// Compute baseline.

}

int nWords = 0;

void draw() {
  background(BACKGROUND_COLOR);
//  background(BACKGROUND_COLOR);

  y = 0;
  currentColumn = -1;
//  println("n texts: " + book.nTexts());
	int k=0;
  for (int i=0; i<book.nTexts(); i++) {
//    println("#" + i + " / " + book.nTexts());
    TextComposite epoch = (TextComposite)book.get(i);

    if (i % N_EPOCHS_PER_COLUMN == 0) {
      y = 0;
      currentColumn++;
    }

    //int currentColumn = i / N_EPOCHS_PER_COLUMN;
    float x = currentColumn*COLUMN_OUTER_WIDTH;

    float epochFontSize = (float)(height - 2*MARGIN_HEIGHT) / epoch.nTexts();

    // Iterate and print
    for (int j=0; j<epoch.nTexts(); j++) {
      TextComposite line = (TextComposite)epoch.get(j);
			if (line.isEmpty())
				continue;
			if (y > height)
				continue;
      // Print block.
      //println("[" +line+"]");
			textAlign(LEFT);
      textSize(epochFontSize);
      //float fontSize = TEXT_SIZE;
      float fontSize = epochFontSize * COLUMN_INNER_WIDTH / textWidth(line.getText());

      //println("Font size: " + fontSize);
      textSize(fontSize);
      fill(lerpColor(START_COLOR, END_COLOR, (float)i / (float)book.nTexts()));
      //println(x + "," + y);
      text(line.getText(), x, y+=fontSize);

			// Animate (display text step by step).
			k++;
			if (ANIMATE && k > nWords) {
				frameRate(random(0.8, 1.5));
			  nWords++;
				return;
			}
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
