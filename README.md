# **Maximising Kidney Glomeruli Segmentation using Minimal Labels via Self-Supervision**

**Zeeshan Nisar, Thomas Lampert — Computers in Biology and Medicine, 2025**

## Abstract
<div style="text-align: left">
Histopathology, the microscopic examination of tissue samples, is essential for disease diagnosis and prognosis. 
Accurate segmentation and identification of key regions in histopathology images are crucial for developing automated 
solutions. However, state-of-art deep learning segmentation methods like UNet require extensive labels, which is both 
costly and time-consuming process, particularly when dealing with multiple stainings. To mitigate this, various 
multi-stain segmentation methods such as UDAGAN have been developed, which reduce the need for labels by requiring only 
one (source) stain to be labelled. Nonetheless, obtaining source stain labels can still be challenging, and segmentation 
models fail when they are unavailable. This article shows that through self-supervised pre-training&mdash;including 
SimCLR, BYOL, and a novel approach, HR-CS-CO&mdash;the performance of these segmentation methods (UNet, and UDAGAN) 
can be retained even with 95% fewer labels. Notably, with self-supervised pre-training and using only 5% labels, the 
performance drops are minimal: 5.9% for UNet and 6.2% for UDAGAN, compared to their respective fully supervised coun-
terparts (without pre-training, using 100% labels). Furthermore, these findings are shown to generalise beyond their 
training distribution to public benchmark datasets.
</div>

## Highlights:
> This repository contains:
> - ✅ Complete codebase for pre-training the self-supervised models (SimCLR, BYOL, HR-CS-CO) from scratch on any custom dataset.
> - ✅ Pre-trained weights for all self-supervised models, developed using our in-house renal pathology dataset (provided by Hannover Medical School). See paper for more details
> - ✅ Detailed instructions for loading and utilising the pre-trained model weights. 
> - ✅ Full code for training baseline and fine-tuned segmentation models (UNet and UDAGAN) on any external kidney glomeruli dataset, supporting reproduction of published results and generalisation study.

## Self-Supervised Pre-training:

For pre-training, the UNet encoder is used as the default backbone. However, the codebase is flexible and supports any 
state-of-the-art CNN or transformer-based deep learning architecture as a backbone. To accelerate training, distributed 
multi-GPU support is implemented using ```TensorFlow v2```. To set up the exact similar environment, install all 
dependencies with:
```
pip install -r requirements.txt
```
**Dataset Structure:**
Organize your dataset as shown below, supporting multiple domains with varying numbers of images:
```
____SSL
    ├──random_patches/colour
       ├──train
          ├──domain_1
             ├──aa.png
                  :                
             ├──zz.png
              :
              :
          ├──domain_N
             ├──aa.png
                  :                 
             ├──zz.png

       ├──validation
          ├──domain_1
             ├──aa.png
                  :                
             ├──zz.png
              :
              :
          ├──domain_N
             ├──aa.png
                  :                 
             ├──zz.png

```

**Stain Codes Reference:**
In this repository, different stain codes are used to represent various stainings in the dataset:

> - 02: PSA stain
> - 03: Jones HE
> - 32: Sirius Red
> - 16: CD68
> - 39: CD39

**Training Scripts:** 

Once dataset is prepared, use the following scripts for pre-training:

> - **SimCLR:** ./train_simclr.sh (pre_training/ssl/simclr/slurm)
> - **BYOL:** ./train_byol.sh (pre_training/ssl/byol/slurm)
> - **HR-CS-CO:**
  >   - Run ./train_contrastive_learning.sh first.
  >   - After completion, run ./train_cross_stain_prediction.sh (both in pre_training/ssl/hr-cs-co/slurm)


## Pre-trained Model Weights:
If you prefer to bypass the pre-training step, the pre-trained model weights for all self-supervised models, trained on our in-house renal pathology dataset, are available for download: [➡️ Download Pre-trained Weights](https://seafile.unistra.fr/d/8a7fd71081644d2f86dc/).
After downloading, use the following scripts to load and integrate them into any of the desired downstream tasks, such as classification or segmentation, with a particular focus on renal pathology datasets.
> - **SimCLR:** ./load_simclr_weights.sh (available in pre_training/ssl_pretrained_models/slurm)
> - **BYOL:** ./load_byol_weights.sh (available in pre_training/ssl_pretrained_models/slurm)
> - **HR-CS-CO:** ./load_hrcsco_weights.sh (available in pre_training/ssl_pretrained_models/slurm)

## Downstream Tasks Employed in Paper / Reproducing Results:
As detailed in the paper, pre-trained weights were applied to two segmentation-based downstream tasks, each evaluated with varying proportions of labelled data (1%, 5%, 10%, and 100%). The following scripts enable the reproduction of the reported results:
> - **Kidney Glomeruli Segmentation with UNet:** 
>   - Use labels from all stains.
>   - Training scripts for respective baseline and finetune models are available in ```downstream_tasks/unet/slurm```. For different stains, configuration files are updated with different staincode.
>   - This setup was also used for generalisation study on public benchmark datasets (HuBMAP, KPIs)


> - **Kidney Glomeruli Segmentation using UDAGAN:** 
>   - Use labels from only one source (PAS, staincode:02) stain.
>   - Training and fine-tuning scripts are available in ```downstream_tasks/udagan/slurm```
