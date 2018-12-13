function [DATA] = medianFilterData(DATA, winlen, column)
%Function [DATA] = medianFilterData(DATA, winlen, column)
%
% Performs median filtering to the datapoints with window-length winlen. 
% Winlen must be an odd integer where the window is equal length ((winlen-1)/2)
% in both directions centering in datapoint.
% Here datapoints must contain numbers, otherwise an error is presented.
% Column specifies the column to filter the data with

DATA{column} = medianFilter(DATA{column}, winlen);


function filtered_datapoints = medianFilter(datapoints, winlen)
% Function performs median filtering to the datapoints with window-length 
% winlen. Winlen must be an odd integer.
% Here datapoints must contain numbers, otherwise an error is presented.

% use odd number as winlen
%winlen = 21;

%disp(['Performing median filtering with window-length ' num2str(winlen) '...']);

% calculate padding length
padlen = (winlen-1)/2;

% form padding (first and last number repeated at the beginning and end)
datapoints_pad = zeros(length(datapoints) + 2*padlen,1);
datapoints_pad(1:padlen) = datapoints(1);
datapoints_pad(end-padlen:end) = datapoints(end);
datapoints_pad(padlen+1:end-padlen) = datapoints;

filtered_datapoints = zeros(size(datapoints));

% for each datapoint
for i=1:length(datapoints)
    
    wind = datapoints_pad(i:i+2*padlen);
    
    filtered_datapoints(i) = median(wind);
end

%disp('Done.');