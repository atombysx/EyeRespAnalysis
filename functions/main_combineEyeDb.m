function [pupil,eyeX,eyeY,ball,info,dball,movement_angle,movement,velocity,deyeX,deyeY,dmovement_angle,dmovement,dvelocity]=main_combineEyeDb(db,save_data) 

addpath('\\zserver.cortexlab.net\Code\2photonPipeline');
addpath('\\zserver.cortexlab.net\Code\Matteobox');
addpath('\\zserver.cortexlab.net\Code\Neuropil Correction');
if nargin < 2
    save_data=0;
end



nDb = numel(db);

%% loop through sessions and load the data from the oris experiment

for iDb = 1:nDb
    Db=db(iDb);
    stimType=Db.stimType;
    orisExp = ~cellfun(@isempty, strfind(stimType, 'oris'));
    sFtFExp = ~cellfun(@isempty, strfind(stimType, 'oriMultiSfTf'));
    plaidExp = ~cellfun(@isempty, strfind(stimType, 'plaid'));
    allExp = intersect(find(orisExp | sFtFExp | plaidExp), Db.expID);
    nExp = numel(allExp);
    
    for iExp = 1:nExp
        
        info{iDb, iExp} = ppbox.infoPopulateTempLFR(Db.mouse_name, Db.date, Db.expts(allExp(iExp))); % gather some metadata about this recording
        
        ballData = getRunningSpeed(info{iDb, iExp}); % load the running data for this experiment. Consider interpolating these to the same time stamps of the eye data
        
        eyeData =getEyeData_dev(info{iDb, iExp}, [], 0); % laod the eye data
