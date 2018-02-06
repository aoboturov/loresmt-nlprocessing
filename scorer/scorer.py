#!/usr/bin/env python3

import nltk
import sys

from bleu import compute_bleu
from nltk.tokenize import word_tokenize

def main():
    """ Computes the BLEU score for input and output corpora
    Args:
      sys.argv[1]: the reference corpus.
      sys.argv[2]: the translation output.
    Returns:
      prints the output of the `bleu.py` script.
    """
    ref_file = sys.argv[1]
    tra_file = sys.argv[2]
    print('Reference corpus: ', ref_file)
    print('Translation: ', tra_file)
    with open(ref_file, encoding='utf-8') as ref_fis, open(tra_file, encoding='utf-8') as tra_fis:
        ref_tokenized = list(map(lambda s: [list(word_tokenize(s))], ref_fis.readlines()))
        tra_tokenized = list(map(word_tokenize, tra_fis.readlines()))

        print(compute_bleu(ref_tokenized, tra_tokenized))


if __name__ == '__main__':
    nltk.download('punkt')
    main()
