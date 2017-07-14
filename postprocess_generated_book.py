# -*- coding: utf-8 -*-
# Load LSTM network and generate text
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("text_file", type=str, help="The file containing the generated text")
parser.add_argument("data_file", type=str, help="The file containing the original text")
parser.add_argument("output_file", type=str, help="The output file")
parser.add_argument("-N", "--n-words", type=int, default=1000, help="Number of words to generate per epoch/chapter")

args = parser.parse_args()

import sys
import numpy
import os.path
import re

def dumb_to_smart_quotes(string):
    """Takes a string and returns it with dumb quotes, single and double,
    replaced by smart quotes. Accounts for the possibility of HTML tags
    within the string."""

    # Find dumb double quotes coming directly after letters or punctuation,
    # and replace them with right double quotes.
    string = re.sub(r'([a-zA-Z0-9.,?!;:\'\"])"', ur'\1”', string)
    # Find any remaining dumb double quotes and replace them with
    # left double quotes.
    string = string.replace('"', u'“')
    # Reverse: Find any SMART quotes that have been (mistakenly) placed around HTML
    # attributes (following =) and replace them with dumb quotes.
    string = re.sub(ur'=“(.*?)”', ur'="\1"', string)
    # Follow the same process with dumb/smart single quotes
    string = re.sub(r"([a-zA-Z0-9.,?!;:\"\'])'", ur'\1’', string)
    string = string.replace("'", u'‘')
    string = re.sub(ur'=‘(.*?)’', r"='\1'", string)
    return string

text = open(args.text_file, "r+").read()
length = len(open(args.data_file, "r+").read())

def find_end_position(char, text):
    # Prevent finding position at specific abbreviations.
    bad_endings = [ "mr", "mrs", "ms", "dr" ]
    ending_ok = False
    end_pos = len(text)
    while not ending_ok:
        end_pos = text.rfind(char, 0, end_pos)+1
        end_text = text[0:end_pos]
        ending_ok = True;
        for ending in bad_endings:
            if (end_text.endswith(" " + ending + ".")):
                print "Found bad ending: " + ending
                ending_ok = False
                end_pos -= 1
                break

    # If next char is ending quote, stop there instead.
    if (end_pos != len(text)-1):
        if (text[end_pos] == "\"" or text[end_pos] == "'"):
             end_pos += 1
    
    return end_pos

# Find end position and re-build the text.
end_pos =              find_end_position(".", text)
end_pos = max(end_pos, find_end_position("?", text))
end_pos = max(end_pos, find_end_position("!", text))

start_pos = end_pos - length

# Replace dumb quotes to smart quotes
output_text = dumb_to_smart_quotes(text[start_pos:end_pos])

# Replace double-spaces with one space + one non-breaking space
output_text = re.sub(r'  ', ur' '+unichr(160), output_text)

import codecs
codecs.open(args.output_file, "w+", "utf-8").write(output_text)

print "First-last position: " + str(start_pos) + "-" + str(end_pos)
print "First character: [" + text[0] + "]"
print "Percentage removed (first epoch): " + str(round(start_pos / float(args.n_words) * 100.0)) + "%"
print "Percentage removed (last epoch): " + str(round((len(text)-end_pos) / float(args.n_words) * 100.0)) + "%"
