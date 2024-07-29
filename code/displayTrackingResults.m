function [newF, newM]=displayTrackingResults(frame,mask)
        global tracks
        
               
        frame = im2uint8(frame);
        mask = uint8(repmat(mask, [1, 1, 3])) .* 255;

        minVisibleCount = 8;
        if ~isempty(tracks)

            
            reliableTrackInds = ...
                [tracks(:).totalVisibleCount] > minVisibleCount;
            reliableTracks = tracks(reliableTrackInds);

           if ~isempty(reliableTracks)
                bboxes = cat(1, reliableTracks.bbox);

                ids = int32([reliableTracks(:).id]);

               
                labels = cellstr(int2str(ids'));
                predictedTrackInds = ...
                    [reliableTracks(:).consecutiveInvisibleCount] > 0;
                isPredicted = cell(size(labels));
                isPredicted(predictedTrackInds) = {' predicted'};
                labels = strcat(labels, isPredicted);

                frame = insertObjectAnnotation(frame, 'rectangle', ...
                    bboxes, labels);

                mask = insertObjectAnnotation(mask, 'rectangle', ...
                    bboxes, labels);
            end
        end

         
        newM=mask;
        newF=frame;


    end