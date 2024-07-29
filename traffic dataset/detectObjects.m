function [centroids, bboxes] = detectObjects(mask)
        global obj
        % Detect foreground.
%             frame=remove_nois(frame);% remove noise with median filter

%         mask = obj.detector.step(frame);

        % Apply morphological operations to remove noise and fill in holes.
%         mask = imopen(mask, strel('rectangle', [3,3]));
%         mask = imclose(mask, strel('rectangle', [15, 15]));
%         mask = imfill(mask, 'holes');

        % Perform blob analysis to find connected components.
        [~, centroids, bboxes] = obj.blobAnalyser.step(mask);
        
         H= regionprops(mask,'Extent');
         num=size(centroids);
      if num(1)~0   
      for i=1:num(1)
           ex(1,i)=H(i).Extent;
      end
        channel=find(ex<0.394);
        centroids(channel,:)=[];
        bboxes(channel,:)=[];
      end
      
        
end
    