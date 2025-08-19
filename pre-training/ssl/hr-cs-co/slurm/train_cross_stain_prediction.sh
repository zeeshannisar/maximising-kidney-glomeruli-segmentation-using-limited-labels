#!/bin/bash

configuration_file=../pre_training/ssl/csco/code/configuration_files/CS.cfg
encoder_model=unet
repetition=rep1

cd ../code/

echo train_CS.py -c ${configuration_file} -m ${encoder_model} -r ${repetition}
python3 train_CS.py -c ${configuration_file} -m ${encoder_model} -r ${repetition}
