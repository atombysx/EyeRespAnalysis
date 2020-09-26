function plotSweepRespScatterAngle(exp_responses,response_name,ylimit,method,mean_bar)
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

for fig = 1: nFigures
    figure
    for neuron = 1:min(cellsPerFigure, nRoi-(fig-1)*cellsPerFigure)
        neuronID = (fig-1)*cellsPerFigure + neuron;
       
        for stim = 1:nStim
            kernel=[];
            for nexp=1:n_exp
                [~ , ~ , nTrial , ~] = size(exp_responses{nexp});
                responses=cell2mat(exp_responses(nexp));
                resp=squeeze(responses(neuronID,stim,:,20:31));
                if method == 0
                        kernel_mean(nexp,stim)=nanmax(kernel(nexp,stim,:));
                    elseif method == 1
                        [r1,kernel]=circ_axialmean(resp,2,2);
                        [r2,kernel_mean(nexp,stim)]=circ_axialmean(kernel,2,1);
                    elseif method == 2
                        kernel_mean(nexp,stim)=nanmedian(kernel(nexp,stim,:));
               end
            end

        end
        
    
    
    end
    if method ==0
        kernel_means=repmat(angle(nanmax(kernel_mean,1))./2,n_exp,1);
    elseif method == 1
        kernel_means=repmat(circ_mean(kernel_mean),n_exp,1);
    elseif method ==2
        kernel_means=repmat(angle(nanmedian(kernel_mean,1))./2,n_exp,1);
    end
    x_axis=repmat([0:30:360],n_exp,1)+rand(n_exp,13)*10;
    plot(x_axis,kernel_mean,'o')
    hold on
    if mean_bar
             plot(x_axis,kernel_means,'r')
    end
    ylim (ylimit)
    ylabel(response_name)
    set(gca, 'Color', 'w')
end
end