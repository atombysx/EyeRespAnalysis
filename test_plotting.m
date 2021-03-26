% Number of cells per figure and of figures
% nroi=size(singleTrialResponses);
neur_tmp=singleTrialNeuron{1,1};
nRoi=size(neur_tmp,1);
kernelTimes=-2:1/30:(4-1/30);
if nRoi >= 10
    cellsPerFigure = 10;
else
    cellsPerFigure = nRoi;
end
colors = jet(ceil(nRoi * 1.1));
colors = colors(end-nRoi+1 : end, :);
nFigures = ceil(nRoi/ cellsPerFigure);
rows = cellsPerFigure;

[nStim,~]=size(singleTrialNeuron);
% cols = nStim;
% for fig = 1: nFigures
%     figure;
%     for neuron = 1:min(cellsPerFigure, nRoi-(fig-1)*cellsPerFigure)
%         neuronID = (fig-1)*cellsPerFigure + neuron;
%         %in each stimulus, averages of all trials in each mouse are
%         %calculated
%         for stim = 1:nStim
%             %extract 2D matrix during one stimulus
%             resp_tmp = squeeze(singleTrialNeuron{stim});
%             resp=squeeze(resp_tmp(neuronID,:,:));
%             [no_trial,trace_stamps]=size(resp);
%             %calculate the mean across all trials
%             kernel = nanmean(resp,1);
%             %calculate the standard error
%             ste=nanstd(resp,1)./((no_trial).^(0.5));
% 
%             subplot(rows, cols, (neuron-1)*cols+stim)
%             
%             %plot the mean trace of each mouse with its standard error
%             shadePlot(kernelTimes,kernel,ste,'c')
%             hold on
%             xlim(kernelTimes([1 end]))
%             
%              if neuron == min(cellsPerFigure, nRoi-(fig-1)*cellsPerFigure)
%             xlabel(string((stim-1)*45)+'\circ')
%              end
%              if neuron ~= min(cellsPerFigure, nRoi-(fig-1)*cellsPerFigure)
%                 axes('Color','none')
%              end
%             if stim == 1 && neuron== round(neuron/2)
%                 ylabel('pupil size d(A/A0)')
%             end
%             if stim > 1
%                set(gca,'YTick',[])
%             end
%             set(gca,'Color','w','fontsize',20)
%         end
%         
%     
%     
%     end
% end
% % 
% for fig = 1: nFigures
%     figure;
%     for neuron = 1:min(cellsPerFigure, nRoi-(fig-1)*cellsPerFigure)
%         neuronID = (fig-1)*cellsPerFigure + neuron;
%         %in each stimulus, averages of all trials in each mouse are
%         %calculated
%         for stim = 1:nStim
%             %extract 2D matrix during one stimulus
%             resp_tmp = squeeze(singleTrialNeuron{stim});
%             resp=squeeze(resp_tmp(neuronID,:,:));
%             [no_trial,trace_stamps]=size(resp);
%             %calculate the mean across all trials
%             kernel = nanmean(resp,1);
%             %calculate the standard error
%             ste=nanstd(resp,1)./((no_trial).^(0.5));
%             pupil_size_tmp=squeeze(singleTrialArea{stim});
%             pupil_size=squeeze(pupil_size_tmp);
%             pupil_kernel=nanmean(pupil_size,1)./1000;
%             pupil_ste=nanstd(pupil_size,1)./((no_trial).^(0.5));
%             subplot(rows, cols, (neuron-1)*cols+stim)
%             
%             %plot the mean trace of each mouse with its standard error
%             shadePlot(kernelTimes,kernel,ste,'c')
%             hold on
%             shadePlot(kernelTimes,pupil_kernel,pupil_ste,'g')
%             hold on
%             xlim(kernelTimes([1 end]))
%             
%              if neuron == min(cellsPerFigure, nRoi-(fig-1)*cellsPerFigure)
%             xlabel(string((stim-1)*45)+'\circ')
%              end
%              if neuron ~= min(cellsPerFigure, nRoi-(fig-1)*cellsPerFigure)
%                 axes('Color','none')
%              end
%             if stim == 1 && neuron== round(neuron/2)
%                 ylabel('pupil size d(A/A0)')
%             end
%             if stim > 1
%                set(gca,'YTick',[])
%             end
%             set(gca,'Color','w','fontsize',20)
%         end
%         
%     
%     
%     end
% end
% mean_resp=zeros(nRoi,nStim);
% for neuronID=1:nRoi
%     for stim=1:nStim
%                     %extract 2D matrix during one stimulus
%                 resp_tmp = squeeze(singleTrialNeuron{stim});
%                 resp=squeeze(resp_tmp(neuronID,:,61:120));
%                 [no_trial,trace_stamps]=size(resp);
%                 %calculate the mean across all trials
%                 kernel = nanmean(resp,1);
% 
%                 %calculate the standard error
%                 ste=nanstd(resp,1)./((no_trial).^(0.5));
%                 pupil_size_tmp=squeeze(singleTrialArea{stim});
%                 pupil_size=squeeze(pupil_size_tmp(:,61:120));
%                 pupil_kernel=nanmean(pupil_size,1);
%                 pupil_ste=nanstd(pupil_size,1)./((no_trial).^(0.5));
%                 if nanmean(kernel)>=0
%                 mean_resp(neuronID,stim)=log10(nanmean(pupil_kernel)./nanmean(kernel));
%                 else
%                 mean_resp(neuronID,stim)=-log10(-nanmean(pupil_kernel)./nanmean(kernel));
%                 end
% 
%     end
% end
% 
% figure;imagesc(mean_resp);
% xlabel('Stimulus  ID');
% ylabel('ROI ID');
% ax=colorbar;
% colormap hsv
nFigures=1;
cellsPerFigure=1;

