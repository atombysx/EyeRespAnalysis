%\\zubjects\Subjects\FR141%
i =0;

i =0;

i = i+1;
db(i).mouse_name    = 'FR141';
db(i).date          = '2019-05-03';
db(i).expts         = [2 3 5 7 8];
db(i).waveL         = [1000 1000 1000 1000 760];
db(i).expID         = 1:4;
db(i).stimType      = {'spontaneous', 'spontaneous', 'spontaneous', 'oris', 'oris'}; % grey grey dark
db(i).starterID     = 1;
db(i).ObjZ          = 20;
db(i).starterYXPlane =  [258, 237,4];
db(i).day = 1;

i = i+1;
db(i).mouse_name    = 'FR141';
db(i).date          = '2019-05-06';
db(i).expts         = [1 2 3 4 5 6 7];
db(i).waveL         = [900 900 900 900 900 780 1020];
db(i).expID         = [1:5];
db(i).stimType      = {'oris', 'spontaneous', 'sparseNoise', 'naturalImages', ...
    'naturalImages', 'oris', 'oris'};
db(i).starterID     = 1;
db(i).ObjZ          = 70;
db(i).starterYXPlane =  [257, 255, 4];

i = i+1;
db(i).mouse_name    = 'FR141';
db(i).date          = '2019-05-08';
db(i).expts         = [1 2 3 4];
db(i).waveL         = [910 910 1020 780];
db(i).expID         = 1:2;
db(i).stimType      = {'sparseNoise', 'oris'};
db(i).starterID     = 1;
db(i).ObjZ          = 20;
db(i).starterYX =  [257, 255];

i = i+1;
db(i).mouse_name    = 'FR141';
db(i).date          = '2019-05-08';
db(i).expts         = [6 7 8 9 10];
db(i).expID         = [1 3];
db(i).stimType      = {'sparseNoise', 'oris'};
db(i).waveL         = [910 780 910 910 1020];
db(i).starterID     = 1;
db(i).ObjZ          = 20+90;
db(i).starterYX =  [257, 255];

i = i+1;
db(i).mouse_name    = 'FR141';
db(i).date          = '2019-05-09';
db(i).expts         = [1 2 3 4 5];
db(i).expID         = 1:2;
db(i).stimType      = {'sparseNoise', 'oriMultiSfTf'};
db(i).waveL         = [970 970 780 890 1020];
db(i).starterID     = 1;
db(i).ObjZ          = 20+90+125;
db(i).starterYX=  [257, 255];

i = i+1;
db(i).mouse_name    = 'FR141';
db(i).date          = '2019-05-09';
db(i).expts         = [6 7 8 9 10];
db(i).expID         = 1:2;
db(i).stimType      = {'sparseNoise', 'oriMultiSfTf'};
db(i).waveL         = [970 970 780 890 1020];
db(i).starterID     = 1;
db(i).ObjZ          = 20+90+125+125;
db(i).starterYX =  [257, 255];

% i = i+1;
% db(i).mouse_name    = 'FR141';
% db(i).date          = '2019-05-09';
% db(i).expts         = [11 12 13 14];
% db(i).expID         = 1;
% db(i).waveL         = [970 780 890 1020];
% db(i).starterID     = 1;
% db(i).ObjZ          = 90+125+125+125;


i = i+1;
db(i).mouse_name    = 'FR141';
db(i).date          = '2019-05-13';
db(i).expts         = [5 7 8 9];
db(i).expID         = 1:2;
db(i).stimType      = {'sparseNoise', 'oriMultiSfTf'};
db(i).starterID     = 1;
db(i).ObjZ          = 0;
db(i).waveL         = [890 890 780 1020];
db(i).starterYX =  [238, 246];

i = i+1;
db(i).mouse_name    = 'FR141';
db(i).date          = '2019-05-14';
db(i).expts         = [1 2 3 4];
db(i).expID         = 1:2;
db(i).stimType      = {'sparseNoise', 'oriMultiSfTf'};
db(i).starterID     = 1;
db(i).ObjZ          = 125;
db(i).waveL         = [890 890 780 1020];
db(i).starterYX =  [238, 246];


i = i+1;
db(i).mouse_name    = 'FR141';
db(i).date          = '2019-05-14';
db(i).expts         = [5 6 7 8 9];
db(i).expID         = 1:2;
db(i).stimType      = {'sparseNoise', 'oriMultiSfTf'};
db(i).starterID     = 1;
db(i).ObjZ          = 250;
db(i).waveL         = [970 970 890 780 1020];
db(i).starterYX =  [238, 246];

i = i+1;
db(i).mouse_name    = 'FR141';
db(i).date          = '2019-05-14';
db(i).expts         = [11 13 14 15 16];
db(i).expID         = 1:2;
db(i).stimType      = {'oriMultiSfTf', 'sparseNoise'};
db(i).starterID     = 1;
db(i).ObjZ          = 375;
db(i).waveL         = [970 970 890 780 1020];
db(i).starterYX =  [238, 246];

i = i+1;
db(i).mouse_name    = 'FR141';
db(i).date          = '2019-05-15';
db(i).expts         = [1 2 3 4];
db(i).expID         = 1:2;
db(i).stimType      = {'oriMultiSfTf', 'sparseNoise'};
db(i).starterID     = 1;
db(i).ObjZ          = 500;
db(i).waveL         = [970 970 890 1020];
db(i).starterYX =  [238, 246];

% %%
% 
% i = 0;
% i = i+1;
% dbPost(i).mouse_name    = 'FR141';
% dbPost(i).date          = '2019-04-29';
% dbPost(i).expts         = [1 2];
% dbPost(i).expID         = 1; 
% dbPost(i).starterID     = 1;
% dbPost(i).ObjZ          = 130; 
% dbPost(i).starterYXPlane =  [255, 255, 2];
