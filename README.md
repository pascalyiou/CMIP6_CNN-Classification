# CMIP6_CNN-Classification
Classification of CMIP6 models with SLP fields

This suite of scripts aims to classify SLP fields from the entire CMIP6 archive. The goal is to recognize a model from a daily map of SLP. The classification is performed with a convolutional neural network with 256 neurons. It uses tensorflow in R.

This should be downloaded from: https://github.com/pascalyiou/CMIP6_CNN-Classification

The codes have been developed by Pascal Yiou (LSCE, IPSL, U Paris Saclay). The codes are distributed "as is" under a CeCILL license:
http://www.cecill.info/
They can be downloaded and used for free for academic purposes.
For commercial uses, please contact Pascal Yiou (pascal.yiou@lsce.ipsl.fr)

The scripts assume that the CMIP6 files are stored with a standard architecture.

The suite comes with several scripts:

1. file preparation. Extraction of daily SLP from historical runs in CMIP6. bash scripts. Those scripts work on spiritx (the computing cluster at IPSL).
CMIP6_psl_file-prepare_v2.sh: extracts SLP over the North Atlantic region, between 1950 and 2000. This script is based on cdo commands.
CMIP6-all_psl_file-prepare.sh: loop over all CMIP6 models

2. Classification of models. R script with tensorflow commands. The script classifies up to NMOD models among a predefined list. This script works on hal (the GPU cluster at IPSL).
CMIP6_tensorflow-classif_v1.R

The REDAME.txt file outlines the whole procedure, from data preparation to classification, and figure production.

Important note: a version > 4.4.1 of R needs to be installed. In R, the libraries linked to tensorflow need to be installed (keras3, tensorflow).

How does it work? On spiritx (the IPSL computing cluster), first prepare the input files with
CMIP6-all_psl_file-prepare.sh
This can take up to 48h on spiritx.

Then install the right version of R: module load R/4.4.1 tensorflow/2.15.0
Then do a classification with: CMIP6_tensorflow-classif_v1.R. This works better on hal.ipsl.fr (the GPU cluster at IPSL). The bash file CMIP6_classif-v1.sh launches 4 classifications (one by season).

This takes ~10mn. The script does 20 "random" classifications to test the stability of algorithm. By default, the program learns on ~20 years of data and verifies on the remaining years. Seasons have to be analyzed separately.
