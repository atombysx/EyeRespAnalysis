function [ output_args ] =plotSweepRespAxisTrace( x_response,y_response,resp_title,limit )
%plot eye movement traces to different gratings
%  input x and y coordinates responses
[nRoi, nStim,~,~ ] = size(x_response);
if nRoi >= 10
    cellsPerFigure = 10;
else
    cellsPerFigure = nRoi;
end


nFigures = ceil(nRoi/ cellsPerFigure);

for fig = 1: nFigures
   
    for neuron = 1:min(cellsPerFigure, nRoi-(fig-1)*cellsPerFigure)
        neuronID = (fig-1)*cellsPerFigure + neuron;
        maxi = -Inf;
        mini = Inf;
        for stim = 1:nStim
            %calculate the mean of x and y across all trials during stimuli
            x_resp = -squeeze(x_response(neuronID, stim, :,15:40));
            x_kernel(stim,:) = nanmean(x_resp);

            
            y_resp = squeeze(y_response(neuronID, stim, :,15:40));
            y_kernel(stim,:) = nanmean(y_resp);
%             subplot(5,3,stim)
%            
%            
%             
%             hold on
%             plot(x_resp',y_resp')
%            xlim([-30,30])
%            ylim([-30,30])
%            axis square
%             if stim <13
%             xlabel(string((stim-1)*30)+'\circ')
%             else 
%                 xlabel('no stimulus')
%             end
%             if stim == 1
%                 ylabel('coordinate eye trace')
%             end
%             
%             set(gca, 'Color', 'w')
%             title(resp_title)
        end
        x_180=0:0.1:5;
        x_0=-5:0.1:0;
     figure
     color = hsv(12); 
     color = cat(1, color, [0 0 0]);
     hold on
     for col=1:13
      plot(x_kernel(col,:)',y_kernel(col,:)','color',color(col,:))
      plot(x_kernel(col,1),y_kernel(col,1),'marker','o','MarkerEdgeColor','k','MarkerFaceColor',color(col,:))
      plot(x_kernel(col,end),y_kernel(col,end),'marker','s','MarkerEdgeColor','k','MarkerFaceColor',color(col,:))
     end
