# EyeRespAnalysis

## Summer intern work on Federico's experiment videos of the mouse eye.

## Analysis work based on eye data processed by Michael's software on matlab.

This repository contains the functions, analysed datasets from each mouse and .mlx file managing the plots.

The simplest workflow is the following:
1. Run etGUI.m to analyse the pupil from the Michael's software.
2. Use getEyeData.m/getEyeData_dev.m to acess the filtered raw eye data.
3. Save them and, if you want to work on responses to direction gratings, use main_combineEyeDb.m.


Here is an overview of the the functions, analysis and datasets folders:
'analysis and plots' folder: contains mostly the .mlx live script files which organise the plots and the codes that generate them.
'functions' folder: contains the functions I've written.
'datasets' folder: these are processed datasets for distribution anaylsis to different stimuli and trace analysis to gratings which are saved from the live scripts' codes so you don't have to do that again.


For distributions of resposnes to different stimuli analysis:
1. The analysis was created on sparse_EyeDb_live.mlx (to sparse noise stimuli), spontaneous_EyeDb_live.mlx (to spontaneous stimuli), gratings_EyeDb_live.mlx (to direction gratings), and natMovies_EyeDb_live.mlx (to natural images).
2. These live scripts are rather simple: they all use the functions main_SparseNoise, main_gratings, main_natMovies, and main_spontaneous to extract filtered raw eye data from getEyeData_dev.m only in experiments with the specific stimuli present and they are saved as 'StimuliType_MouseID_EyeBallData.mat'.
3. The saved data then are classified as running vs stationary and histograms of running vs stationary are plotted in each live script.

For analysis on more specific responses to different direction gratings:
The processes are mainly organised in the combine_EyeDb_live.mlx, plot_comparison.mlx, and plot_comparison_std.mlx live script files.
To reproduce the same results, you can follow this process:
1.Open combine_EyeDb_live.mlx live script:
