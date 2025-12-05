# General QPCR Analysis Pipeline

This repository contains a general pipeline for analyzing qPCR data. The pipeline is designed to be flexible and can be adapted to various experimental designs and data formats.
Imported data must be in a tabular and long format

Example data:

|tissue |gene |mouse_id |treatment | ct_value| ct_ref|
|:------|:----|:--------|:---------|--------:|------:|
|liver  |IFNg |G1M1     |Ctrl      |   31.783| 17.305|
|liver  |IFNg |G1M2     |Ctrl      |   32.737| 18.328|
|liver  |IFNg |G1M3     |Ctrl      |   33.743| 18.524|
|liver  |IFNg |G1M4     |Ctrl      |   33.481| 18.678|
|liver  |IFNg |G1M5     |Ctrl      |   34.504| 18.201|
|liver  |IFNg |G2M1     |CL1       |   32.243| 18.715|

# Set Up

There are two scripts in this pipeline:
1_setup.R: This script is used to set up the environment and load necessary libraries.
2_analysis.R: This script contains the main analysis functions for running the linear mixed effect model and subsequent post-hoc analysis
