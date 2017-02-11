# Load LSTM network and generate text
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("text_file", type=str, help="The file containing the original text")
parser.add_argument("model_files_prefix", type=str, help="The file containing the prefix to the model files")
parser.add_argument("output_file", type=str, help="The output file")
parser.add_argument("-n", "--n-hidden", type=int, default=256, help="Number of hidden units per layer")
parser.add_argument("-l", "--n-layers", type=int, default=1, help="Number of layers")
parser.add_argument("-e", "--n-epochs", type=int, default=20, help="Number of epochs")
parser.add_argument("-s", "--sequence-length", type=int, default=100, help="Sequence length")
parser.add_argument("-S", "--sampling_mode", type=str, default="argmax", choices=["argmax", "softmax", "special"], help="Sampling policy")
parser.add_argument("-N", "--n-words", type=int, default=1000, help="Number of words to generate per epoch/chapter")
parser.add_argument("-T", "--temperature", type=float, default=1, help="Temperature argument [0, +inf] (for softmax sampling) (higher: more uniform, lower: more greedy")

args = parser.parse_args()

import sys
import numpy
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import Dropout
from keras.layers import LSTM
from keras.callbacks import ModelCheckpoint
from keras.utils import np_utils


# load ascii text and covert to lowercase
raw_text = open(args.text_file).read()
raw_text = raw_text.lower()

# output file
output_file = open(args.output_file, "w+")

# create mapping of unique chars to integers, and a reverse mapping
chars = sorted(list(set(raw_text)))
char_to_int = dict((c, i) for i, c in enumerate(chars))
int_to_char = dict((i, c) for i, c in enumerate(chars))

# summarize the loaded data
n_chars = len(raw_text)
n_vocab = len(chars)
print "Total Characters: ", n_chars
print "Total Vocab: ", n_vocab

# prepare the dataset of input to output pairs encoded as integers
seq_length = args.sequence_length
dataX = []
dataY = []
for i in range(0, n_chars - seq_length, 1):
	seq_in = raw_text[i:i + seq_length]
	seq_out = raw_text[i + seq_length]
	dataX.append([char_to_int[char] for char in seq_in])
	dataY.append(char_to_int[seq_out])
n_patterns = len(dataX)
print "Total Patterns: ", n_patterns
# reshape X to be [samples, time steps, features]
X = numpy.reshape(dataX, (n_patterns, seq_length, 1))
# normalize
X = X / float(n_vocab)
# one hot encode the output variable
y = np_utils.to_categorical(dataY)


# define the LSTM model
model = Sequential()
model.add(LSTM(args.n_hidden, input_shape=(X.shape[1], X.shape[2]), return_sequences=(args.n_layers > 1)))
model.add(Dropout(0.2))
for l in range(1, args.n_layers):
	model.add(LSTM(args.n_hidden, return_sequences=(l < args.n_layers-1)))
	model.add(Dropout(0.2))
model.add(Dense(y.shape[1], activation='softmax'))

print model.summary()

# pick beginning of text as seed
pattern = dataX[0]

print "Seed:"
print "\"", ''.join([int_to_char[value] for value in pattern]), "\""

# Run through all epochs, outputing text
for e in range(args.n_epochs):
	print "Generating epoch # {epoch}".format(epoch=e)
	# load the network weights
	model_file = "{prefix}{epoch:02d}.hdf5".format(prefix=args.model_files_prefix, epoch=e)
	model.load_weights(model_file)
	model.compile(loss='categorical_crossentropy', optimizer='adam')
	#output_file.write("\n\nEPOCH {epoch}\n\n".format(epoch=e))

	# generate characters
	for i in range(args.n_words):
		x = numpy.reshape(pattern, (1, len(pattern), 1))
		x = x / float(n_vocab)
		prediction = model.predict(x, verbose=0)

		# argmax
		if (args.sampling_mode == "argmax"):
			index = numpy.argmax(prediction.squeeze())

		# random
		else:
			# Source: https://gist.github.com/alceufc/f3fd0cd7d9efb120195c
			prediction = prediction.squeeze()
			if (temperature != 1):
				prediction = numpy.power(prediction, 1./temperature)
				prediction /= prediction.sum(0)

			#print "[" + args.sampling_mode +"]"
			#print (args.sampling_mode == "softmax")

			if (args.sampling_mode == "softmax"):
				#print "using softmax"
				index = numpy.asscalar(numpy.random.choice(numpy.arange(n_vocab), 1, p=prediction))

			# special
			else:
				prediction = numpy.asarray(prediction)
				max_indices = prediction.argsort()[-3:][::-1]
				max_indices_weights = [ prediction[m] for m in max_indices ]
				max_indices_sum = numpy.sum(max_indices_weights)
				max_indices_weights = [ prediction[m]/max_indices_sum for m in max_indices ]
				index = numpy.asscalar(numpy.random.choice(numpy.array(max_indices), 1, p=numpy.array(max_indices_weights)))

		result = int_to_char[index]
		seq_in = [int_to_char[value] for value in pattern]
		output_file.write(result)
		pattern.append(index)
		pattern = pattern[1:len(pattern)]

	output_file.flush()
