# Citation
Please cite this code and data. 

<a href="https://doi.org/10.5281/zenodo.7746122"><img src="https://zenodo.org/badge/DOI/10.5281/zenodo.7746122.svg" alt="DOI"></a>


```
Zika, Ondrej, Wiech, Katja, Reinecke, Andrea, Browning, Michael, & Schuck, Nicolas. (2023). Trait anxiety is associated with hidden state inference during aversive reversal learning (v1.8.0). Zenodo. https://doi.org/10.5281/zenodo.7746122
```
# Description

This repo is associated with the following paper:

> *Trait anxiety is associated with hidden state inference during aversive reversal learning* (2023). O Zika, K Wiech, A Reinecke, M Browning, NW Schuck - Nature Communications, https://doi.org/10.1101/2022.04.01.483303

It contains **data** and **scripts** to reproduce the results in the main text.

# Instructions

The main analysis scripts are organised in a single `r-markdown` notebook. The computational environment can be reproduced using the `renv` package for R environments.

**Requirements**
- R 3.6.0+
- RStudio (or other r-markdown editor)
- set up SSH key with github.com (see [instructions here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account))

**Scripts tested on**

Operating systems: `Ubuntu 18.04.6 LTS`,  `macOS Catalina 10.15.7`, `macOS Monterey 12.3.1`
R versions: `3.6.0 (2019-04-26)`, `4.0.0 (2020-04-24)`, `4.1.2 (2021-11-01)`

**Expected runtime**
- less than 2 minutes on a normal computer

**Instructions**
1. Glone git repo (this will create a folder with all scripts and data called `trait-anxiety-and-state-inference-zika2022`)

```bash
git clone  git@github.com:ozika/state-inference-models-zika2022.git
```

2. In RStudio open `scripts/stats_main.Rmd` (or `stats_supp.Rmd`)
3. Run. The script should load the `renv.lock` file and use it to download and install all necessary packages.
4. To check that all worked, the script should create a `output/figures/` folder and print the paper figures into it.

# Models

MATLAB code for models used in the main text is in a separate repo. Please visit [ozika/state-inference-models-zika2022](https://github.com/ozika/state-inference-models-zika2022) for instructions.

# Licence
Code: GNU GPLv3 (see LICENSE.md)  
Data: CC BY-NC 4.0 International license [see here](https://creativecommons.org/licenses/by-nc/4.0/)
