#! /usr/bin/env bash

set -x
set -e

export PYTHONIOENCODING=utf8

lines=`wc -l < /data/input.txt`
src=src
tgt=tgt
epochs=$1               # 5
layers=$2               # 3
rnn_size=$3             # 400
fasttext_epochs=$4      # 20
unsupervised_epochs=$5  # 2
mosesdecoder=/model/mosesdecoder
muse=/model/MUSE
unmt=/model/UNMT

# Randomize supervised input
shuf /data/parallel_corpus.txt > /model/parallel_corpus_shuffled.txt

# Split parallel corpus
cut -f 1 /model/parallel_corpus_shuffled.txt > /model/parallel.$src
cut -f 2 /model/parallel_corpus_shuffled.txt > /model/parallel.$tgt

# Tokenize data
$mosesdecoder/scripts/tokenizer/tokenizer.perl -q -threads 16 < /model/parallel.$src > /model/parallel.tok.$src
$mosesdecoder/scripts/tokenizer/tokenizer.perl -q -threads 16 < /model/parallel.$tgt > /model/parallel.tok.$tgt
$mosesdecoder/scripts/tokenizer/tokenizer.perl -q -threads 16 < /data/corpus1.txt > /model/corpus.tok.$src
$mosesdecoder/scripts/tokenizer/tokenizer.perl -q -threads 16 < /data/corpus2.txt > /model/corpus.tok.$tgt
$mosesdecoder/scripts/tokenizer/tokenizer.perl -q -threads 16 < /data/input.txt > /model/input.tok.$src

# Clean all corpora
$mosesdecoder/scripts/training/clean-corpus-n.perl /model/parallel.tok $src $tgt /model/parallel.tok.clean 1 80
/model/clean-corpus-monolingual.perl /model/corpus.tok.$src /model/corpus.tok.clean.$src 1 80
/model/clean-corpus-monolingual.perl /model/corpus.tok.$tgt /model/corpus.tok.clean.$tgt 1 80
/model/clean-corpus-monolingual.perl /model/input.tok.$src  /model/input.tok.clean.$src 1 80

# Join setntenses to produce better embeddings
cat /model/parallel.tok.clean.$src /model/corpus.tok.clean.$src > /model/full.$src
cat /model/parallel.tok.clean.$tgt /model/corpus.tok.clean.$tgt > /model/full.$tgt

# Train truecaser
$mosesdecoder/scripts/recaser/train-truecaser.perl -corpus /model/full.$src -model /model/corpus-truecase-model.$src
$mosesdecoder/scripts/recaser/train-truecaser.perl -corpus /model/full.$tgt -model /model/corpus-truecase-model.$tgt

# Apply truecaser
$mosesdecoder/scripts/recaser/truecase.perl -model /model/corpus-truecase-model.$src < /model/parallel.tok.clean.$src > /model/parallel.tok.clean.tc.$src
$mosesdecoder/scripts/recaser/truecase.perl -model /model/corpus-truecase-model.$tgt < /model/parallel.tok.clean.$tgt > /model/parallel.tok.clean.tc.$tgt
$mosesdecoder/scripts/recaser/truecase.perl -model /model/corpus-truecase-model.$src < /model/corpus.tok.clean.$src > /model/corpus.tok.clean.tc.$src
$mosesdecoder/scripts/recaser/truecase.perl -model /model/corpus-truecase-model.$tgt < /model/corpus.tok.clean.$tgt > /model/corpus.tok.clean.tc.$tgt
$mosesdecoder/scripts/recaser/truecase.perl -model /model/corpus-truecase-model.$src < /model/input.tok.clean.$src > /model/input.tok.clean.tc.$src

$mosesdecoder/scripts/recaser/truecase.perl -model /model/corpus-truecase-model.$src < /model/full.$src > /model/full.tc.$src
$mosesdecoder/scripts/recaser/truecase.perl -model /model/corpus-truecase-model.$tgt < /model/full.$tgt > /model/full.tc.$tgt

# Run FastText
fasttext skipgram -input /model/full.tc.$src -minCount 2 -epoch $fasttext_epochs -loss ns -thread 16 -dim 300 -output /model/embedding.ft.$src -neg 10
rm /model/embedding.ft.$src.bin
fasttext skipgram -input /model/full.tc.$tgt -minCount 2 -epoch $fasttext_epochs -loss ns -thread 16 -dim 300 -output /model/embedding.ft.$tgt -neg 10
rm /model/embedding.ft.$tgt.bin

# Train model
python3 $unmt/train.py \
    -src_lang $src \
    -tgt_lang $tgt \
    -train_src_mono /model/corpus.tok.clean.tc.$src \
    -train_tgt_mono /model/corpus.tok.clean.tc.$tgt \
    -train_src_bi /model/parallel.tok.clean.tc.$src \
    -train_tgt_bi /model/parallel.tok.clean.tc.$tgt \
    -src_embeddings /model/embedding.ft.$src.vec \
    -tgt_embeddings /model/embedding.ft.$tgt.vec \
    -src_vocabulary /model/src.pickle \
    -tgt_vocabulary /model/tgt.pickle \
    -all_vocabulary /model/all.pickle \
    -layers $layers \
    -rnn_size $rnn_size \
    -src_vocab_size 40000 \
    -tgt_vocab_size 40000 \
    -print_every 100 \
    -batch_size 32 \
    -save_every 200 \
    -discriminator_hidden_size 1024 \
    -unsupervised_epochs $unsupervised_epochs \
    -supervised_epochs $epochs \
    -save_model /model/model_unsupervised \
    -reset_vocabularies 0 \
    -enable_embedding_training 1

# Prediction
python3 $unmt/translate.py \
    -src_lang $src \
    -tgt_lang $tgt \
    -lang src \
    -model model_unsupervised.pt \
    -input /model/input.tok.clean.tc.$src \
    -output /model/output.tok.clean.tc.$tgt \
    -src_vocabulary /model/src.pickle \
    -tgt_vocabulary /model/tgt.pickle \
    -all_vocabulary /model/all.pickle

# Apply detruecaser
$mosesdecoder/scripts/recaser/detruecase.perl < /model/output.tok.clean.tc.$tgt > /model/output.tok.$tgt

# Detokenize
cat /model/output.tok.$tgt > /output/output.txt

echo "DONE"
