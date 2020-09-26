%% Demo code to visualise responses to drifting gratings

clear;

addpath('\\zserver.cortexlab.net\Code\2photonPipeline')
addpath('\\zserver.cortexlab.net\Code\Matteobox')
addpath('\\zserver.cortexlab.net\Code\Neuropil Correction');
FR068_1_eyeDb;

iExp = 2; % indicate what session you want to analyse

db(iExp).expID=[1];
%%
info = ppbox.infoPopulateTempLFR(db(iExp).mouse_name, db(iExp).date, db(iExp).expts(db(iExp).expID)); % gather some metadata about this recording

ballData = getRunningSpeed(info); % load the running data for this experiment. Consider interpolating these to the same time stamps of the eye data

eyeData =getEyeData(db(iExp), [], 1); % laod the eye data
eyeData.z=eyeData.x-repmat(mean(eyeData.x),1,length(eyeData.x))+1i.*(eyeData.y-repmat(mean(eyeData.y),1,length(eyeData.y)));
eyeData.angles=angle(eyeData.z);
eyeData.movement=abs(eyeData.z);
% plot eye data and running data
figure; 
plot(ballData.t, ballData.total);
xlim([min(eyeData.ts) max(eyeData.ts)])
xlabel('Time(s)','FontSize',20)
ylabel('Running Speed (cm\cdots^{-1})','FontSize',20)
set (gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [0.015 0.015],'FontSize',20)
figure;
plot(eyeData.ts, eyeData.pupil)
xlim([min(eyeData.ts) max(eyeData.ts)])
xlabel('Time(s)','FontSize',20)
ylabel('Pupil A/Ao','FontSize',20)
set (gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [0.015 0.015],'FontSize',20)

figure;
plot(eyeData.ts,eyeData.x)
xlim([min(eyeData.ts) max(eyeData.ts)])
xlabel('Time(s)','FontSize',20)
ylabel('Eye X Aixs (px)','FontSize',20)
set (gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [0.015 0.015],'FontSize',20)
figure;
plot(eyeData.ts,eyeData.y)
xlim([min(eyeData.ts) max(eyeData.ts)])
xlabel('Time(s)','FontSize',20)
ylabel('Eye Y Aixs (px)','FontSize',20)
set (gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [0.015 0.015],'FontSize',20)
figure;
plot(eyeData.ts,eyeData.angles)
xlim([min(eyeData.ts) max(eyeData.ts)])
xlabel('Time(s)','FontSize',20)
ylabel('Eye Movement Angles (rad)','FontSize',20)
set (gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [0.015 0.015],'FontSize',20)
figure;
plot(eyeData.ts,eyeData.movement)
xlim([min(eyeData.ts) max(eyeData.ts)])
xlabel('Time(s)','FontSize',20)
ylabel('Eye Movement (px)','FontSize',20)
set (gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [0.015 0.015],'FontSize',20)
%% load stimulus information: timestamp, stimulus labels and stimulus matrix

frameTimes = eyeData.ts; % extract the stimulus times according to the eye data time stamps

stimTimes = ppbox.getStimTimes(info); % sequence of onset and offset times of stimuli
stimSequence = ppbox.getStimSequence_LFR(info); % stimulus labels and sequence
stimMatrix = ppbox.buildStimMatrix(stimSequence, stimTimes, frameTimes); % stimulus matrix

figure; imagesc(stimMatrix) % plot stimulus matrix
%%
frameRate = 1/mean(diff(eyeData.ts)); % frameRate of eye data in Hz

nStim = numel(unique(stimSequence.seq));
switch db(iExp).stimType{db(iExp).expID}
    case 'plaids'
        stimSet = 13:25;
    case 'oris'
        stimSet = 1:nStim;
    case 'oriMultiSfTf'
        if nStim <= 38
            stimSet = [2:3:12*3, nStim];

        else
            stimSet = [3:7:12*7, nStim];
        end
end
[responses, aveResp, seResp, kernelTime, stimDur] = ... % stimulus triggered analysis
    getStimulusSweepsLFR(eyeData.pupil', stimTimes, stimMatrix, frameRate,stimSet); % responses is (nroi, nStim, nResp, nT)

respWin = [0 3];

plotSweepResp(responses, kernelTime, stimDur); % plot stimulus triggered average
% [resPeak, aveResPeak, seResPeak] = ...
%     gratingOnResp(responses, kernelTime, respWin);  % resPeak is (nroi, nStim, nResp)

%%