for fig = 1: nFigures
   
    for neuron = 1:min(cellsPerFigure, nRoi-(fig-1)*cellsPerFigure)
        neuronID = (fig-1)*cellsPerFigure + neuron;
        maxi = -Inf;
        mini = Inf;
        for stim = 1:nStim
            Aresp_tmp = squeeze(singleTrialA{stim});
            %calculate the mean of x and y across all trials during stimuli
            A_resp_tmp = squeeze(Aresp_tmp(:,61:120));
            A_resp=A_resp_tmp-A_resp_tmp(:,1);
            A_kernel(stim,:) = nanmean(A_resp);

            Eresp_tmp=squeeze(singleTrialE{stim});
            E_resp_tmp = squeeze(Eresp_tmp(:,61:120));
            E_resp=E_resp_tmp-E_resp_tmp(:,1);
            E_kernel(stim,:) = nanmean(E_resp);
        end

     figure
     color = hsv(8); 
     color = cat(1, color, [0 0 0]);
     hold on
     for col=1:8
      plot(A_kernel(col,:)',E_kernel(col,:)','color',color(col,:))
      plot(A_kernel(col,1),E_kernel(col,1),'marker','o','MarkerEdgeColor','k','MarkerFaceColor',color(col,:))
      plot(A_kernel(col,end),E_kernel(col,end),'marker','s','MarkerEdgeColor','k','MarkerFaceColor',color(col,:))
      hold on
     end
           xlim([-0.02,0.02])
             ylim([-0.02,0.02])
             xlabel(' Azimuth')
             ylabel('Elevation')
             
             axis square 
% %                 title(resp_title)
            set(gca,'fontsize',20)
    end
       

end  
%color legends for orientation gratings
figure;
oris = 0:45:315;
cmap = hsv(360);
for io = 1:8
    plot([0, cosd(oris(io))], [0, sind(oris(io))], 'Color', cmap(oris(io)+1,:));
    hold on
end
axis square



