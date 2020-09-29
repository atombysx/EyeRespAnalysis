[filename, filepath] = uigetfile('\\zubjects.cortexlab.net\Subjects\');
new_filename = [filename(1:end-4), '_inverted.mj2'];

vr = VideoReader(fullfile(filepath,filename));
nv = VideoWriter(fullfile(filepath,new_filename), 'Motion JPEG 2000');
open(nv);

for iFrame = 1:vr.duration*vr.FrameRate
    frame = imcomplement(read(vr, iFrame));
    writeVideo(nv, frame)    
    iFrame
end

close(nv);