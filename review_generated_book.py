# Load LSTM network and generate text
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("text_file", type=str, help="The file containing the generated text")
parser.add_argument("model_file_list", type=str, help="A file containing all the model files that were used OR a prefix that was used for files")
parser.add_argument("-N", "--n-words", type=int, default=1000, help="Number of words to generate per epoch/chapter")
parser.add_argument("-e", "--n-epochs", type=int, default=20, help="Number of epochs")

args = parser.parse_args()

import sys
import numpy
import os.path

text = open(args.text_file, "r+").read()

n_epochs = args.n_epochs
n_words  = args.n_words

# model files
if os.path.isfile(args.model_file_list):
	model_files = [line.rstrip('\n').strip() for line in open(args.model_file_list)]
	if (n_epochs < len(model_files)):
		print "Number of epochs {n_epochs} is smaller than number of files in list {n_files}: adjusting.".format(n_epochs=n_epochs, n_files=len(model_files))
		n_epochs = len(model_files)
else:
	model_files = [	"{prefix}{epoch:02d}.hdf5".format(prefix=args.model_file_list, epoch=e) for e in range(n_epochs) ]

# Run through all epochs, outputing text
i=0
for e in range(n_epochs):
	model_file = model_files[e]
	print "=== {model_file} ===".format(model_file=model_file)
	print text[i : i+n_words]
	i = i+n_words