figure;
for stim = 1:nStim
            Aresp_tmp = squeeze(singleTrialA{stim});
            %calculate the mean of x and y across all trials during stimuli
            A_resp=Aresp_tmp-Aresp_tmp(:,61);
            A_resp_start = squeeze(A_resp(:,61));
            A_resp_end  = squeeze(A_resp(:,120));
            
            

            Eresp_tmp=squeeze(singleTrialE{stim});
            E_resp=Eresp_tmp-Eresp_tmp(:,61);
             E_resp_start = squeeze(E_resp(:,61));
            E_resp_end  = squeeze(E_resp(:,120));
            
           
                 color = hsv(8); 
                color = cat(1, color, [0 0 0]);
            
            subplot(2,4,stim)
            scatter(A_resp_start,E_resp_start,'marker','o','MarkerEdgeColor','k');
            hold on
            scatter(A_resp_end,E_resp_end,'marker','s','MarkerEdgeColor','g');
            xlim([-0.1,0.1])
            ylim([-0.1,0.1])
                  title([num2str((stim-1)*45),'degree'])
end
figure;
for stim = 1:nStim
            Aresp_tmp = squeeze(singleTrialA{stim});
            %calculate the mean of x and y across all trials during stimuli
            A_resp=Aresp_tmp-Aresp_tmp(:,61);
            A_resp_points = squeeze(A_resp(:,61:120));
            
            
            

            Eresp_tmp=squeeze(singleTrialE{stim});
            E_resp=Eresp_tmp-Eresp_tmp(:,61);
             E_resp_points = squeeze(E_resp(:,61:120));
            
            
            AE_angles=atan2(E_resp_points,A_resp_points);
            AE_angles=AE_angles(~isnan(AE_angles));
                 color = hsv(8); 
                color = cat(1, color, [0 0 0]);
            
            subplot(2,4,stim)
            polarhistogram(AE_angles,30)
            
            
            w=ones(size(AE_angles));
            img_all = sum(w.*exp(1i*AE_angles),'omitnan');
            r=abs(img_all)./sum(w)*100;
      phi = angle(img_all);
      hold on;
      zm = r*exp(1i*phi);
      polarplot([0 phi],[0 r],'linewidth',2,'color','r')
      hold off;
      title([num2str((stim-1)*45),'degree'])
end
figure;
for stim = 1:nStim
            Aresp_tmp = squeeze(singleTrialA{stim});
            %calculate the mean of x and y across all trials during stimuli
            A_resp=Aresp_tmp-Aresp_tmp(:,61);
            
            [A_ntrial,~]=size(A_resp);
            A_resp=reshape(A_resp(:,61:120),A_ntrial*60,1);

            

            Eresp_tmp=squeeze(singleTrialE{stim});
            E_resp=Eresp_tmp-Eresp_tmp(:,61);
            [E_ntrial,~]=size(E_resp);
            E_resp=reshape(E_resp(:,61:120),E_ntrial*60,1);
            edges=-0.05:0.001:0.05;
            [density,Aedges,Eedges]=histcounts2(A_resp,E_resp,edges,edges);
            
           
%                  color = hsv(8); 
%                 color = cat(1, color, [0 0 0]);
            
            subplot(2,4,stim)
            imagesc(Aedges,Eedges,density);
                  title([num2str((stim-1)*45),'degree'])
            colorbar
end
figure;
for stim = 1:nStim
            Aresp_tmp = squeeze(singleTrialA{stim});
            %calculate the mean of x and y across all trials during stimuli
            
            A_resp_start = squeeze(Aresp_tmp(:,61));
            A_resp_end  = squeeze(Aresp_tmp(:,120));
            
            

            Eresp_tmp=squeeze(singleTrialE{stim});
            
             E_resp_start = squeeze(Eresp_tmp(:,61));
            E_resp_end  = squeeze(Eresp_tmp(:,120));
            
           
                 color = hsv(8); 
                color = cat(1, color, [0 0 0]);
            
            subplot(2,4,stim)
            scatter(A_resp_start,E_resp_start,'marker','o','MarkerEdgeColor','k');
            hold on
            scatter(A_resp_end,E_resp_end,'marker','s','MarkerEdgeColor','g');
            xlim([-0.5,0])
            ylim([0,0.5])
                  title([num2str((stim-1)*45),'degree'])
