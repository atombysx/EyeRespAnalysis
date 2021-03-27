sessions = bot.fetchSessions('ophys');

% Show an overview of the sessions available
head(sessions)


% Select experiments from the most orientation/direction-selective areas of visual cortex ('VISal', id = 402; 'VISrl', id = 417 ; 'VISam', id = 394 )
sessions = sessions(ismember(sessions.targeted_structure_id, [394 402 417]), :);

% Select experiments with GCaMP6f expression enriched in Layer 2/3 and Layer 4 of cortex
sessions = sessions(sessions.cre_line == "Cux2-CreERT2", :);

% Select experiments imaging from the shallowest depth in Layer 2/3
sessions = sessions(sessions.imaging_depth == 175,:);

% Select experiments with eye tracking data available
sessions = sessions(~sessions.fail_eye_tracking, :);
% % Select experiments with drifting grating and natural movie stimuli
% sessions = sessions(sessions.stimulus_name == "three_session_A", :);


disp(sessions);
for session_id=1:size(sessions,2)
    try
        session = bot.session(sessions(session_id,:));
        session.metadata


        traces = session.dff_traces;
        timestamps = session.fluorescence_timestamps;
                %spontaneous
        spontaneous = session.fetch_stimulus_table('spontaneous');
        sponResp=traces(spontaneous.start_frame:spontaneous.end_frame,:);
        [nT,nN]=size(sponResp);
        pupilA=circ_ang2rad(session.pupil_location(:,1));
        pupilE=circ_ang2rad(session.pupil_location(:,2));
        pupilA=medfilt1(pupilA(spontaneous.start_frame:spontaneous.end_frame,:),8);
        pupilE=medfilt1(pupilE(spontaneous.start_frame:spontaneous.end_frame,:),8);
        Fs=30; %sampling rate in Hz;
        time_vec=(1:nT)/Fs;
        neural_resp=permute(sponResp,[2 1]);
    %     neural_data{session_id}=(neural_resp-nanmedian(neural_resp,2))./iqr(neural_resp,2);
        neural_data{session_id}=zscore(neural_resp,[],2);
        responsesA = [0 diff(permute(pupilA,[2 1]))];
        responsesE = [0 diff(permute(pupilE,[2 1]))];
        eye_data{session_id}=(responsesA.^2+responsesE.^2).^(0.5); 
                [pkt{session_id},peak_loc{session_id}]=findpeaks(eye_data{session_id},'MinPeakHeight',0.01,'MinPeakDistance',15);
