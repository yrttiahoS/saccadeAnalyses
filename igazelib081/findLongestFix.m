function [startRow, endRow, duration] = findLongestFix(data, combx, comby, combval, aoi, accepted_validities, ttime)
%function [data, maxTime, cutrow] = findLongestFix(data, combx, comby, aoi)
% 
% Arguments
% Input:
% data - data in cell array, contains a "clip", i.e., trial or its segment
% combx, comby - columnumbers of x- and y-coordinate vectors
% aoi - aoi coordinates, [xstart xend ystart yend]
% Output:
% startRow - first data row when gaze reached aoi for the longest fixation
% endRow - last data row when gaze reached aoi for the longest fixation
% duration - duration of longest fixation

%get coordinate columns
x = data{combx};
y = data{comby};
time = data{ttime};

% Find vector of samples where gaze within aoi
% both coordinates inside the specific aoi
gazeInAoi = find((aoi(1) < x)  .* (x < aoi(2)) .* (aoi(3) < y) .* (y < aoi(4)));
% Find indices to longest consecutive samples 
inds = find(bwareafilt([0,diff(gazeInAoi)']==1,1));


% if no fixation found
if isempty(inds)
    startRow = 1;
    endRow = 1;
    duration = 0;
else
    inds = [inds(1)-1, inds];
    samples = gazeInAoi(inds);
    startRow = samples(1);
    endRow = samples(end);
    duration = time(endRow) - time(startRow);
end
% sig(a(result))
    



% %no more than n first fixations are considered
% counter = 
% 0;
% counterMax = 10;
% 
% %recursively look for longest fixation in data
% while ~isempty(data{1}) && counter < counterMax
%     %Extract row numbers of fixation start/end
%     first_time_in_aoi = gazeInAOIRow(data, combx, comby, aoi, 'first'); % data
%     last_time_in_aoi =  gazeInAOIRow(data, combx, comby, aoi, 'last'); % data
% 
%     %no fixation found break
%     if first_time_in_aoi == -1 
%         break;
%     end
%     
%     
%     %Compare to previous longest fixation
%     if (last_time_in_aoi - first_time_in_aoi) > duration
%         
%         fix_period_data = clipFirstRows(data, last_time_in_aoi);
%         fix_period_data = clipLastRows(data, first_time_in_aoi);
%         aoi_violation = AOIBorderViolationDuringNonValidSection(fix_period_data, combx, comby, combval, aoi, accepted_validities);
%        
%         if ~aoi_violation
%             startRow = first_time_in_aoi;
%             endRow = last_time_in_aoi;
%             duration = last_time_in_aoi - first_time_in_aoi;
%         end
%         
%     end
%     
%     % omit datarows that have been already processed to move forward 
%     % in hunting "next first" gaze in AOI row
%     data = clipLastRows(data, last_time_in_aoi);
%     disp(length(data{1}))
%     
%     counter = counter + 1;
% end