end

figure;scatter(pupilA,pupilE)

            xlim([-0.6,0.6])
            ylim([0,0.6])

            
% 
% figure;            
% color = hsv(8);            
% for stim=1:nStim            
%                   Aresp_tmp = squeeze(singleTrialA{stim});
%             %calculate the mean of x and y across all trials during stimuli
%             A_resp_tmp = squeeze(Aresp_tmp(:,61:120));
%             
%             A_kernel(stim,:) = nanmean(A_resp_tmp);
% 
%             Eresp_tmp=squeeze(singleTrialE{1});
%             E_resp_tmp = squeeze(Eresp_tmp(:,61:120));
%             
%             E_kernel(stim,:) = nanmean(E_resp_tmp);
%             
%             R_kernel=ones(1,size(A_kernel,2));
%             [x_kernel(stim,:),y_kernel(stim,:),z_kernel(stim,:)]=sph2cart(A_kernel(stim,:),E_kernel(stim,:),R_kernel);
%             
% A_mean=nanmean(A_kernel(stim,:));
% E_mean=nanmean(E_kernel(stim,:));
% subplot(2,4,stim)
% [X,Y,Z] = sphere;
% 
% surf(X,Y,Z,'lineStyle',':')
% axis equal
% 
% colormap white
% alpha 0
% hold on
% plot3(x_kernel(stim,:),y_kernel(stim,:),z_kernel(stim,:),'color',color(stim,:))
% xlim([-1,1])
% ylim([-1,1])
% zlim([-1,1])
%  
%      color = cat(1, color, [0 0 0]);
% plot3(x_kernel(stim,1),y_kernel(stim,1),z_kernel(stim,1),'marker','o','MarkerEdgeColor','k','MarkerFaceColor',color(stim,:))
%  plot3(x_kernel(stim,end),y_kernel(stim,end),z_kernel(stim,end),'marker','s','MarkerEdgeColor','k','MarkerFaceColor',color(stim,:))
% end
% 
% 
% pupilR=ones(length(pupilA),1);
% [pupilX,pupilY,pupilZ]=sph2cart(pupilA,pupilE,pupilR);
% figure;plot3(pupilX,pupilY,pupilZ,'color','r');
% hold on
% [X,Y,Z] = sphere;

% surf(X,Y,Z,'lineStyle',':')
% axis equal
% view([60 30])
% colormap white



%
% Az = D(:,1);
% El = D(:,2);
% Rd = D(:,3);
% cn = ceil(max(El));                                             % Number Of Colors
% cm = colormap(jet(cn));
% figure
% polarscatter(Az*pi/180, Rd, [], cm(fix(El),:), 'filled')
% grid on
% figure;
% 
% plot(1:length(traces(:,1)),traces(:,5))
% hold on
% [trials,n]=size(a);
% for trial=1:trials
% % trial_lines=2*ones(trials,1);
% xline(a(trial,4),'r')
% xline(a(trial,5),'g')
% end
figure;
for fig = 1: nFigures
   
    for neuron = 1:min(cellsPerFigure, nRoi-(fig-1)*cellsPerFigure)
        neuronID = (fig-1)*cellsPerFigure + neuron;
        maxi = -Inf;
        mini = Inf;
        for stim = 1:nStim
            Aresp_tmp = squeeze(singleTrialA{stim});
            %calculate the mean of x and y across all trials during stimuli
            A_resp_tmp = squeeze(Aresp_tmp(:,61:120));
            A_resp=A_resp_tmp-A_resp_tmp(:,1);
            A_kernel(stim,:) = nanmean(A_resp);
            diff_A=[0,diff(A_kernel(stim,:))];

            Eresp_tmp=squeeze(singleTrialE{stim});
            E_resp_tmp = squeeze(Eresp_tmp(:,61:120));
            E_resp=E_resp_tmp-E_resp_tmp(:,1);
            E_kernel(stim,:) = nanmean(E_resp);
            diff_E=[0,diff(E_kernel(stim,:))];
  

            subplot(4,2,stim)
            plot(kernelTimes(61:120),diff_A)
            ylim([-0.01 0.01])
        end
       
    end
