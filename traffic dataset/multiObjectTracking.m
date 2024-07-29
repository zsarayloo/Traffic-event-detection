% function multiObjectTracking()
clear all
clc
close all


global obj
global tracks
global centroids
global bboxes
global nextId


obj = setupSystemObjects();

tracks = initializeTracks(); % Create an empty array of tracks.

nextId = 1; % ID of the next track

% Detect moving objects, and track them across video frames.
while ~isDone(obj.reader)
    frame = readFrame();
    [centroids, bboxes, mask] = detectObjects(frame);
    predictNewLocationsOfTracks();
    [assignments, unassignedTracks, unassignedDetections] = ...
        detectionToTrackAssignment();

    updateAssignedTracks(assignments);
    updateUnassignedTracks(unassignedTracks);
    deleteLostTracks();
    createNewTracks(unassignedDetections);

    displayTrackingResults(frame,mask);
end