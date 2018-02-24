# Supplement for the submission to the LoResMT workshop from the NL Processing team
[Workshop on Technologies for MT of Low Resource Languages (LoResMT)](https://sites.google.com/view/loresmt)

## Technical setup
One would need an LTS 16.04 Ubuntu in order to run this set up.

### Docker configuration
Docker-CE has to be installed on the server running ML models training.
The installation instructions could be found in [the official documentation](https://docs.docker.com/install/linux/docker-ce/ubuntu/).

### NVIDIA Drivers set up
One would have to install NVIDIA Drivers as it is described in [the instructions](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1604&target_type=debnetwork).

### NVIDIA-Docker runtime
[The runtime](https://github.com/NVIDIA/nvidia-docker) has to be installed in order to run dockerized images.

## Translation evaluation
To run the evaluation one has to execute the scorer script:

```
./scorer/scorer.py data/En-Ko/ref_output.txt data/En-Ko/translation_output.txt
```

## Run training
```
docker run \
    -e INPUT="/data/input.txt" \
    -e OUTPUT="/output/output.txt" \
    -v <input_file>:/data/input.txt:ro \
    -v <corpus1.txt>:/data/corpus1.txt:ro \
    -v <corpus2.txt>:/data/corpus2.txt:ro \
    -v <parallel_corpus.txt>:/data/parallel_corpus.txt:ro \
    -v <output_dir>:/output:rw \
    -v <workspace>:/workspace_<runid> \
    --workdir /workspace_<runid> \
    --network=none \
    --memory=8g \
    --cpuset-cpus=0-4 \
    --pids-limit=530 \
    --runtime=nvidia \
    --ipc=host \
    <image> <entry_point>
```

## Results
### Supervised model description
A default [OpenNMT-py](https://github.com/OpenNMT/OpenNMT-py) Encoder-Decoder architecture with `N_SRC` and `N_TGT` parameters specifying vocabulary sizes for *src* and *tgt* languages respectively.

```
NMTModel(
  (encoder): RNNEncoder(
    (embeddings): Embeddings(
      (make_embedding): Sequential(
        (emb_luts): Elementwise(
          (0): Embedding(N_SRC, 300, padding_idx=1)
        )
      )
    )
    (rnn): LSTM(300, 400, num_layers=3, dropout=0.3)
  )
  (decoder): InputFeedRNNDecoder(
    (embeddings): Embeddings(
      (make_embedding): Sequential(
        (emb_luts): Elementwise(
          (0): Embedding(N_TGT, 300, padding_idx=1)
        )
      )
    )
    (dropout): Dropout(p=0.3)
    (rnn): StackedLSTM(
      (dropout): Dropout(p=0.3)
      (layers): ModuleList(
        (0): LSTMCell(700, 400)
        (1): LSTMCell(400, 400)
        (2): LSTMCell(400, 400)
      )
    )
    (attn): GlobalAttention(
      (linear_in): Linear(in_features=400, out_features=400)
      (linear_out): Linear(in_features=800, out_features=400)
      (sm): Softmax()
      (tanh): Tanh()
    )
  )
  (generator): Sequential(
    (0): Linear(in_features=400, out_features=N_TGT)
    (1): LogSoftmax()
  )
)
```

### Supervised model trained on a 50K parallel corpus
```
docker run -it \
    -v /LoResMT/Lv-En/test_parallel_corpus.txt:/data/parallel_corpus.txt:ro \
    -v /LoResMT/Lv-En/test_input.txt:/data/input.txt:ro \
    -v /LoResMT/output:/output:rw \
    --memory=8g \
    --runtime=nvidia \
    kwakinalabs/deephack-finals-v1
```

| Pair  | Score   |  Description                                                  |
|-------|---------|---------------------------------------------------------------|
| En-Ru | 0.02123 | IN -> OUT                                                     |
| En-Ru | 0.10783 | `supervised-gpu` - GPU, 3 RNN layers, RNN size 400, 1 epoch   |
| En-Ru | 0.25747 | `supervised-gpu` - GPU, 3 RNN layers, RNN size 400, 5 epochs  |
| En-Ru | 0.28915 | `supervised-gpu` - GPU, 3 RNN layers, RNN size 400, 10 epochs |
| Lv-En | 0.02075 | IN -> OUT                                                     |
| Lv-En | 0.01142 | `supervised-gpu` - GPU, 3 RNN layers, RNN size 400, 1 epoch   |
| Lv-En | 0.04766 | `supervised-gpu` - GPU, 3 RNN layers, RNN size 400, 5 epochs  |
| Lv-En | 0.05756 | `supervised-gpu` - GPU, 3 RNN layers, RNN size 400, 10 epochs |
| En-Ko | 0.02759 | IN -> OUT                                                     |
| En-Ko | 0.11179 | `supervised-gpu` - GPU, 3 RNN layers, RNN size 400, 1 epoch   |
| En-Ko | 0.22945 | `supervised-gpu` - GPU, 3 RNN layers, RNN size 400, 5 epochs  |
| En-Ko | 0.25418 | `supervised-gpu` - GPU, 3 RNN layers, RNN size 400, 10 epochs |

### UNMT - as described in the [Unsupervised Machine Translation Using Monolingual Corpora Only](https://openreview.net/forum?id=rkYTTf-AZ)
```
docker run -it \
    -v /LoResMT/Lv-En/test_parallel_corpus.txt:/data/parallel_corpus.txt:ro \
    -v /LoResMT/Lv-En/test_input.txt:/data/input.txt:ro \
    -v /LoResMT/Lv-En/test_corpus1.txt:/data/corpus1.txt:ro \
    -v /LoResMT/Lv-En/test_corpus2.txt:/data/corpus2.txt:ro \
    -v /LoResMT/output:/output:rw \
    --memory=8g \
    --runtime=nvidia \
    kwakinalabs/deephack-finals-v2
```

### UNMT model description
An architecture of Encoder-Decoder with attention where the embedding dimension for encoder and decoder is both `N_BIDI` because UNMT uses a single common dictionary.
It is a combination of sizes of `N_SRC` and `N_TGT`, which are specifying vocabulary sizes for *src* and *tgt* languages respectively.

```
UNMT(
  (encoder): EncoderRNN(
    (embedding): Embedding(N_BIDI, 300)
    (rnn): LSTM(300, 50, num_layers=3, dropout=0.1, bidirectional=True)
  )
  (decoder): AttnDecoderRNN(
    (embedding): Embedding(N_BIDI, 300)
    (attn): Attn(
      (attn): Linear(in_features=100, out_features=100)
      (sm): Softmax()
      (out): Linear(in_features=200, out_features=100)
      (tanh): Tanh()
    )
    (rnn): LSTM(400, 100, num_layers=3, dropout=0.1)
  )
  (generator): Generator(
    (out): Linear(in_features=100, out_features=N_BIDI)
    (sm): LogSoftmax()
  )
)
```

### UNMT discriminator description
Discriminator takes the latent space size `LS_SIZE` as the input dimension to infer whether it could be fooled to predict the language of the output produced by the embedding.

```
(discriminator): Discriminator(
  (layers): ModuleList(
    (0): Linear(in_features=LS_SIZE, out_features=1024)
    (1): Linear(in_features=1024, out_features=1024)
    (2): Linear(in_features=1024, out_features=1024)
  )
  (out): Linear(in_features=1024, out_features=1)
)
```
