% testfile
clear all
close all
clc
%% avi

%aviread('',frame)%%include: cdata and color map for each frame
%my_movie = aviread(file_name, frame_nums);
%aviinfo('')

%imshow(my_movie(1).cdata)
%or
% image_data = uint8(zeros(file_info.Height, file_info.Width, 3, ...
% file_info.NumFrames));

%for store all frames as image

% for k = 1:file_info.NumFrames
% image_data(:,:,:,k) = my_movie(k).cdata;
% end
%montage(image_data)

% my_vid=mmreader('vid (2).mpg');
% 
% movie(my_vid)
% movie(my_vid, 5, 30)
% frames = [5 1:10];
% movie(my_vid, frames, 30)

% implay(my_vid)
% 
% old_img = frame2im(my_vid(10));
% movie_neg = my_movie;
% for k = 1:file_info.NumFrames
% cur_img = frame2im(movie_neg(k));
% new_img = imadjust(cur_img, [0 1], [1 0]);
% movie_neg(k) = im2frame(new_img);
% end
% implay(movie_neg)

% movie2avi(new_movie, file_name, ’compression’, ’None’);
%% other format

% obj = mmreader('vid (1).mp4');% INPUT video from file
obj=VideoReader('vid (5).mp4');
data = read(obj, Inf);
numFrames = obj.NumberOfFrames;

% video = read(obj, [1 obj.NumberOfFrames]);% read all frame of video

frameRate = get(obj,'FrameRate')% get frame rate
implay(data, frameRate)

nFrames = obj.NumberOfFrames;
vidHeight = obj.Height;
vidWidth = obj.Width;
mov(1:nFrames) =struct('cdata',zeros(vidHeight,vidWidth,1,'uint8'),...
    'colormap',[]);
%%

for k = 2 : nFrames
    T0=rgb2gray( read(obj,k-1));
    T1=rgb2gray( read(obj,k));
    new=abs(T1-T0);
    level=40/255;
    temp=im2bw(im2double(new),level);
%     new(new<40)=0;
%     se = strel('ball',5,5);
%     I2 = imdilate(new,se);
    
    mov(k).cdata =temp;
end

implay(mov,frameRate);




implay(movie_neg)