%      plot(x_kernel(2,:)',y_kernel(2,:)','color',color(2,:))
%      plot(x_kernel(2,1),y_kernel(2,1),'marker','x','color','k')
%       plot(x_kernel(2,end),y_kernel(2,end),'marker','s','color','k')
%      plot(x_kernel(3,:)',y_kernel(3,:)','color',color(3,:))
%      plot(x_kernel(3,1),y_kernel(3,1),'marker','x','color','k')
%       plot(x_kernel(3,end),y_kernel(3,end),'marker','s','color','k')
%      plot(x_kernel(4,:)',y_kernel(4,:)','color',color(4,:))
%      plot(x_kernel(4,1),y_kernel(4,1),'marker','x','color','k')
%       plot(x_kernel(4,end),y_kernel(4,end),'marker','s','color','k')
%      plot(x_kernel(5,:)',y_kernel(5,:)','color',color(5,:))
%      plot(x_kernel(5,1),y_kernel(5,1),'marker','x','color','k')
%       plot(x_kernel(5,end),y_kernel(5,end),'marker','s','color','k')
%      plot(x_kernel(6,:)',y_kernel(6,:)','color',color(6,:))
%       plot(x_kernel(6,1),y_kernel(6,1),'marker','x','color','k')
%       plot(x_kernel(6,end),y_kernel(6,end),'marker','s','color','k')
%     plot(x_kernel(7,:)',y_kernel(7,:)','color', color(7,:))
%      plot(x_kernel(7,1),y_kernel(7,1),'marker','x','color','k')
%       plot(x_kernel(7,end),y_kernel(7,end),'marker','s','color','k')
%     plot(x_kernel(8,:)',y_kernel(8,:)','color',color(8,:))
%      plot(x_kernel(8,1),y_kernel(8,1),'marker','x','color','k')
%       plot(x_kernel(8,end),y_kernel(8,end),'marker','s','color','k')
%      plot(x_kernel(9,:)',y_kernel(9,:)','color',color(9,:))
%       plot(x_kernel(9,1),y_kernel(9,1),'marker','x','color','k')
%       plot(x_kernel(9,end),y_kernel(9,end),'marker','s','color','k')
%      plot(x_kernel(10,:)',y_kernel(10,:)','color',color(10,:))
%       plot(x_kernel(10,1),y_kernel(10,1),'marker','x','color','k')
%       plot(x_kernel(10,end),y_kernel(10,end),'marker','s','color','k')
%      plot(x_kernel(11,:)',y_kernel(11,:)','color',color(11,:))
%       plot(x_kernel(11,1),y_kernel(11,1),'marker','x','color','k')
% %       plot(x_kernel(11,end),y_kernel(11,end),'marker','s','color','k')
%      plot(x_kernel(12,:)',y_kernel(12,:)','color',color(12,:))
%       plot(x_kernel(12,1),y_kernel(12,1),'marker','x','color','k')
%       plot(x_kernel(12,end),y_kernel(12,end),'marker','s','color','k')
%           plot(x_kernel(13,:)',y_kernel(13,:)','color',color(13,:))
%            plot(x_kernel(13,1),y_kernel(13,1),'marker','o','MarkerEdgeColor','k','MarkerFaceColor''k')
%       plot(x_kernel(13,end),y_kernel(13,end),'marker','s','MarkerEdgeColor','k','MarkerFaceColor','k')
%     plot3(x_kernel',y_kernel',times')
%     plot3(x_kernel{2}',y_kernel{2}',times,'color',[1 0.5 0.5])
%     plot3(x_kernel{3}',y_kernel{3}',times,'color','m')
%     plot3(x_kernel{4}',y_kernel{4}',times,'color',[0.5 0.5 1])
%     plot3(x_kernel{5}',y_kernel{5}',times,'color','c')
%     plot3(x_kernel{6}',y_kernel{6}',times,'color',[0.5 0.5 0.5])
%     plot3(x_kernel{7}',y_kernel{7}',times,'color', 'r')
%     plot3(x_kernel{8}',y_kernel{8}',times,'color',[0.5 0.5 0])
%     plot3(x_kernel{9}',y_kernel{9}',times,'color','g')
%     plot3(x_kernel{10}',y_kernel{10}',times,'color',[0 0.5 0.5])
%     plot3(x_kernel{11}',y_kernel{11}',times,'color','b')
%     plot3(x_kernel{12}',y_kernel{12}',times,'color',[0 0 0.5])
%     plot3(x_kernel{13}',y_kernel{13}',times,'color','k')
%      plot(x_180,x_180./2,'color',[0.5 0.5 0])
%      plot(x_180,x_180.*2,'color','g')
%      plot(x_180,zeros(1,51),'color', 'r')
%      plot(x_180,x_180.*(-1)./2,'color',[0.5 0.5 0.5])
%      plot(x_180,x_180.*(-2),'color','c')
%       plot(x_0,x_0./2,'color',[1 0.5 0.5])
%      plot(x_0,x_0.*2,'color','m')
%      plot(x_0,zeros(1,51),'color','y')
%      plot(x_0,x_0.*(-1)./2,'color',[0 0 0.5])
%      plot(x_0,x_0.*(-2),'color','b')
%      plot(zeros(1,51),x_180,'color',[0 0.5 0.5])
%      plot(zeros(1,51),flip(x_0),'color',[0.5 0.5 1])
    
             xlim(limit)
             ylim(limit)
             xlabel(' X axis(px)')
             ylabel('Y axis(px)')
             
             axis square 
                title(resp_title)
            set(gca,'fontsize',20)
    end
       

end  



end

