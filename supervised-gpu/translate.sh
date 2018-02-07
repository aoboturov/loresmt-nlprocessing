#! /usr/bin/env bash

set -x
set -e

lines=`wc -l < /data/input.txt`
src=src
tgt=tgt
gpuid=$1    # 0
epochs=$2   # 3
layers=$3   # 2
rnn_size=$4 # 200
mosesdecoder=/model/mosesdecoder

# Randomize supervised input
shuf /data/parallel_corpus.txt > /model/parallel_corpus_shuffled.txt

# Split parallel corpus
cut -f 1 /model/parallel_corpus_shuffled.txt > /model/parallel.$src
cut -f 2 /model/parallel_corpus_shuffled.txt > /model/parallel.$tgt

# Tokenize data
$mosesdecoder/scripts/tokenizer/tokenizer.perl -q -threads 16 < /model/parallel.$src > /model/parallel.tok.$src
$mosesdecoder/scripts/tokenizer/tokenizer.perl -q -threads 16 < /model/parallel.$tgt > /model/parallel.tok.$tgt
$mosesdecoder/scripts/tokenizer/tokenizer.perl -q -threads 16 < /data/input.txt > /model/input.tok.$src

# Clean all corpora
$mosesdecoder/scripts/training/clean-corpus-n.perl /model/parallel.tok $src $tgt /model/parallel.tok.clean 1 80
/model/clean-corpus-monolingual.perl /model/input.tok.$src  /model/input.tok.clean.$src 1 80

# Join setntenses to produce better embeddings
cat /model/parallel.tok.clean.$src > /model/full.$src
cat /model/parallel.tok.clean.$tgt > /model/full.$tgt

# Train truecaser
$mosesdecoder/scripts/recaser/train-truecaser.perl -corpus /model/full.$src -model /model/corpus-truecase-model.$src
$mosesdecoder/scripts/recaser/train-truecaser.perl -corpus /model/full.$tgt -model /model/corpus-truecase-model.$tgt

# Apply truecaser
$mosesdecoder/scripts/recaser/truecase.perl -model /model/corpus-truecase-model.$src < /model/parallel.tok.clean.$src > /model/parallel.tok.clean.tc.$src
$mosesdecoder/scripts/recaser/truecase.perl -model /model/corpus-truecase-model.$tgt < /model/parallel.tok.clean.$tgt > /model/parallel.tok.clean.tc.$tgt
$mosesdecoder/scripts/recaser/truecase.perl -model /model/corpus-truecase-model.$src < /model/input.tok.clean.$src > /model/input.tok.clean.tc.$src

$mosesdecoder/scripts/recaser/truecase.perl -model /model/corpus-truecase-model.$src < /model/full.$src > /model/full.tc.$src
$mosesdecoder/scripts/recaser/truecase.perl -model /model/corpus-truecase-model.$tgt < /model/full.$tgt > /model/full.tc.$tgt

# Run FastText
fasttext skipgram -input /model/full.tc.$src -minCount 5 -epoch 10 -loss ns -thread 16 -dim 300 -output /model/embedding.ft.$src
rm /model/embedding.ft.$src.bin
fasttext skipgram -input /model/full.tc.$tgt -minCount 5 -epoch 10 -loss ns -thread 16 -dim 300 -output /model/embedding.ft.$tgt
rm /model/embedding.ft.$tgt.bin

# Train-Validation split
lines=`wc -l < /model/parallel.tok.clean.tc.$src`
lines_train=`python3 -c "print(int($lines*.95))"`
lines_val=`python3 -c "print($lines-$lines_train)"`

head -n$lines_train /model/parallel.tok.clean.tc.$src > /model/train.$src.txt
tail -n$lines_val   /model/parallel.tok.clean.tc.$src > /model/valid.$src.txt

head -n$lines_train /model/parallel.tok.clean.tc.$tgt > /model/train.$tgt.txt
tail -n$lines_val   /model/parallel.tok.clean.tc.$tgt > /model/valid.$tgt.txt

# OpenNMT
opennmt=/model/OpenNMT-py

# PreProcess
python3 $opennmt/preprocess.py \
  -train_src /model/train.$src.txt \
  -train_tgt /model/train.$tgt.txt \
  -valid_src /model/valid.$src.txt \
  -valid_tgt /model/valid.$tgt.txt \
  -save_data /model/data

# Embedding
python3 /model/embeddings_to_torch.py -emb_file /model/embedding.ft.$src.vec \
  -dict_file /model/data.vocab.pt \
  -output_file /model/embeddings.$src \
  -gpuid $gpuid

python3 /model/embeddings_to_torch.py -emb_file /model/embedding.ft.$tgt.vec \
  -dict_file /model/data.vocab.pt \
  -output_file /model/embeddings.$tgt \
  -gpuid $gpuid

# Train Standard model
python3 $opennmt/train.py -save_model /model/model \
  -batch_size 64 \
  -layers $layers \
  -rnn_size $rnn_size \
  -word_vec_size 300 \
  -pre_word_vecs_enc /model/embeddings.$src.enc.pt \
  -pre_word_vecs_dec /model/embeddings.$tgt.dec.pt \
  -learning_rate 0.001 \
  -optim adam \
  -epochs $epochs \
  -gpuid $gpuid \
  -data /model/data

# Prediction
python3 $opennmt/translate.py -model /model/model_*_e$epochs.pt \
  -src /model/input.tok.clean.tc.$src \
  -replace_unk \
  -gpu $gpuid \
  -output /model/output.tok.clean.tc.$tgt \
  -verbose

# Apply detruecaser
$mosesdecoder/scripts/recaser/detruecase.perl < /model/output.tok.clean.tc.$tgt > /model/output.tok.$tgt

# Detokenize
cat /model/output.tok.$tgt > /output/output.txt

echo "DONE"

