function plotSweepRespStd(responses, kernelTimes, response_name,y_limit)

justMean=0;

% define parameters

[nRoi, nStim, ~ , ~] = size(responses);

kernelTimesPatch  = [kernelTimes, fliplr(kernelTimes)]';
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
        maxi = -Inf;
        mini = Inf;
        for stim = 1:nStim
            resp = squeeze(responses(neuronID, stim, :, :));
            kernel = nanmean(resp, 1);
            std_kernel=nanstd(resp,1);
            subplot(rows, cols, (neuron-1)*cols+stim)
            hold on
            shadePlot(kernelTimes,kernel,std_kernel,'c')
            xlim(kernelTimes([1 end]))
            ylim(y_limit)
            if ~justMean
                m = max(resp(:));
            else
                m = max(kernel);  
            end
            if maxi < m
                maxi = m;
            end
            if ~justMean
                m = min(resp(:));
            else
                m = min(kernel);
            end
            if mini > m
                mini = m;
            end
            if neuron == 1
                %title(regexprep(stimulusSequence.labels{stim}, ', ', '\n'))
            end
            if stim == 1
                ylabel(response_name)
            end
            if stim > 1
               set(gca,'YTick',[])
            end
            set(gca, 'Color', 'k')
        end
        
    
    
end



end