%         eyeData.z=eyeData.x-repmat(eyeData.x(1),1,length(eyeData.x))+1i.*(eyeData.y-repmat(eyeData.y(1),1,length(eyeData.y)));
%         eyeData.angles=angle(eyeData.z);
%         eyeData.movement=abs(eyeData.z);
%         plot(eyeData.ts,gaussFilt(eyeData.angles,5));
        frameTimes = eyeData.ts; % extract the stimulus times according to the eye data time stamps
        
        stimTimes = ppbox.getStimTimes(info{iDb, iExp}); % sequence of onset and offset times of stimuli
        stimSequence = ppbox.getStimSequence_LFR(info{iDb, iExp}); % stimulus labels and sequence
        stimMatrix = ppbox.buildStimMatrix(stimSequence, stimTimes, frameTimes); % stimulus matrix
        
        
        eye_frameRate = 1/nanmean(diff(eyeData.ts)); % frameRate of eye data in Hz
        
        nStim = numel(unique(stimSequence.seq));
        switch Db.stimType{allExp(iExp)}
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
        
        [pupil.resp{iDb, iExp}, pupil.aveResp{iDb, iExp}, pupil.seResp{iDb, iExp}, pupil.staTime{iDb, iExp}, pupil.stimDur{iDb, iExp}] = ... % stimulus triggered analysis
            getStimulusSweepsLFR(eyeData.pupil', stimTimes, stimMatrix, eye_frameRate,stimSet); % responses is (nroi, nStim, nResp, nT)
      [deyeX.resp{iDb, iExp}, deyeX.aveResp{iDb, iExp}, deyeX.seResp{iDb, iExp}] = ... % stimulus triggered analysis
            getStimulusSweepsLFR(eyeData.x', stimTimes, stimMatrix, eye_frameRate,stimSet); % responses is (nroi, nStim, nResp, nT)
      [deyeY.resp{iDb, iExp}, deyeY.aveResp{iDb, iExp}, deyeY.seResp{iDb, iExp}] = ... % stimulus triggered analysis
            getStimulusSweepsLFR(eyeData.y', stimTimes, stimMatrix, eye_frameRate,stimSet); % responses is (nroi, nStim, nResp, nT)
        [eyeX.resp{iDb, iExp}, eyeX.aveResp{iDb, iExp}, eyeX.seResp{iDb, iExp}] = ... % stimulus triggered analysis
            getStimulusSweepsLFR(eyeData.x', stimTimes, stimMatrix, eye_frameRate,stimSet, false); % responses is (nroi, nStim, nResp, nT)
        [eyeY.resp{iDb, iExp}, eyeY.aveResp{iDb, iExp}, eyeY.seResp{iDb, iExp}] = ... % stimulus triggered analysis
            getStimulusSweepsLFR(eyeData.y', stimTimes, stimMatrix, eye_frameRate,stimSet, false); % responses is (nroi, nStim, nResp, nT)
%               [movement_angle.resp{iDb, iExp}, movement_angle.aveResp{iDb, iExp}, movement_angle.seResp{iDb, iExp}] = ... % stimulus triggered analysis
%             getStimulusSweepsLFR(eyeData.angles', stimTimes, stimMatrix, eye_frameRate,stimSet,false); % responses is (nroi, nStim, nResp, nT)
%               [movement.resp{iDb, iExp}, movement.aveResp{iDb, iExp}, movement.seResp{iDb, iExp}] = ... % stimulus triggered analysis
%             getStimulusSweepsLFR(eyeData.movement', stimTimes, stimMatrix, eye_frameRate,stimSet,false); % responses is (nroi, nStim, nResp, nT)
         [~,~,n_trial,~]=size(pupil.resp{iDb,iExp});
         dz.resp{iDb,iExp}=deyeX.resp{iDb,iExp}+1i.*deyeY.resp{iDb,iExp};
%          X=eyeX.resp{iDb,iExp};
%          Y=eyeY.resp{iDb,iExp};
%          zXY=[];
%          for stim=1:13
%              for trial=1:n_trial
%                  
%                     zXY(1,stim,trial,:)=X(1,stim,trial,:)-repmat(nanmean(X(1,stim,trial,:)),1,1,1,60)+1i.*(Y(1,stim,trial,:)-repmat(nanmean(Y(1,stim,trial,:)),1,1,1,60));
%              end
%          end
         z.resp{iDb,iExp}=eyeX.resp{iDb,iExp}+1i*eyeY.resp{iDb,iExp};%complex number form of eye X and Y axis coordinates
         dmovement_angle.resp{iDb,iExp}=angle(dz.resp{iDb,iExp});%the angles of the eyes moving from reduced from baseline coordinates 
         movement_angle.resp{iDb,iExp}=angle(z.resp{iDb,iExp});%angles calculated from actual coordinates
         movement.resp{iDb,iExp}=abs(z.resp{iDb,iExp});%eye movement displacement
         dmovement.resp{iDb,iExp}=abs(dz.resp{iDb,iExp});%eye movement displacement from reduced from baseline
        
         velocity.resp{iDb,iExp}=cat(4,diff(movement.resp{iDb,iExp},1,4),zeros(1,13,n_trial,1));%velocity calculated from displacement
         dvelocity.resp{iDb,iExp}=cat(4,diff(dmovement.resp{iDb,iExp},1,4),zeros(1,13,n_trial,1));
     stimMatrix = ppbox.buildStimMatrix(stimSequence, stimTimes, ballData.t); % stimulus matrix
        ball_frameRate = 1/mean(diff(ballData.t)); % frameRate of eye data in Hz
     
    [dball.resp{iDb, iExp}, dball.aveResp{iDb, iExp}, dball.seResp{iDb, iExp}] = ... % stimulus triggered analysis
            getStimulusSweepsLFR(ballData.total, stimTimes, stimMatrix, ball_frameRate,stimSet); % responses is (nroi, nStim, nResp, nT)
  
    [ball.resp{iDb, iExp}, ball.aveResp{iDb, iExp}, ball.seResp{iDb, iExp}] = ... % stimulus triggered analysis
            getStimulusSweepsLFR(ballData.total, stimTimes, stimMatrix, ball_frameRate,stimSet, false); % responses is (nroi, nStim, nResp, nT)
   
    end
    
%%

%%
%combine the data in one mouse
pupil.combined=cat(3,pupil.resp{:});
eyeX.combined=cat(3,eyeX.resp{:});
eyeY.combined=cat(3,eyeY.resp{:});
ball.combined=cat(3,ball.resp{:});
dball.combined=cat(3,dball.resp{:});
movement_angle.combined=cat(3,movement_angle.resp{:});
movement.combined=cat(3,movement.resp{:});
velocity.combined=cat(3,velocity.resp{:});
deyeX.combined=cat(3,deyeX.resp{:});
deyeY.combined=cat(3,deyeY.resp{:});
dmovement_angle.combined=cat(3,dmovement_angle.resp{:});
dmovement.combined=cat(3,dmovement.resp{:});
dvelocity.combined=cat(3,dvelocity.resp{:});
figure
    
    
end
%plot the traces to see if the data were calculated correctly
plotSweepResp(pupil.combined,  pupil.staTime{1,1}, pupil.stimDur{1,1}); % plot stimulus triggered average

plotSweepResp(eyeX.combined,  pupil.staTime{1,1}, pupil.stimDur{1,1});

plotSweepResp(eyeY.combined,  pupil.staTime{1,1}, pupil.stimDur{1,1});

plotSweepResp(ball.combined,  pupil.staTime{1,1}, pupil.stimDur{1,1});

plotSweepResp(dball.combined,  pupil.staTime{1,1}, pupil.stimDur{1,1});
plotSweepResp(movement_angle.combined,  pupil.staTime{1,1}, pupil.stimDur{1,1});
plotSweepResp(movement.combined,  pupil.staTime{1,1}, pupil.stimDur{1,1});
plotSweepResp(velocity.combined,  pupil.staTime{1,1}, pupil.stimDur{1,1});
plotSweepResp(dmovement_angle.combined,  pupil.staTime{1,1}, pupil.stimDur{1,1});
plotSweepResp(dmovement.combined,  pupil.staTime{1,1}, pupil.stimDur{1,1});
plotSweepResp(deyeX.combined,  pupil.staTime{1,1}, pupil.stimDur{1,1});
plotSweepResp(deyeY.combined,  pupil.staTime{1,1}, pupil.stimDur{1,1});
plotSweepResp(dvelocity.combined,  pupil.staTime{1,1}, pupil.stimDur{1,1});
if save_data
    save([sprintf('%s', Db.mouse_name), '_EyeBallData.mat'], 'ball','pupil', 'eyeX', 'eyeY', 'info','dball');
end
end