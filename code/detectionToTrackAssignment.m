    function [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignment()
        global tracks
        global centroids

        nTracks = length(tracks);
        nDetections = size(centroids, 1);

        cost = zeros(nTracks, nDetections);
        for i = 1:nTracks
            cost(i, :) = distance(tracks(i).kalmanFilter, centroids);
        end

        costOfNonAssignment = 20;
        [assignments, unassignedTracks, unassignedDetections] = ...
            assignDetectionsToTracks(cost, costOfNonAssignment);


    end