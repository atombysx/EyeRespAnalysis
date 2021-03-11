

% - Get lists of clean fluorescence frames for each stimulus presentation period
cvnFluorFrameInds = arrayfun(@clean_frames, stimSet.('start_frame'), stimSet.('end_frame'), vbDirtyStart, vbDirtyEnd,vnFluoresenceTimeIndices, 'UniformOutput', false);
% - Helper function for computing the stimulus response metric over a set
% of frames

   function vnFluorFrames = clean_frames(nStart, nEnd, bDirtyStart, bDirtyEnd,vnFluoresenceTimeIndices)
        [~, vnFluorFrames] = ismember((double(nStart) + double(bDirtyStart)):(double(nEnd) - double(bDirtyEnd)), vnFluoresenceTimeIndices);
   end