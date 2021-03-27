function [ETAmat, ETA, ETAse, window] = magicETA(t, signal, etaT, periT, doBsl)
% t are the timestamps of each sample in signal. etaT are the event
% timestasmps you want to trigger the average to, periT is a 2 element
% vector that specifies the window around etaT to be considered

if nargin <5
    doBsl = true; 
end
%% one line magic peri-stimulus triggered average, courtesy of CB
if numel(periT) ==2
    window = linspace(periT(1), periT(2), range(periT)*10);
else
    window = periT;
end

bsl = periT(periT <0);
% ETAmat = interp1(t,signal,bsxfun(@plus,window,etaT'));
% [nStim, nRep] = size(etaT);
newT = permute(etaT, [2, 3, 1]);

ETAmat = interp1(t,signal,bsxfun(@plus,window,newT));
ETAbsl = prctile(interp1(t,signal,bsxfun(@plus,bsl,newT)), 50,2);
if doBsl
ETAmat = bsxfun(@minus,ETAmat, ETAbsl);
end
%% compute median resp and se
ETA = squeeze(nanmean(ETAmat,1));
ETAse = squeeze(nanstd(ETAmat,1,1)/sqrt(size(etaT,2)));

% %% plotting
% figure
% shadePlot(window, ETA(:,5), ETAse(:,5),'b');
end