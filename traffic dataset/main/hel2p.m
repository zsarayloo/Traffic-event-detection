%% vision.video play
clear all
clc

hmfr = vision.VideoFileReader('test.mpg');
 hvp = vision.VideoPlayer;
 
 while ~isDone(hmfr)
  frame = step(hmfr);
  step(hvp, frame);
 end

 release(hmfr);
 release(hvp);
 %% vision.ForegroundDetector
 

Track Cars:
    hsrc = vision.BinaryFileReader('Filename', 'viptraffic.bin');
    hfg = vision.ForegroundDetector(...
        'NumTrainingFrames', 5, ... % 5 because of short video
        'InitialVariance', 30*30); % initial standard deviation of 30

    hblob = vision.BlobAnalysis(...
        'CentroidOutputPort', false, ...
        'AreaOutputPort', false, ...
        'BoundingBoxOutputPort', true, ...
        'MinimumBlobAreaSource', 'Property', ...
        'MinimumBlobArea', 250);

    hsi = vision.ShapeInserter;

    hsnk = vision.VideoPlayer();

    while ~isDone(hsrc)
        frame = step(hsrc);
        fgMask = step(hfg, frame);
        bbox = step(hblob, fgMask);
       if ~isempty(bbox)
            out =  step(hsi, frame, bbox); % draw bounding boxes around cars
            step(hsnk, out); % view in video player
        end
    end

    release(hsnk);
    release(hsrc);
    %% vision.BlobAnalysis