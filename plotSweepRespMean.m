function plotSweepRespMean(responses, kernelTimes)



[nRoi, nStim, x , y] = size(responses);

kernelTimesPatch  = [kernelTimes, fliplr(kernelTimes)]';
res=permute(squeeze(responses),[2 3 1]);
resp=reshape(res,[x,nStim*y]);
kernel = nanmean(resp, 1);
std_kernel=nanstd(resp,1);
kerneltimes=[];
for k=1:nStim
    kerneltimes=[kerneltimes,kernelTimes+k*6-2];
end
figure
scatter(kerneltimes(:),kernel(:),'r.','jitter','on','jitterAmount',0.05);



end