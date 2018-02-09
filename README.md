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
| Lv-En | 0.02075 | IN -> OUT                                                     |
| Lv-En | 0.01142 | `supervised-gpu` - GPU, 3 RNN layers, RNN size 400, 1 epoch   |
| Lv-En | 0.04766 | `supervised-gpu` - GPU, 3 RNN layers, RNN size 400, 5 epochs  |
| En-Ko | 0.02759 | IN -> OUT                                                     |
| En-Ko | 0.11179 | `supervised-gpu` - GPU, 3 RNN layers, RNN size 400, 1 epoch   |
| En-Ko | 0.22945 | `supervised-gpu` - GPU, 3 RNN layers, RNN size 400, 5 epochs  |
| En-Ko | 0.22945 | `supervised-gpu` - GPU, 3 RNN layers, RNN size 400, 10 epochs |
