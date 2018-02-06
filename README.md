# Supplement for the submission to the LoResMT workshop from the NL Processing team

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
./scorer/scorer.py data/En-Ko/test_output.txt data/En-Ko/test_input.txt
```
