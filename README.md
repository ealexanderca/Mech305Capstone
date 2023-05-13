# Mech305Capstone
This is a repository that contains all the scripts and raw data from my 305 Capstone Project. The CAD folder contains the drawings of our proposed tension machine and the filament clamping plates. for more infromation refer to my post about it on my [website](ealexander.ca)

## LoadCellDAQ.ino
Arduino code that reads the force from the loadcell and sends it to the computer. modify this if using a different arduino or load cell system.

## Data_Recording.m
This script opens a UI that allows the user to tare, start and stop data recording, plot the force, and calculate the average slope at any point to determine instantaneous stress relaxation rate.

## port.m
A script that automatically detects what port a certain device is connected to depending on its properties.

## process.mlx
A script that
1. Imports the raw data from properly named CSVs.
2. crops the raw data and scales it to a percentage of peak force for easy comparison between tests.
3. fits a prony series to each of the data sets.
4. calculates the average prony series coefficients for each material.
5. calculates the steady state stress decay percentage of each material.
6. ranks the materials based on their steady state force.

##rankttest.m
A script that completes multiple T-tests on a set of samples to determine which ones rank higher and whether you can tell them apart.