function align_resp=StimAlignRsp(stimSet,raw_trace)
vbDirtyEnd = stimSet{1:end-1, 'end_frame'} == stimSet{2:end, 'start_frame'};

vbDirtyStart = [false; vbDirtyEnd(1:end)];
vbDirtyEnd = [vbDirtyEnd; false];
vnFluoresenceTimeIndices = 1:size(raw_trace, 1);
% - Helper function for finding "clean" response frames (where the stimulus
% did not change mid-frame)
   function vnFluorFrames = clean_frames(nStart, nEnd, bDirtyStart, bDirtyEnd)
      [~, vnFluorFrames] = ismember((double(nStart) + double(bDirtyStart)):(double(nEnd) - double(bDirtyEnd)), vnFluoresenceTimeIndices);
   end

% - Get lists of clean fluorescence frames for each stimulus presentation period
cvnFluorFrameInds = arrayfun(@clean_frames, stimSet.('start_frame')-60, stimSet.('end_frame')+60, vbDirtyStart, vbDirtyEnd, 'UniformOutput', false);
% - Helper function for computing the stimulus response metric over a set
% of frames
%    fhMetric = @(x)nanmean(x, 1);
   function vfThisResp = stim_metric(vnFrameInds)
      [~, vnRespInds] = ismember(vnFrameInds, vnFluoresenceTimeIndices);
       
        
         vfThisResp =raw_trace(vnRespInds, :);
        
   end

% - Process lists of fluorescence frames and compute metric
cmfAlignedResp = cellfun(@stim_metric, cvnFluorFrameInds, 'UniformOutput', false);
[no_stim,~]=size(cmfAlignedResp);

[~,no_neuron]=size(raw_trace);
align_rsp=zeros(no_stim,180,no_neuron);
% sweepON =  -2;
% sweepOFF =  4;
% kernelTimes = linspace(sweepON, sweepOFF, range([sweepON, sweepOFF])*10);
for i=1:no_stim

    rsp_tmp=cmfAlignedResp{i};
    [tms,neuron_id]=size(rsp_tmp);
    resp_tmp=zeros(180,neuron_id);
    for j=1:neuron_id
       resp_tmp(:,j)=interp1(rsp_tmp(:,j),1:tms/180:tms); 
    end
    align_rsp(i,:,:)=resp_tmp;
end
align_resp=permute(align_rsp,[3,1,2]);





end