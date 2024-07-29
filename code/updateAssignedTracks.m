function updateAssignedTracks(assignments)
         global centroids
         global bboxes
         global tracks
        numAssignedTracks = size(assignments, 1);
        for i = 1:numAssignedTracks
            trackIdx = assignments(i, 1);
            detectionIdx = assignments(i, 2);
            centroid = centroids(detectionIdx, :);
            bbox = bboxes(detectionIdx, :);

            correct(tracks(trackIdx).kalmanFilter, centroid);

            tracks(trackIdx).bbox = bbox;

            tracks(trackIdx).age = tracks(trackIdx).age + 1;

            tracks(trackIdx).totalVisibleCount = ...
                tracks(trackIdx).totalVisibleCount + 1;
            tracks(trackIdx).consecutiveInvisibleCount = 0;
        end
    end