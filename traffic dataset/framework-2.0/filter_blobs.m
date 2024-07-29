function T = filter_blobs(T, frame)
% FILTER_BLOBS - simple representer of targets as largest foreground bounding box.
%
% NOTE: This function is intended to be run as a REPRESENTER in the
% tracking framework.  See documentation for RUN_TRACKER.
%
% FILTER_BLOBS(T, frame) will represent the measurement for the
% frame in image 'frame' as the bounding box of the largest
% detected blob in the foreground of the frame.
%
% Parameters used from T.recognizer:
%  T.recognizer.blobs - the blobs detected in the foreground of frame.
% 
% Inputs:
%  T     - tracker state structure.
%  frame - image to process.
% 
% See also: run_tracker

% Make sure at lease one blob was recognized
if sum(sum(T.recognizer.blobs))
  % Extract the BoundingBox and Area of all blobs
  R = regionprops(T.recognizer.blobs, 'BoundingBox', 'Area');
  
  % And only keep the biggest one
%   [I, IX] = max([R.Area]);
  T.representer.BoundingBox = R.BoundingBox;
end
return