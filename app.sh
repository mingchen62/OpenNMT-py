#!/bin/bash
~/miniconda2/bin/python app.py -model saved_models/im2text-hw-model_acc_96.75_ppl_1.16_e13.pt  -data_type img -replace_unk -verbose -n_best 3 -batch_size 1 -gpu 0 -coverage_penalty wu -alpha 0.01 -beta 0.001
