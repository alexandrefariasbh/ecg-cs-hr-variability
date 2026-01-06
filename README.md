# ECG Compressed Sensing under Heart Rate Variability

This repository contains the MATLAB source code used in the study:

**“Comparative Analysis of the Quality of ECG Signal Reconstruction by
Compressed Sensing at Different Heart Rates.”**

The code implements a reproducible experimental pipeline for evaluating
compressed sensing (CS) reconstruction performance of ECG signals under
controlled heart rate conditions.

---

## Overview

The repository provides scripts for:

- ECG signal generation and segmentation
- Sparse representation using wavelet transforms
- Compressed sensing acquisition using Bernoulli sensing matrices
- Signal reconstruction using classical and deep-learning-based algorithms
- Performance evaluation using PRD and SNR metrics
- Statistical analysis using three-way ANOVA and Tukey post-hoc tests

---

## Algorithms Included

- Orthogonal Matching Pursuit (OMP)
- Basis Pursuit (BP)
- Compressive Sampling Matching Pursuit (CoSaMP)
- Subspace Pursuit (SP)
- Iteratively Reweighted Least Squares (IRLS)
- Block Sparse Bayesian Learning (BSBL-FM)
- CSNet (deep learning-based reconstruction)

All algorithms follow their standard implementations, without architectural
modifications, to ensure fair comparison.

---

## Data Availability

ECG signals are generated using the HS15 ECG simulator and publicly available
datasets (MIT-BIH Arrhythmia Database).

Due to licensing restrictions, raw ECG signals are **not redistributed** in
this repository. All scripts required to reproduce the experiments and
evaluation pipeline are provided.

---

## Requirements

- MATLAB R2023b (or compatible)
- Signal Processing Toolbox
- Wavelet Toolbox

---
