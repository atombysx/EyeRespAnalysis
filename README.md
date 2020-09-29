# EyeRespAnalysis

## Summer intern work on Federico's experiment videos of the mouse eye.

Analysis work based on eye data processed by Michael's software on matlab.

This repository contains the functions, analysed datasets from each mouse and .mlx file managing the plots.

## The Workflow of Data Processing
1. Run etGUI.m to analyse the pupil from the Michael's software.
2. Use getEyeData.m/getEyeData_dev.m to acess the filtered raw eye data.
3. Save them and, if you want to work on responses to direction gratings, use main_combineEyeDb.m.


## An overview of the the functions, analysis and datasets folders:
'analysis and plots' folder: contains mostly the .mlx live script files which organise the plots and the codes that generate them.
'functions' folder: contains the functions I've written.
'datasets' folder: these are processed datasets for distribution anaylsis to different stimuli and trace analysis to gratings which are saved from the live scripts' codes so you don't have to do that again.


###### **For distributions of resposnes to different stimuli analysis:**
1. The analysis was created on sparse_EyeDb_live.mlx (to sparse noise stimuli), spontaneous_EyeDb_live.mlx (to spontaneous stimuli), gratings_EyeDb_live.mlx (to direction gratings), and natMovies_EyeDb_live.mlx (to natural images).
2. These live scripts are rather simple: they all use the functions main_SparseNoise, main_gratings, main_natMovies, and main_spontaneous to extract filtered raw eye data from getEyeData_dev.m only in experiments with the specific stimuli present and they are saved as 'StimuliType_MouseID_EyeBallData.mat'.
3. The saved data then are classified as running vs stationary and histograms of running vs stationary are plotted in each live script.
4. Variables in the StimulusMouseID_X_EyeBallData.mat:
  - Variables as nx1 size cells (n is the number of experiments):
    - area: the real pupil sizes (in px)
    - pupil: pupil size/10th percentile
    - x: gauss filtered x coordinate minus mean
    - y: gauss filtered y coordinate minus mean
    - ts: timepoints
    - ball: running speed
 - combarea, combpupil, combx, comby, combts, combball: these are combined matrice from above cell arrays.

###### **For analysis on more specific responses to different direction gratings:**
The processes are mainly organised in the combine_EyeDb_live.mlx, plot_comparison.mlx, and plot_comparison_std.mlx live script files.
To reproduce the same results, you can follow this process:
1. Open combine_EyeDb_live.mlx live script:
 - Run main_combineEyeDb.m function on each FRXXX_X_eyeDb.m db cell array.
 - Save the corresponding variables into one 'MouseID_X_EyeBallData.mat' file.
 - This function also plots all the variables with all the raw traces in individual trials responding to different gratings.
 -At the bottom, there are some old plots for running speed distributions.
2. Variables in the 'MouseID_X_EyeBallData.mat' file:
  - They are first obtained from getEyeData_dev.m in the main_combineEyeDb.m function and processed with getStimulusSweepsLFR.m:
    -MouseID_X_pupil: the pupil size/10th percentile and, afterwards, is reduced from baseline.
    -MouseID_X_info: information of the experiments, from ppbox.infoPopulateTempLFR().
    -MouseID_X_eyeX: X coordinate gauss filtered minus mean (not reduced from baseline).
    -MouseID_X_eyeY: Y coordinate gauss filtered minus mean (not reduced from baseline).
    -MouseID_X_deyeX: X coordinate gauss filtered minus mean and reduced from baseline afterwards.
    -MouseID_X_deyeY: Y coordinate gauss filtered minus mean and reduced from baseline afterwards.
    -MouseID_X_ball: running speed obtained from getRunningSpeed() and processed with getStimulusSweepsLFR().
    -MouseID_X_dball: running speed same as above but reduced from baseline.
    -MouseID_X_angle: angles calculated from the complex number of eyeX and eyeY.
    -MouseID_X_dangle: angles calculated from complex number of deyeX and deyeY.
    -MouseID_X_movement: eye movement displacement also from complex number of eyeX and eyeY.
    -MouseID_X_dmovement: eye movement displacement from complex number of deyeX and deyeY.
    -MouseID_X_velocity: MouseID_X_movement differentiated.
    -MouseID_X_dvelocity: MouseID_X_dmovement differentiated.