end  
figure;
for fig = 1: nFigures
   
    for neuron = 1:min(cellsPerFigure, nRoi-(fig-1)*cellsPerFigure)
        neuronID = (fig-1)*cellsPerFigure + neuron;
        maxi = -Inf;
        mini = Inf;
        for stim = 1:nStim
            Aresp_tmp = squeeze(singleTrialA{stim});
            %calculate the mean of x and y across all trials during stimuli
            A_resp_tmp = squeeze(Aresp_tmp(:,61:120));
            A_resp=A_resp_tmp-A_resp_tmp(:,1);
            A_kernel(stim,:) = nanmean(A_resp);
            diff_A=[0,diff(A_kernel(stim,:))];

            Eresp_tmp=squeeze(singleTrialE{stim});
            E_resp_tmp = squeeze(Eresp_tmp(:,61:120));
            E_resp=E_resp_tmp-E_resp_tmp(:,1);
            E_kernel(stim,:) = nanmean(E_resp);
            diff_E=[0,diff(E_kernel(stim,:))];
  

            subplot(4,2,stim)
            plot(kernelTimes(61:120),diff_E)
            ylim([-0.01 0.01])
        end
       
    end
end  
figure;
for fig = 1: nFigures
   
    for neuron = 1:min(cellsPerFigure, nRoi-(fig-1)*cellsPerFigure)
        neuronID = (fig-1)*cellsPerFigure + neuron;
        maxi = -Inf;
        mini = Inf;
        for stim = 1:nStim
            Aresp_tmp = squeeze(singleTrialA{stim});
            %calculate the mean of x and y across all trials during stimuli
            A_resp_tmp = squeeze(Aresp_tmp(:,61:120));
            A_resp=A_resp_tmp-A_resp_tmp(:,1);
            A_kernel(stim,:) = nanmean(A_resp);
            diff_A=[0,diff(A_kernel(stim,:))];

            Eresp_tmp=squeeze(singleTrialE{stim});
            E_resp_tmp = squeeze(Eresp_tmp(:,61:120));
            E_resp=E_resp_tmp-E_resp_tmp(:,1);
            E_kernel(stim,:) = nanmean(E_resp);
            diff_E=[0,diff(E_kernel(stim,:))];
  

            subplot(4,2,stim)
            plot(diff_A,diff_E)
            xlim([-0.01 0.01])
            ylim([-0.01 0.01])
        end
       
    end
end  
figure;
for fig = 1: nFigures
   
    for neuron = 1:min(cellsPerFigure, nRoi-(fig-1)*cellsPerFigure)
        neuronID = (fig-1)*cellsPerFigure + neuron;
        maxi = -Inf;
        mini = Inf;
        for stim = 1:nStim
            Aresp_tmp = squeeze(singleTrialA{stim});
            %calculate the mean of x and y across all trials during stimuli
            A_resp_tmp = squeeze(Aresp_tmp(:,61:120));
            A_resp=A_resp_tmp-A_resp_tmp(:,1);
            A_kernel(stim,:) = A_resp(1,:);
            diff_A=[0,diff(A_kernel(stim,:))];

            Eresp_tmp=squeeze(singleTrialE{stim});
            E_resp_tmp = squeeze(Eresp_tmp(:,61:120));
            E_resp=E_resp_tmp-E_resp_tmp(:,1);
            E_kernel(stim,:) = E_resp(1,:);
            diff_E=[0,diff(E_kernel(stim,:))];
  
            movement=(diff_A.^2+diff_E.^2).^0.5;
            subplot(4,2,stim)
            plot(kernelTimes(61:120),movement)
%             xlim([-0.01 0.01])
%             ylim([-0.01 0.01])
        end
       
    end
end  
