function [eyedata]  =   removeOutlier_AT(eye)
pupilA_average = mean(eye.pupil,'omitnan');%average of the pupil areas
pupilA_std = std(eye.pupil,'omitnan');%standard deviation of the pupil area
for i = 1:numel(eye.ts)
    if (eye.pupil(i) > pupilA_average + pupilA_std*3) || (eye.pupil(i) < pupilA_average + pupilA_std*3)
       eye.pupil(i) = pupilA_average;
       if i > 50 && i < numel(eye.ts)-50
            eye.pupil(i) = mean(eye.pupil(i-50:i+50),'omitnan');%replace the ith area with the local average
       elseif i >= numel(eye.ts)-50
           eye.pupil(i) = mean(eye.pupil(numel(eye.ts)-100:numel(eye.ts)),'omitnan');
       elseif i <= 50
           eye.pupil(i) = mean(eye.pupil(1:100),'omitnan'); %replace the ith area with the average of 1:100
       end
       pupilA_average=mean(eye.pupil,'omitnan');%new average
       pupilA_std = std(eye.pupil,'omitnan');%new std
    end
end
eyedata= eye;
end