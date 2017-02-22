# Source: http://machinelearningmastery.com/text-generation-lstm-recurrent-neural-networks-python-keras/

import argparse

parser = argparse.ArgumentParser()
parser.add_argument("text_file", type=str, help="The file containing the original text")
parser.add_argument("-n", "--n-hidden", type=int, default=256, help="Number of hidden units per layer")
parser.add_argument("-l", "--n-layers", type=int, default=1, help="Number of layers")
parser.add_argument("-s", "--sequence-length", type=int, default=100, help="Sequence length")
parser.add_argument("-m", "--model-file", type=str, default="", help="Model file to load (in order to restart from a certain point)")
parser.add_argument("-i", "--initial-epoch", type=int, default=0, help="Epoch at which to start training (useful for resuming previous training)")
parser.add_argument("-e", "--n-epochs", type=int, default=20, help="Number of epochs to train (total)")
parser.add_argument("-lr", "--learning-rate", type=float, default=0.001, help="The learning rate")

args = parser.parse_args()

import numpy
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import Dropout
from keras.layers import LSTM
from keras.callbacks import Callback
from keras.utils import np_utils

import time

class ModelSave(Callback):
	def __init__(self, filepath, mode="epoch", save_weights_only=False, period=1):
		super(ModelSave, self).__init__()
		self.filepath = filepath
		self.save_weights_only = save_weights_only
		self.period = period
		self.steps_since_last_save = 0
		if (mode == "epoch"):
			self.process_epoch = True
		elif (mode == "batch"):
			self.process_epoch = False
		else:
			raise ValueError("Option 'mode' must either be set to 'epoch' or 'batch'.")

	def on_step_end(self, filepath, step, logs={}):
		self.steps_since_last_save += 1
		if self.steps_since_last_save >= self.period:
			self.steps_since_last_save = 0
			if self.save_weights_only:
				self.model.save_weights(filepath, overwrite=True)
			else:
				self.model.save(filepath, overwrite=True)

	def on_batch_end(self, batch, logs={}):
		if (not self.process_epoch):
			self.on_step_end(self.filepath.format(**logs), batch, logs)

	def on_epoch_end(self, epoch, logs={}):
		if (self.process_epoch):
			self.on_step_end(self.filepath.format(epoch=epoch, **logs), epoch, logs)

# load ascii text and covert to lowercase
raw_text = open(args.text_file).read()
raw_text = raw_text.lower()

# create mapping of unique chars to integers
chars = sorted(list(set(raw_text)))
char_to_int = dict((c, i) for i, c in enumerate(chars))

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

if (args.model_file):
  print "Loading weights from: " + args.model_file
  model.load_weights(args.model_file)

model.compile(loss='categorical_crossentropy', optimizer='adam')
model.optimizer.lr.set_value(args.learning_rate) # Change learning rate

# define the checkpoint
filepath_prefix="lstm-weights-layers{n_layers}-nhu{n_hidden}-".format(n_hidden=args.n_hidden, n_layers=args.n_layers)
filepath_epoch=filepath_prefix+"e{epoch:02d}.hdf5"
filepath_batch=filepath_prefix+"b{batch:08d}.hdf5"

filepath="lstm-weights-layers{n_layers}-nhu{n_hidden}-{{epoch:02d}}.hdf5".format(n_hidden=args.n_hidden, n_layers=args.n_layers)
if (args.initial_epoch == 0):
  model.save_weights(filepath_epoch.format(epoch=-1)) # save startup weights
callbacks_list = [ModelSave(filepath_epoch, mode="epoch", save_weights_only=True), ModelSave(filepath_batch, mode="batch", save_weights_only=True, period=10)]

# train
absolute_time = time.time()
cpu_time = time.clock()
model.fit(X, y, nb_epoch=args.n_epochs, batch_size=128, callbacks=callbacks_list, initial_epoch=args.initial_epoch)
absolute_time = time.time()  - absolute_time
cpu_time      = time.clock() - cpu_time
n_epochs = args.n_epochs - args.initial_epoch

print "Total time: {time:.2f} {cputime:.2f}".format(time=absolute_time, cputime=cpu_time)
print "Per epoch:  {time:.2f} {cputime:.2f}".format(time=absolute_time/n_epochs, cputime=cpu_time/n_epochs)