%         [pkt{session_id},peak_loc{session_id}]=findpeaks(eye_data{session_id},'MinPeakHeight',quantile(eye_data{session_id},0.95),'MinPeakDistance',15);
        saccades=zeros(size(eye_data{session_id}));
        saccades(peak_loc{session_id})=1;
        saccade_times=time_vec(peak_loc{session_id});
        [STresps,STpsth{session_id},~,t_win]=magicETA(time_vec,(neural_data{session_id})',saccade_times,[-2,4],1);
    %     [~,mx]=max(STpsth,[],2);
    %     [~,ii]=sort(mx);


        mean_across_neurons{session_id}=mean(STpsth{session_id},2);
        mean_STpsth=STpsth{session_id};
%         before_onset_resp=mean_STpsth(11:20,:);
%         [h_b,p_b,ci_b,stats_b]=ttest(before_onset_resp,repmat())
       
        onset_resp=mean_STpsth(21:30,:);
        [h{session_id},p{session_id},ci{session_id},stats{session_id}]=ttest(onset_resp,repmat(prctile(mean_STpsth,50,1),10,1),'Dim',1);
        STpsth_sigf{session_id}=mean_STpsth(:,find(h{session_id}==1));
        STpsth_noresp{session_id}=mean_STpsth(:,find(h{session_id}==0));
        STpsth_tmp=STpsth_sigf{session_id};
        STpsth_event_average=mean(STpsth_tmp(21:30,:));
        [sort_values,sort_index]=sort(STpsth_event_average);
        sorted_sigf_psth{session_id}=STpsth_tmp(:,sort_index);
        active_index=sort_index(find(sort_values>0));
        suppress_index=sort_index(find(sort_values<0));
        active_resp{session_id}=STpsth_tmp(:,active_index);
        suppress_resp{session_id}=STpsth_tmp(:,suppress_index);
    [STresps_confirm,psth_confirm,~,t_win]=magicETA(time_vec,(eye_data{session_id})',saccade_times,[-2,4],1);
    catch
                neural_data{session_id}=[];
        pkt{session_id}=[];
        eye_data{session_id}=[];
        peak_loc{session_id}=[];
        STpsth{session_id}=[];
    end
end

figure;plot(t_win,psth_confirm);
  xlabel(['time (s)'])
  title(['eye movement during event triggered time (for validation)'])
figure;
for i=1:size(neural_data,2)
    [nN,nT]=size(neural_data{i});
  
    subplot(2,3,i)
    STpsth_tmp=STpsth{i};
    STpsth_event_average=mean(STpsth_tmp(21:30,:));
    [sort_values,sort_index]=sort(STpsth_event_average);
    sorted_STpsth=STpsth_tmp(:,sort_index)';
    imagesc(t_win,1:nN, sorted_STpsth)
    colormap parula
    colorbar
      xlabel(['time (s)'])
      ylabel(['Neuron ID'])
      title(['session#',num2str(i)'])
      supertitle(['neural activity during peak eye movements'])
           caxis([-1 1])
end
figure;
for i=1:size(neural_data,2)
    [nN,nT]=size(neural_data{i});
  
    subplot(2,3,i)

    time_vec=(1:nT)/Fs;
    imagesc(time_vec,1:nN,neural_data{i})
    colormap parula
    colorbar
      xlabel(['time (s)'])
      ylabel(['Neuron ID'])
      title(['session#',num2str(i)'])
      supertitle(['Neural Activity During Spontaneous'])
      caxis([-1 1])
end
figure;
for i=1:size(neural_data,2)
    [nN,nT]=size(neural_data{i});
  
    subplot(2,3,i)

    time_vec=(1:nT)/Fs;
    plot(time_vec,eye_data{i})
    hold on
    plot(peak_loc{i}./Fs,pkt{i},'x')
      xlabel(['time (s)'])
      ylabel(['dY/dt of eye position']) 
     title(['session#',num2str(i)'])
end
figure;
plot(time_vec,eye_data{1,6})
hold on
plot(time_vec,pupilA)
plot(time_vec,pupilE)
title(['eye position and speeds'])
xlabel(['time (s)'])

figure;
for i=1:size(neural_data,2)
    [nT,nN]=size(sorted_sigf_psth{i});
  
    subplot(2,3,i)

    
    imagesc(t_win,1:nN,sorted_sigf_psth{i}')
    colormap parula
    colorbar
      xlabel(['time (s)'])
      ylabel(['Neuron ID'])
      title(['session#',num2str(i)'])
      supertitle(['post_t_test Event Trigger Average'])
      caxis([-1 1])
end


figure;
for i=1:size(neural_data,2)
    [nT,nN]=size(active_resp{i});
  
    subplot(2,3,i)

    
    imagesc(t_win,1:nN,active_resp{i}')
    colormap parula
    colorbar
      xlabel(['time (s)'])
      ylabel(['Neuron ID'])
      title(['session#',num2str(i)'])
      supertitle(['Activation Neurons'])
      caxis([-1 1])
end
figure;
for i=1:size(neural_data,2)
    [nT,nN]=size(active_resp{i});
    active_mean=mean(active_resp{i},2);
    
    subplot(2,3,i)

    
        plot(t_win,active_mean)
      xlabel(['time (s)'])
      ylabel(['Z-score Response'])
      title(['session#',num2str(i)'])
      supertitle(['Average Activation Neuron Response'])
      ylim([-1,1])
end
figure;
for i=1:size(neural_data,2)
    [nT,nN]=size(suppress_resp{i});
  
    subplot(2,3,i)

    
    imagesc(t_win,1:nN,suppress_resp{i}')
    colormap parula
    colorbar
      xlabel(['time (s)'])
      ylabel(['Neuron ID'])
      title(['session#',num2str(i)'])
      supertitle(['Suppression Neurons'])
      caxis([-1 1])
end
figure;
for i=1:size(neural_data,2)
    [nT,nN]=size(suppress_resp{i});
    suppress_mean=mean(suppress_resp{i},2);
    
    subplot(2,3,i)

    
        plot(t_win,suppress_mean)
      xlabel(['time (s)'])
      ylabel(['Z-score Response'])
      title(['session#',num2str(i)'])
      supertitle(['Average Suppression Neuron Response'])
      ylim([-1,1])
end

figure;
for i=1:size(neural_data,2)

    
    subplot(2,3,i)

    
        plot(t_win,mean_across_neurons{i})
      xlabel(['time (s)'])
      ylabel(['Z-score Response'])
      title(['session#',num2str(i)'])
      supertitle(['Average Responses of All Neurons'])
      ylim([0,0.5])
end

figure;
subplot(1,2,1)
sum_active_resp=cell2mat(active_resp);
[sort_values,sort_index]=sort(mean(sum_active_resp(21:30,:),1));
sorted_sum_active=sum_active_resp(:,sort_index);
[~,nN]=size(sum_active_resp);
imagesc(t_win,1:nN,sorted_sum_active')

    colormap parula
    colorbar
      xlabel(['time (s)'])
      ylabel(['Neuron ID'])
      title(['All Activation Neurons'])
mean_active_allresp=mean(sum_active_resp,2);      
subplot(1,2,2)
plot(t_win,mean_active_allresp)
      xlabel(['time (s)'])
      ylabel(['z-scored response'])
      title(['Average of all Activation Neurons'])
      
      
      
      
      figure;
sum_suppress_resp=cell2mat(suppress_resp);
[~,nN]=size(sum_suppress_resp);
[sort_values,sort_index]=sort(mean(sum_suppress_resp(21:30,:),1));
sorted_sum_suppress=sum_suppress_resp(:,sort_index);

imagesc(t_win,1:nN,sorted_sum_suppress')

    colormap parula
    colorbar
      xlabel(['time (s)'])
      ylabel(['Neuron ID'])
      title(['All Suppression Neurons'])
      
mean_suppress_allresp=mean(sum_suppress_resp,2);      
subplot(1,2,2)
plot(t_win,mean_suppress_allresp)
      xlabel(['time (s)'])
      ylabel(['z-scored response'])
      title(['Average of all Suppression Neurons'])      
     

%  clear neural_data eye_data STpsth peak_loc pkt   
%     
%     sessions = bot.fetchSessions('ophys');
% 
% % Show an overview of the sessions available
% head(sessions)
% 
% sessions = sessions(ismember(sessions.targeted_structure_id, [385]), :);
% % Select experiments with GCaMP6f expression enriched in Layer 2/3 and Layer 4 of cortex
% sessions = sessions(sessions.cre_line == "Pvalb-IRES-Cre", :);
% % Select experiments imaging from the shallowest depth in Layer 2/3
% sessions = sessions(sessions.imaging_depth == 275,:);
% 
% 
% % Select experiments with eye tracking data available
% sessions = sessions(~sessions.fail_eye_tracking, :);
% for session_id=1:size(sessions,1)
% 
%     session = bot.session(sessions(session_id,:));
%     session.metadata
% 
% 
%     traces = session.dff_traces;
%     timestamps = session.fluorescence_timestamps;

%     %spontaneous
%     spontaneous = session.fetch_stimulus_table('spontaneous');
%     sponResp=traces(spontaneous.start_frame(1):spontaneous.end_frame(1),:);
%     [nT,nN]=size(sponResp);
%         neural_resp=permute(sponResp,[2 1]);
% %     neural_data{session_id}=(neural_resp-nanmedian(neural_resp,2))./iqr(neural_resp,2);
%     neural_data{session_id}=zscore(neural_resp,[],2);
%     try
%     pupilA=circ_ang2rad(session.pupil_location(:,1));
%     pupilE=circ_ang2rad(session.pupil_location(:,2));
%     pupilA=medfilt1(pupilA(spontaneous.start_frame(1):spontaneous.end_frame(1),:),8);
%     pupilE=medfilt1(pupilE(spontaneous.start_frame(1):spontaneous.end_frame(1),:),8);
%     Fs=30; %sampling rate in Hz;
%     time_vec=(1:nT)/Fs;
% 
%     responsesA = [0 diff(permute(pupilA,[2 1]))];
%     responsesE = [0 diff(permute(pupilE,[2 1]))];
%     eye_data{session_id}=(responsesA.^2+responsesE.^2).^(0.5); 
%     [pkt{session_id},peak_loc{session_id}]=findpeaks(eye_data{session_id},'MinPeakHeight',quantile(eye_data{session_id},0.95),'MinPeakDistance',15);
%     saccades=zeros(size(eye_data{session_id}));
%     saccades(peak_loc{session_id})=1;
%     saccade_times=time_vec(peak_loc{session_id});
%     [STresps,STpsth{session_id},~,t_win]=magicETA(time_vec,(neural_data{session_id})',saccade_times,[-2,4],0);
% %     [~,mx]=max(STpsth,[],2);
% %     [~,ii]=sort(mx);
%     
%   
% 
% [STresps_confirm,psth_confirm,~,t_win]=magicETA(time_vec,(eye_data{session_id})',saccade_times,[-2,4],0);
%     catch
%         pkt{session_id}=[];
%         eye_data{session_id}=[];
%         peak_loc{session_id}=[];
%         STpsth{session_id}=[];
%     end
% end
% 
% figure;plot(t_win,psth_confirm);
%   xlabel(['time (s)'])
%   title(['eye movement during event triggered time (for validation)'])
% figure;
% for i=1:size(neural_data,2)
%     [nN,nT]=size(neural_data{i});
%   
%     subplot(2,3,i)
%     STpsth_tmp=STpsth{i};
%     if ~isempty(STpsth_tmp)
%     STpsth_event_average=mean(STpsth_tmp(21:30,:));
%     [sort_values,sort_index]=sort(STpsth_event_average);
%     sorted_STpsth=STpsth_tmp(:,sort_index)';
%     imagesc(t_win,1:nN, sorted_STpsth)
%     colormap jet
%     colorbar
%       xlabel(['time (s)'])
%       ylabel(['Neuron ID'])
%       title(['session#',num2str(i)'])
%       supertitle(['neural activity during peak eye movements'])
%     end
% end
% figure;
% for i=1:size(neural_data,2)
%     [nN,nT]=size(neural_data{i});
%   
%     subplot(2,3,i)
% 
%     time_vec=(1:nT)/Fs;
%     imagesc(time_vec,1:nN,neural_data{i})
%     colormap jet
%     colorbar
%       xlabel(['time (s)'])
%       ylabel(['Neuron ID'])
%       title(['session#',num2str(i)'])
%       supertitle(['Neural Activity During Spontaneous'])
% end
% figure;
% for i=1:size(neural_data,2)
%     [nN,nT]=size(neural_data{i});
%   
%     subplot(2,3,i)
% 
%     time_vec=(1:nT)/Fs;
%     plot(time_vec,eye_data{i})
%     hold on
%     plot(peak_loc{i}./Fs,pkt{i},'x')
%       xlabel(['time (s)'])
%       ylabel(['dY/dt of eye position']) 
%      title(['session#',num2str(i)'])
% end
% figure;
% plot(time_vec,eye_data{1,6})
% hold on
% plot(time_vec,pupilA)
% plot(time_vec,pupilE)
% title(['eye position and speeds'])
% xlabel(['time (s)'])

    %Directional Gratings
    % neur_tmp=singleTrialNeuron{1,1};
    % nRoi=size(neur_tmp,1);
    % [nStim,~]=size(singleTrialNeuron);
    % cols = nStim;
    % 
    % for stim=1:nStim
    % neural_data=singleTrialNeuron{stim};%nN x nTri x nT
    % neural_data=neural_data(:,:,61:120);
    % [nN,nTrials,nT]=size(neural_data);
    % Fs=30; %sampling rate in Hz;
    % time_vec=(1:nT*nTrials)/Fs;
    % neural_data=reshape(permute(neural_data,[1 3 2]),nN,nT*nTrials);%nT x nT*nTrials; conc timepoints
    % respA=squeeze(singleTrialA{stim});
    % responsesA = [0 diff(reshape(permute(respA(:,61:120),[2 1]),1,nT*nTrials))];
    % respE=squeeze(singleTrialE{stim});
    % responsesE = [0 diff(reshape(permute(respE(:,61:120),[2 1]),1,nT*nTrials))];
    % eye_data=(responsesA.^2+responsesE.^2).^(0.5); %%differentiate the A and E positions first and take the square root of both
    % [pkt,peak_loc]=findpeaks(eye_data,'MinPeakHeight',quantile(eye_data,0.95));
    % saccades=zeros(size(eye_data));
    % saccades(peak_loc)=1;
    % saccade_times=time_vec(peak_loc);
    % [STresps,STpsth,~,t_win]=magicETA(time_vec,neural_data',saccade_times,[-0.5,2.5],0);
    % STpsth=STpsth';

    % [~,mx]=max(STpsth,[],2);
    % [~,ii]=sort(mx);

%     figure;
%     subplot(3,1,2:3)
%     imagesc(neural_data);
%     subplot(3,1,1)
%     plot(saccades)
%     figure;
%     imagesc(t_win,1:nN, STpsth)
%     colormap jet
%     colorbar
%     end
%     a=(STpsth+(0:0.2:size(STpsth,1)/5-0.2)')';
%     figure;plot(a)

    % figure;
    % kernelTimes=0:1/30:(2-1/30);
    % for stim=1:nStim
    % 
    % 
    % respA=squeeze(singleTrialA{stim});
    % responsesA = squeeze(nanmean(respA(:,61:120)));
    % 
    % respE=squeeze(singleTrialE{stim});
    % responsesE = squeeze(nanmean(respE(:,61:120)));
    % eye_data=[0 abs(diff((responsesA.^2+responsesE.^2).^(0.5)))];
    % subplot(2,4,stim)
    % 
    % plot(kernelTimes,eye_data)
    % end
    % 
    % for stim=1:nStim
    % 
    % 
    % respA=squeeze(singleTrialA{stim});
    % respE=squeeze(singleTrialE{stim});
    % 
    % [nTrials,~]=size(respA);
    % figure;
    % for i=1:nTrials
    %     subplot(10,8,i)
    %     responsesA = squeeze(respA(i,61:120));
    % 
    % 
    %     responsesE = squeeze(respE(i,61:120));
    %     eye_data=[0 abs(diff((responsesA.^2+responsesE.^2).^(0.5)))];
    %     
    %     
    %     plot(kernelTimes,eye_data)
    %     title(['Trial#',num2str(i)])
    % 
    % end
    % end