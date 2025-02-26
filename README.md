# Description

This repository contains the data and scripts needed to generate Figure 5, Table A.2, Figure A.6, and Figure B.7. Please note that these MTGs fit a young male gymnast. 

M Millard, A.L. Emonds, M Harant, K Mombaur, A reduced muscle model and planar musculoskeletal model fit for the simulation of whole-body movements, Journal of Biomechanics, Volume 89, 2019, Pages 11-20, ISSN 0021-9290, https://doi.org/10.1016/j.jbiomech.2019.04.004.

# Generating Publication Figures

To generate the figures in Millard et al:

- Figure 5: 
    - run matlab/main_generateResultsFigure.m
    - Input: csv files from the data folder
    - Output: figures/fig1ab2ab.pdf
- Figure A.6: 
    - run matlab/main_generateSupplementaryMaterialFigures.m
    - Input: csv files from the mtg folder
    - Output: figures/fig_mtg_1.pdf to figures/fig_mtg_2.pdf     
- Figure B.7: 
    - run matlab/main_generateFittingAppendixFigure.m
    - Input: csv files from the fittingExample folder
    - Output: figures/figAppExample.pdf

# Generating Muscle Torque Generator (MTG) Tables


If for some reason you cannot use the C++ implementation in RBDL, you may want to implement the MTG curves as tables and linearly interpolate the values. While this approach is quick to develop, the resulting curves will only be continuous to the first derivative: this is fine for forward simulation but insufficient for gradient-based optimization. If you are using gradient-based optimization you will need to implement the 5th order Bezier curves that are used in RBDL or use some similar approach.

To generate the necessary tables:

- Run matlab/main_generateMuscleTorqueGeneratorCurveTables.m
- Look at figures/fig_mtg_curveTables.pdf
    - The original curves with 1000 samples are shown in grey
    - The downsamled curves with 100 samples are shown in color
- Use the tables in curvesTables
    - mtgNamesParameters.csv: this table contains
        - MTG name 
        - maximum isometric torque (tiso(Nm))
        - maximum shortening velocity (omegaMax(rad/s))
        - column number: applies only to the csv files in curveTables
    - jointAngle.csv : contains the joint angle sampling
    - jointAngularVelocity.csv : contains the joint angle sampling    
    - activeTorqueAngleMultiplier.csv : contains the values of the active torque multiplier for each MTG. Interpolate values using jointAngle.csv 
    - passiveTorqueAngleMultiplier.csv : contains the values of the passive torque multiplier for each MTG. Interpolate values using jointAngle.csv 
    - torqueVelocityMultiplier.csv : contains the values of the torque velocity multiplier for each MTG. Interpolate values using jointAngularVelocity.csv 
