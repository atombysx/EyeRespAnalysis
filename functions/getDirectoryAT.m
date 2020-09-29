function [et_Movie_path] = getDirectoryAT( db )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
nDb = numel(db);

%% loop through sessions and load the data from the oris experiment

for iDb = 1:nDb
subject = db(iDb).mouse_name;
expDate = db(iDb).date;
for expid=1:length(db(iDb).expID)
exp =db(iDb).expts(db(iDb).expID(expid));

%series = datestr(expDate, 'yyyy-mm-dd');

info=ppbox.infoPopulateTempLFR(subject, expDate, exp);

% construct directories and filenames
etRepo_old  = '\\zserver.cortexlab.net\Data\EyeCamera';
et_processed = [expDate,'_', num2str(exp),'_',subject,'_eye.mj2'];
et_raw = [expDate,'_', num2str(exp),'_',subject,'_eye.mat'];
et_movie{iDb,expid} = [expDate,'_', num2str(exp),'_',subject,'_eye.mj2'];

if exist(fullfile(etRepo_old, subject, expDate, num2str(exp)))  
    
    etFolder{iDb,expid} = fullfile(etRepo_old, subject,expDate, num2str(exp));
    
else
    etFolder{iDb,expid} = info.folder2p;
end
et_Movie_path{iDb,expid} = fullfile(etFolder{iDb,expid}, et_movie{iDb,expid});

end
end
end

