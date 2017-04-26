# -*- coding: utf-8 -*-
# Source: http://machinelearningmastery.com/text-generation-lstm-recurrent-neural-networks-python-keras/

import argparse

parser = argparse.ArgumentParser()
parser.add_argument("config_file", type=str, help="The file containing the configuration")
parser.add_argument("-a", "--action", type=str, default="train", help="The specific action to perform")

args = parser.parse_args()

import yaml

# load data
data = yaml.load(open(args.config_file))
action = args.action

# generate parameters
params = {}
args = []
executable = None
action_path = action.split('/')
item = data
for a in action_path:
	item = item[a]
	if item:
		# override exec
		if "exec" in item:
			executable = item["exec"]
		# override all args
		if "args" in item:
			args = item["args"]
	  # override params (if exists)
		if "params" in item:
			for k in item["params"]:
				params[k] = item["params"][k]

print "Exec: " + str(executable)
print "Args: " + str(args)
print "Params: " + str(params)
