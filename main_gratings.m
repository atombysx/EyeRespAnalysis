function [eye]=main_gratings(db)
addpath('\\zserver.cortexlab.net\Code\2photonPipeline');
addpath('\\zserver.cortexlab.net\Code\Matteobox');
addpath('\\zserver.cortexlab.net\Code\Neuropil Correction');
nDb = numel(db);
if nargin < 2
    save_data=0;
end

%% loop through sessions and load the data from the oris experiment
eye=[];
 total_exp=[];
for iDb = 1:nDb
   
    Db=db(iDb);
       stimType=Db.stimType;
    orisExp = ~cellfun(@isempty, strfind(stimType, 'oris'));
    sFtFExp = ~cellfun(@isempty, strfind(stimType, 'oriMultiSfTf'));
    plaidExp = ~cellfun(@isempty, strfind(stimType, 'plaid'));
    allExp = intersect(find(orisExp | sFtFExp | plaidExp), Db.expID);

   
    nExp = numel(allExp);
     for iExp = 1:nExp
        
        info{iDb, iExp} = ppbox.infoPopulateTempLFR(Db.mouse_name, Db.date, Db.expts(allExp(iExp))); % gather some metadata about this recording
        
        ballData = getRunningSpeed(info{iDb, iExp}); % load the running data for this experiment. Consider interpolating these to the same time stamps of the eye data
        
        eyeData =getEyeData_dev(info{iDb, iExp}, [], 0); % laod the eye data
        eye.area{iDb,iExp}=eyeData.area;
        eye.pupil{iDb, iExp}=eyeData.pupil;
        eye.x{iDb, iExp}=eyeData.x;
        eye.y{iDb, iExp}=eyeData.y;
        eye.ts{iDb, iExp}=eyeData.ts;
        ballData.total=interp1(ballData.t, ballData.total, eyeData.ts);
        eye.ball{iDb,iExp}=ballData;
      
 
     end
total_exp=[total_exp,nExp];
end
if ~ isempty(eye) 
    eye.combarea=cat(2,eye.area{:});
        eye.combpupil=cat(2,eye.pupil{:});
     eye.combx=cat(2,eye.x{:});
     eye.comby=cat(2,eye.y{:});
     eye.combts=cat(1,eye.ts{:});
      combball=cat(1,eye.ball{:});
     eye.combball=cat(1,combball(:).total);
end
print(sum(total_exp))
end

