class Book extends TextComposite {

	TextComposite currentEpoch;

  Book(String filename, int maxLengthPerLine, int nCharsPerEpoch) {
    // Preprocess.
    String[] lines = loadStrings(filename);
    currentEpoch = new TextComposite();
    add(currentEpoch);

    // Run through all lines.
    for (String l : lines) {

      // Process line (possibly generating several blocks).
      TextComposite block = new TextComposite(" ");
      String[] splitted = l.split(" "); // TODO: ne tient pas compte des cas ou il y a deux espaces
      for (String s : splitted) {
				// Special case: word itself is just too large.
				if (s.length() > maxLengthPerLine) {
					// TODO: UNTESTED
					// Non-empty block: add something at the end of block.
					int minLengthPerLine = maxLengthPerLine/2;
					if (block.length() < minLengthPerLine) {
						int subLength = maxLengthPerLine-block.length()-(block.isEmpty() ? 0 : 1);
						TextUnit word = new TextUnit(s.substring(0, subLength));
						if (tryAdd(block, word, maxLengthPerLine))
							s = s.substring(subLength);
						addBlock(block, nCharsPerEpoch);
					}
					// Add the rest.
					do {
				  	block = new TextComposite(" ");
						block.add(new TextUnit(s.substring(0, maxLengthPerLine)));
						addBlock(block, nCharsPerEpoch);
						s = s.substring(maxLengthPerLine);
					}	while (s.length() > maxLengthPerLine);
				  block = new TextComposite(" ");
				}

        TextUnit word = new TextUnit(s);

        // Try to add word to block.
        if (!tryAdd(block, word, maxLengthPerLine)) {

					// Process block.
					addBlock(block, nCharsPerEpoch);

          // Reset next block.
          block = new TextComposite(" ");
          block.add(word);
        }
      }
      // TODO: add \n
    }
    println("N epoch:" + nTexts());
  }

	// Tries adding block to current epoch: if not, then moves to next epoch.
	void addBlock(Text block, int nCharsPerEpoch) {
    // Could not add word to block: block is finished, try to add block to epoch.
    if (!tryAdd(currentEpoch, block, nCharsPerEpoch)) {

      // Could not add block to epoch: epoch is finished, add to next epoch.
      currentEpoch = new TextComposite();
      currentEpoch.add(block);
      add(currentEpoch);
    }
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
