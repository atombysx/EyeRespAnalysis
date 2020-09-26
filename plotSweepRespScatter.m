function [kernel_mean]=plotSweepRespScatter(exp_responses,response_name,ylimit,method,mean_bar)
n_exp=length(exp_responses);
 if nargin< 5
     mean_bar=0;
 end



% define parameters

[nRoi, nStim, ~ , ~] = size(exp_responses{1});


%%


% Number of cells per figure and of figures
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
p=[];
for fig = 1: nFigures
    figure
    for neuron = 1:min(cellsPerFigure, nRoi-(fig-1)*cellsPerFigure)
        neuronID = (fig-1)*cellsPerFigure + neuron;
       
        for stim = 1:nStim
            kernel=[];
            for exp=1:n_exp
                [~ , ~ , nTrial , ~] = size(exp_responses{exp});
                responses=cell2mat(exp_responses(exp));
                
                 for Trial=1:nTrial
                    
                    resp=squeeze(responses(neuronID,stim,Trial,15:40));
                    if method == 0
                        kernel(exp,stim,Trial)=nanmax(resp);
                    elseif method == 1
                        kernel(exp,stim,Trial)=nanmean(resp);
                    elseif method == 2
                        kernel(exp,stim,Trial)=nanmedian(resp);
                    end
                    
                end
                if method == 0
                        kernel_mean(exp,stim)=nanmax(kernel(exp,stim,:));
                    elseif method == 1
                        kernel_mean(exp,stim)=nanmean(kernel(exp,stim,:));
                    elseif method == 2
                        kernel_mean(exp,stim)=nanmedian(kernel(exp,stim,:));
                    end
            end

        end
        
    
    
    end
    if method ==0
        kernel_means=repmat(nanmax(kernel_mean,1),n_exp,1);
    elseif method == 1
        kernel_means=repmat(nanmean(kernel_mean,1),n_exp,1);
    elseif method ==2
        kernel_means=repmat(nanmedian(kernel_mean,1),n_exp,1);
    end
    x_axis=repmat([0:30:360],n_exp,1)+rand(n_exp,13)*10;
    plot(x_axis,kernel_mean,'o')
    hold on
    if mean_bar
             plot(x_axis,kernel_means,'r')
    end
    ylim (ylimit)
    ylabel(response_name)
   xlabel('Degree of Gratings')
    set(gca, 'Color', 'w','fontsize',20)
end
end