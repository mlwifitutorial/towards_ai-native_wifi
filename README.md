# Machine Learning and Wi-Fi: Unveiling the Path Toward AI/ML-Native IEEE 802.11 Networks

Materials of the paper "Machine Learning and Wi-Fi: Unveiling the Path Toward AI/ML-Native IEEE 802.11 Networks"

''BibTeX'' citation:

```
@article{wilhelmi2024machine,
  author={Wilhelmi, Francesc and Szott, Szymon and Kosek-Szott, Katarzyna and Bellalta, Boris},
  journal={IEEE Communications Magazine}, 
  title={Machine Learning and Wi-Fi: Unveiling the Path Toward AI/ML-Native IEEE 802.11 Networks}, 
  year={2024},
  volume={},
  number={},
  pages={1-7},
  keywords={Wireless fidelity;Artificial intelligence;IEEE 802.11 Standard;Computational modeling;3GPP;Costs;Standards;Data models;Protocols;Computer architecture},
  doi={10.1109/MCOM.001.2400292}}
```

## Table of Contents
- [Authors](#authors)
- [Publication's abstract](#abstract)
- [Repository description](#repository-description)
- [Usage](#usage)

## Authors
* [Francesc Wilhelmi](https://fwilhelmi.github.io/)
* [Szymon Szott](https://szymonszott.github.io/) 
* [Katarzyna Kosek-Szott](https://home.agh.edu.pl/~kks/)
* [Boris Bellalta](https://www.upf.edu/web/boris-bellalta)

## Abstract
Artificial intelligence (AI) and machine learning (ML) are nowadays mature technologies considered essential for driving the evolution of future communication systems. Simultaneously, Wi-Fi technology has constantly evolved over the past three decades and incorporated new features generation after generation, thus contributing to increased complexity. As such, researchers have observed that AI/ML functionalities may be required to address the upcoming Wi-Fi challenges that will be otherwise difficult to solve with traditional approaches. This paper discusses the role of AI/ML in current and future Wi-Fi networks and depicts the ways forward. A roadmap towards AI/ML-native Wi-Fi, key challenges, standardization efforts, and major enablers are also discussed. An exemplary use-case scenario is provided to showcase the potential of AI/ML in Wi-Fi at different adoption stages.

## Repository description
This repository contains the necessary files to generate the results included in the "Machine Learning &amp; Wi-Fi: Unveiling the Path towards AI-native IEEE 802.11 Networks" publication, which have been obtained using the open-source [Komondor simulator](https://github.com/wn-upf/Komondor). The files included in this repository are:

1. Figures: figures generated from the simulations done.
2. Komondor input: inputs used for generating the results with Komondor.
3. Komondor output: outputs obtained from Komondor.
4. Post-processing scripts: Matlab scripts used to process the simulation results and generate the figure.
5. machine_learning_and_wi-fi.pdf: Pre-print version of the paper in PDF.
   
## Usage

To reproduce the experiments done in this paper, select the files in the "Komondor input" folder and copy them into the input folder of Komondor (see simulator's running instructions [here](https://github.com/wn-upf/Komondor)). Then, run the different scripts (e.g., "Komondor input/script_aiml_magazine.sh").

Once simulations are done, use the scripts in "/Post-processing scripts" in Matlab.
