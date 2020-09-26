function plotSweepResp(responses, kernelTimes, stimDur, justMean)

if nargin <4
    justMean = 0;
end

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
            kernel = nanmedian(resp, 1);
            subplot(rows, cols, (neuron-1)*cols+stim)
            hold on
            if ~justMean
            kernel = nanmedian(resp, 1);
            patch(repmat(kernelTimesPatch, 1, size(resp, 1)), ...
                [resp, fliplr(resp)]', 'k', 'EdgeColor', colors(neuronID,:), ...
                'EdgeAlpha', 0.3, 'FaceColor', 'none');
            else
            kernel = resp;
            end
            plot(kernelTimes, kernel, 'Color', colors(neuronID,:), 'LineWidth', 2)
            xlim(kernelTimes([1 end]))
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
                ylabel(sprintf('Cell %d', neuronID))
            end
            set(gca, 'Color', 'k')
        end
        
        range = maxi - mini;
        mini = mini - 0.01*range;
        maxi = maxi + 0.01*range;
        for stim = 1:nStim
            subplot(rows, cols, ((neuron-1)*cols)+stim)
            plot([0 0], [mini maxi], 'w:')
            plot([1 1]*stimDur, [mini maxi], 'w:')
             ylim([mini maxi])
%             ylim([-1 5])

            if neuron < min(cellsPerFigure, nRoi-(fig-1)*cellsPerFigure)
                set(gca, 'XTick', [])
            else
                xlabel('Time (s)')
            end
            if stim > 1
                set(gca, 'YTick', [])
            end
        end
    end
    
end



end