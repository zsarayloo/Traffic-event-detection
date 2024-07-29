hsrc = vision.BinaryFileReader('Filename', 'viptraffic.bin');
    hfg = vision.ForegroundDetector(...
        'NumTrainingFrames', 5, ... % 5 because of short video
        'InitialVariance', 30*30); % initial standard deviation of 30

    hblob = vision.BlobAnalysis(...
        'CentroidOutputPort', true, ...
        'AreaOutputPort', true, ...
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