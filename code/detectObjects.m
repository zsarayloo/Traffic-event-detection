function [centroids, bboxes] = detectObjects(mask)
        global obj
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
    