function [eye] = getEyeData(db, timePoints, doPlot)
%% load and plot data from etGUI
% db is a structure with fields {'animal', 'date', 'exp', 'expID'} pointing to an experiment
% timepoints are query timestamps of eye data. Set to [] if you want all the recorded timepoints
% doPlot is a binary flag, set to 1 to plot the data, 0 otherwise


%% before running this code, analyse the eye camera data with etGUI
%>>etGUI
% ET Workflow
% Blink ROI
% DetectBlinks
% Check Blink threshold
% Pupil ROI
% Adjust Saturation and threshold
% Visualize Edge,Ellipse,Center and check performance with Preview
% Fast Analyis/Batch Analysis


%%

% add relevant code to path
addpath('\\zserver.cortexlab.net\Code\2photonPipeline');
addpath('C:\Users\experiment\Documents\EyeTracking');

% if nargin <2
%     ppFrames = 'all';
% end

if nargin <2
    timePoints = []; % if timePoints are not indicates, load all
end

if nargin <2
    doPlot = 0; % if plot not requested, do not plot results
end


%ppFrames either 'all' or planeFrames

%% load the etGUI processed file
subject = db.mouse_name;
expDate = db.date;
exp =db.expts(db.expID);

%series = datestr(expDate, 'yyyy-mm-dd');

info=ppbox.infoPopulateTempLFR(subject, expDate, exp);

% construct directories and filenames
etRepo_old  = '\\zserver.cortexlab.net\Data\EyeCamera';

et_processed = [expDate,'_', num2str(exp),'_',subject,'_eye_processed.mat'];
et_raw = [expDate,'_', num2str(exp),'_',subject,'_eye.mat'];
et_movie = [expDate,'_', num2str(exp),'_',subject,'_eye.mj2'];

    if exist(fullfile(etRepo_old, subject, expDate, num2str(exp)))  
    
        etFolder = fullfile(etRepo_old, subject,expDate, num2str(exp));
    else
        etFolder = info.folder2p;
    end

et_processed = fullfile(etFolder, et_processed);
et_raw = fullfile(etFolder, et_raw);

%load
load(et_processed);


%% load pupil data and timestamps

tlFile = fullfile(info.folderTL, info.basenameTL);
% load(tlFile);
% etTS = et.getFrameTimes(subject, series,exp);
% frameTimes=ppbox.getFrameTimes(info, ppFrames);

eye.ts = et.getFrameTimesLFR(et_raw, tlFile);

vr = VideoReader(fullfile(etFolder,et_movie));

eye.frame = read(vr, 1);

eye.roi = results.roi(1,:);
%% remove blink frames and take pupil area A/Ao
% results.area(results.blink) = NaN;
% blinkp = results.blink;
% gdp = find(~blinkp);
% eye.pupil = results.area(gdp);
% eye.pupil = interp1(gdp, eye.pupil, 1:numel(blinkp));

eye.pupil = results.area;
%% remove additional, undetected anomalies and interpolate NaN values

dPupil = [0; diff(eye.pupil)];
%ddPupil = [0; diff(dPupil)];
dThresh =3;
% ddThresh= 2;
new_blinks = logical([repmat(0,9,1);abs(dPupil(10:end-10))>dThresh;repmat(0,10,1)]); %| abs(ddPupil)>ddThresh;

eye.pupil(new_blinks) = NaN;
eye.x(new_blinks) = NaN;
eye.y(new_blinks) = NaN;



eye.pupil(results.blink) = NaN;
eye.x = results.x;
eye.x(results.blink) = NaN;
eye.y = results.y;
eye.y(results.blink) = NaN;
eye.pupil(new_blinks) = NaN;
eye.x(new_blinks) = NaN;
eye.y(new_blinks) = NaN;
 eye.pupil(abs(eye.pupil)>10000)=NaN;
 eye.x(abs(eye.x)>1000)=NaN;
 eye.y(abs(eye.y)>1000)=NaN;
eye.pupil = interpNaN(eye.pupil)';
eye.x = interpNaN(eye.x)';
eye.y = interpNaN(eye.y)';



%%
if ~isempty(timePoints)
    eye.pupil = interp1(eye.ts, eye.pupil, timePoints,'linear');
    eye.x = interp1(eye.ts, eye.x,  timePoints,'linear');
    eye.y = interp1(eye.ts, eye.y,  timePoints,'linear');
    eye.ts = timePoints;
end
eye.pupil = gaussFilt(eye.pupil', 3);
eye.pupil = eye.pupil/prctile(eye.pupil,10);

eye.x = gaussFilt(eye.x', 3);
eye.y = gaussFilt(eye.y', 3);

%% plot if requested
if doPlot
% FrameRate = numel(frameTimes)/range(frameTimes);
% lcutoff = 10;
%b = fir1(floor(10*FrameRate),lcutoff/(FrameRate/2));

figure;plot(eye.ts,gaussFilt(eye.pupil,5));
xlim([min(eye.ts) max(eye.ts)])
xlabel('Time(s)','FontSize',15)
ylabel('Pupil A/Ao','FontSize',15)
set (gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [0.015 0.015],'FontSize',15)

end

end

%% plot frames of the pupil
% addpath('\\zserver2\Data\EyeCamera\M140918_FR028\2014-10-07\1');
% filename = '2014-10-07_1_M140918_FR028_eye.mj2';
% filepath = '\\zserver2\Data\EyeCamera\M140918_FR028\2014-10-07\1';
% vr = VideoReader(fullfile(filepath,filename));
% 
% iFrame = 18000;
% frame = read(vr, iFrame);
% 
% figure;
% imagesc(frame); axis image; colormap gray
% caxis([12 100])
% axis off
