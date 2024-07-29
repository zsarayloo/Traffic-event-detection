% main-tracking
% simulation of traffic video processing

clear all
clc
close all
%global variable
global obj
global tracks
global centroids
global bboxes
global nextId

% Pull local state out.
gamma  = 0.05;
tau    =40;
radius = 3;
 % ID of the next track
nextId = 1;

%% initialize

Vid=VideoReader('vid (5).mpg');%select video

pixel=200; % minimum pixel of object

obj =  setup_Objects(pixel);

tracks = initial_Tracks(); % Create an empty array of tracks.





numFrames = Vid.NumberOfFrames;% get number of frame
frameRate = get(Vid,'FrameRate')% get frame rate
video = read(Vid, [1 numFrames]);% read all frame of video

vidHeight = Vid.Height;
vidWidth = Vid.Width;
Vid_gray(1:numFrames) =struct('cdata',zeros(vidHeight,vidWidth,1,'uint8'),...
    'colormap',[]);% generate structure for convert RGB2gray

%% preprocessing
% convert2 grayscale

for k =1: numFrames

    I=read(Vid,k);
    
    T0=medfilt2(rgb2gray(I));%convert frame k to gray scal and remove noise with median filter
    %image enhancement
    T0=imadjust(T0);% adjust contrast
%     H = fspecial('unsharp');
%     T0= imfilter(T0,H,'replicate');% sharp image
    Vid_gray(k).cdata =T0;
    
    Im(:,:,k)=Vid_gray(k).cdata;%frame2im

end


% implay(Vid_gray)

[med_Im]=stocha_pixel(Im);% calculate Mean,median and std of pixel through all frames


%% method1:substract background

% Vid_mask_sub(1:numFrames) =struct('cdata',zeros(vidHeight,vidWidth,1,'uint8'),...
%     'colormap',[]);% generate structure for convert RGB2gray
% 
% 
%  background=med_Im;
%  
% for k=1:numFrames
%     frame=Im(:,:,k);
%     T= abs(background - frame) > tau;
%     mask = imopen(T, strel('rectangle', [3,3]));
%     mask = imclose(mask, strel('rectangle', [15, 15]));
%     mask = imfill(mask, 'holes');
%     
%     Vid_mask_sub(k).cdata =mask;
%     
% end





%% method 2: gaussian method

% Vid_mask_gaussian(1:numFrames) =struct('cdata',zeros(vidHeight,vidWidth,1,'uint8'),...
%     'colormap',[]);% generate structure for convert RGB2gray
% 
% detector = vision.ForegroundDetector('NumGaussians', 5, ...
%             'NumTrainingFrames', 30, 'MinimumBackgroundRatio', 0.7);
% for i=1:numFrames
%        frame=Im(:,:,i)
%         mask = detector.step(frame);
% 
%         % Apply morphological operations to remove noise and fill in holes.
%         mask = imopen(mask, strel('rectangle', [3,3]));
%         mask = imclose(mask, strel('rectangle', [15, 15]));
%         mask = imfill(mask, 'holes');
%         Vid_mask_gaussian(i).cdata=mask;
%         
% end
% 
%         


%% method3 : proposed mathod


Vid_mask(1:numFrames) =struct('cdata',zeros(vidHeight,vidWidth,1,'uint8'),...
    'colormap',[]);% generate structure for convert RGB2gray


for k=1:numFrames
    frame=Im(:,:,k);
    if k==1
        background=med_Im;
    else
            frame0=Im(:,:,k-1);

        % Rolling average update.
        background = gamma * (frame0) + (1 - gamma) * background;
    end
    T= abs(background - frame) > tau;
    
    T1 = imclose(T, strel('disk', radius));
    
    mask = imopen(T, strel('rectangle', [3,3]));
    mask = imclose(mask, strel('rectangle', [15, 15]));
    mask = imfill(mask, 'holes');
    
    Vid_mask(k).cdata =mask;
    
end

% implay(Vid_mask,frameRate)
% 
% mask=Vid_mask(223).cdata;
% 

%% tracking
Vid_mask2(1:numFrames) =struct('cdata',zeros(vidHeight,vidWidth,1,'uint8'),...
    'colormap',[]);% generate structure for convert RGB2gray
Vid_im(1:numFrames) =struct('cdata',zeros(vidHeight,vidWidth,1,'uint8'),...
    'colormap',[]);% generate structure for convert RGB2gray

for i=1:numFrames
    frame = Vid_gray(i).cdata;
    mask=Vid_mask(i).cdata;
    [centroids, bboxes] = detectObjects(mask);
    predictNewLocationsOfTracks();
    [assignments, unassignedTracks, unassignedDetections] = ...
        detectionToTrackAssignment();

    updateAssignedTracks(assignments);
    updateUnassignedTracks(unassignedTracks);
    deleteLostTracks();
    createNewTracks(unassignedDetections);

    [newF, newM]= displayTrackingResults(frame,mask);
    Vid_mask2(i).cdata=newM;
    Vid_im(i).cdata=newF;

end




%% write video
% writerObj=VideoWriter('vid (5).mpgLabel');
% writerObj.FrameRate=frameRate;
% open(writerObj);
% 
% for k = 1:numFrames
%    img =  Vid_im(k).cdata;
%    writeVideo(writerObj,img);
% end
% 
% 
% close(writerObj);