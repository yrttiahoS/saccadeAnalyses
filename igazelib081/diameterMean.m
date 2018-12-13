function [diameter] = diameterMean(DATA, xcol)
%Function [percentage] = gazeInAOIPercentage(DATA, HEADERS, xcol, ycol, timecol)
%
% Returns the percentage of time when gaze is inside the area aoi. If the
% user does not enter aoi, then -1 is returned. Gaze 
% aoicoord = [xmin xmax ymin ymax] specified in the x and y pixel
% coordinates that are beign used (likely ranging from 0..1).

d = DATA{xcol};
diameter = mean(d(find(d>=0)));
%diameter = min(d(find(d>=0)));

%diameter = mean(DATA{xcol});

% disp(['Calculate mean diameter [' num2str(aoicoord(1)) ' ' num2str(aoicoord(2)) ' ' ...
%       num2str(aoicoord(3)) ' ' num2str(aoicoord(4)) ']...']);
% 
% rowcount = rowCount(DATA);
% 
% % find the time when gaze goes out of the aoi
% time_inside = 0;
% total_time = 0;
% 
% for i=2:rowcount
%     
%     x = DATA{xcol}(i);
%     y = DATA{ycol}(i);
%     
%     % how much time did this datapoint last?
%     dpointtime = DATA{timecol}(i) - DATA{timecol}(i-1);
%     
%     % both coordinates inside the specific aoi
%     if (aoicoord(1) < x  && x < aoicoord(2)) && (aoicoord(3) < y && y < aoicoord(4))
%         time_inside = time_inside + dpointtime;
%     end
%     total_time = total_time + dpointtime;
% end
% 
% % avoid the dividing by zero
% if total_time ==0
%     percentage = -1;
% else
%     percentage = time_inside / total_time;
% end

disp('Done.');