class Book extends TextComposite {

  Book(String filename, int maxLengthPerLine, int nCharsPerEpoch) {
    // Preprocess.
    String[] lines = loadStrings(filename);
    TextComposite currentEpoch = new TextComposite();
    add(currentEpoch);

    // Run through all lines.
    for (String l : lines) {

      // Process line (possibly generating several blocks).
      TextComposite block = new TextComposite(" ");
      String[] splitted = l.split(" ");
      for (String s : splitted) {
        TextUnit word = new TextUnit(s);

        // Try to add word to block.
        if (!tryAdd(block, word, maxLengthPerLine)) {

          // Could not add word to block: block is finished, try to add block to epoch.
          if (!tryAdd(currentEpoch, block, nCharsPerEpoch)) {

            // Could not add block to epoch: epoch is finished, add to next epoch.
            currentEpoch = new TextComposite();
            currentEpoch.add(block);
            add(currentEpoch);
          }

          // Reset next block.
          block = new TextComposite(" ");
          block.add(word);
        }
      }
      // TODO: add \n
    }
    println("N epoch:" + nTexts());

  }

  boolean tryAdd(TextComposite composite, Text unit, int maxLength) {
    // Try to add element.
    composite.add(unit);

    // If too big...
    if (composite.length() > maxLength) {
      // Remove last added.
      composite.remove(composite.nTexts()-1);
      return false;
    }
    else
      return true;
  }

}

// class Book extends TextComposite {
//
//   Book(String filename, int maxLengthPerLine) {
//     // Preprocess.
//     String[] lines = loadStrings(filename);
//     TextComposite currentEpoch = null;
//     for (String l : lines) {
//       // Create new epoch.
//       if (l.startsWith("EPOCH "))
//       {
//         currentEpoch = new TextComposite();
//         add(currentEpoch);
//       }
//       else
//       {
//         TextComposite block = new TextComposite(" ");
//         String[] splitted = l.split(" ");
//         for (String s : splitted) {
//           TextUnit word = new TextUnit(s);
//
//           // Try to add element.
//           block.add(word);
//
//           // If too big...
//           if (block.length() > maxLengthPerLine) {
//             // Remove last added.
//             block.remove(block.nTexts()-1);
//             // Add to epoch.
//             currentEpoch.add(block);
//             // Reset next.
//             block = new TextComposite(" ");
//             block.add(word);
//           }
//         }
//       }
//     }
//   }
// }
