final int N_COLUMNS   = 10;
final float MARGIN_WIDTH  = 2;
final float MARGIN_HEIGHT = 10;
final float TEXT_SIZE = 9;

final color START_COLOR = #000000;
final color END_COLOR   = #1724FF;
final color BACKGROUND_COLOR = #FFFFF5;

int N_EPOCHS_PER_COLUMN;
float COLUMN_OUTER_WIDTH;
float COLUMN_INNER_WIDTH;


int currentColumn;
int currentLine;
int y;

Book book;

String block;

void setup() {
  size(1920, 1080);
  book = new Book("horla_layers2_nhu256_generated_book.txt");

  N_EPOCHS_PER_COLUMN = book.nEpochs() / N_COLUMNS;
  COLUMN_OUTER_WIDTH = width/N_COLUMNS;
  COLUMN_INNER_WIDTH = COLUMN_OUTER_WIDTH-2*MARGIN_WIDTH;

  textSize(TEXT_SIZE);

  currentColumn = 0;
  currentLine   = 0;
  y             = 0;
  block = "";
  background(BACKGROUND_COLOR);
  fill(0);
  
  fill(lerpColor(START_COLOR, END_COLOR, (float)book.epoch() / (float)book.nEpochs()));
  textAlign(CENTER);
  text("EPOCH 0", COLUMN_OUTER_WIDTH/2 + currentColumn*COLUMN_OUTER_WIDTH, y+=MARGIN_HEIGHT);
  currentLine+=2;
  textAlign(LEFT);
}

void draw() {
  step();
  //while (!book.isFinished())
  //  step();
}

void step() {
  if (!book.isFinished()) {
    if (book.hasNext())
    {
      String testBlock = (block.isEmpty() ? book.peek() : block + " " + book.peek());
      textSize(TEXT_SIZE);
      if (textWidth(testBlock) < COLUMN_INNER_WIDTH) {
        block = testBlock;
        book.next();
      }
      else {
        float fontSize = TEXT_SIZE;
        if (textWidth(block) > 0.1) {
          textSize(fontSize);
          while (textWidth(block) < COLUMN_INNER_WIDTH) {
            textSize(fontSize);
            fontSize+=0.1;
          }
        }
        else
          textSize(fontSize);
        fill(lerpColor(START_COLOR, END_COLOR, (float)book.epoch() / (float)book.nEpochs()));
        text(block, MARGIN_WIDTH + currentColumn*COLUMN_OUTER_WIDTH, y+=fontSize);
        block = "";
        currentLine++;
      }
    }
    else if (book.hasNextEpoch())
    {
      book.nextEpoch();
      currentLine+=2;
      if (book.epoch() % N_EPOCHS_PER_COLUMN == 0) {
        currentColumn++;
        currentLine = 0;
        y=0;
      }
      fill(lerpColor(START_COLOR, END_COLOR, (float)book.epoch() / (float)book.nEpochs()));
      textAlign(CENTER);
      textSize(TEXT_SIZE);
      text("EPOCH " + book.epoch(), COLUMN_OUTER_WIDTH/2 + currentColumn*COLUMN_OUTER_WIDTH, y+=TEXT_SIZE);
      currentLine+=2;
      textAlign(LEFT);
    }
  }
}