function [move_test,still_test]=plotSweepRespRun(move_db,still_db,kernelTimes,y_label,y_lim,angle)
%move_db is the response while running
%still_db is the response while stationary
%kernelTimes is the pupil.statTime
%angle=1 only when you are calculating the mean values of angles
if nargin <6
    angle=0;
end
[nRoi, nStim, nTrials,~ ] = size(move_db);
if nRoi >= 10
    cellsPerFigure = 10;
else
    cellsPerFigure = nRoi;
end
colors = jet(ceil(nRoi * 1.1));
colors = colors(end-nRoi+1 : end, :);
nFigures = ceil(nRoi/ cellsPerFigure);
rows = cellsPerFigure;
cols = nStim;

for fig = 1: nFigures
    figure
    for neuron = 1:min(cellsPerFigure, nRoi-(fig-1)*cellsPerFigure)
        neuronID = (fig-1)*cellsPerFigure + neuron;
    move_test=[];
    still_test=[];
        for stim = 1:nStim
           if angle
                move_resp = squeeze(move_db(neuronID, stim, :, :));
            move_kernel = circ_mean(move_resp);
            move_ste_kernel=circ_std(move_resp)./((nTrials).^(0.5));
            still_resp =squeeze(still_db(neuronID, stim, :, :));
            still_kernel = circ_mean(still_resp);
            still_ste_kernel=circ_std(still_resp)./((nTrials).^(0.5));
             
           else
            move_resp = squeeze(move_db(neuronID, stim, :, :));
            move_kernel = nanmean(move_resp, 1);
            move_ste_kernel=nanstd(move_resp,1)./((nTrials).^(0.5));
            still_resp =squeeze(still_db(neuronID, stim, :, :));
            still_kernel = nanmean(still_resp, 1);
            still_ste_kernel=nanstd(still_resp,1)./((nTrials).^(0.5));
           end
            move_test=[move_test,move_kernel];
            still_test=[still_test,still_kernel];
            subplot(rows, cols, (neuron-1)*cols+stim)
            hold on
            shadePlot(kernelTimes,move_kernel,move_ste_kernel,'c')
            
            shadePlot(kernelTimes,still_kernel,still_ste_kernel,[0.5 0.5 0.7])
            xlim(kernelTimes([1 end]))
             ylim(y_lim)
            if stim <13
            xlabel(string((stim-1)*30)+'\circ')
            else 
                xlabel('no stimulus')
            end
           
            if stim == 1
                ylabel(y_label)
            end
            if stim > 1
               set(gca,'YTick',[])
            end
            if stim==13 
             lgnd=legend('Running','Stationary');
            end
             
            set(gca, 'Color', 'w','fontsize',20)
           
        end
        
    
    
    end
end 

end