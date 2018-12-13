function [mark, pupilValue] = findLightResponse(wave, minRow, maxRow, baselineCorrected)
% function [mark, pupilValue] = findLightResponse(wave, minRow, maxRow, baselineCorrected)

%What is it for:
%1: you can find the minimum pupil size within a window
%2: you can get a mark that shows ONE for peak and ZERO for other time values
% 
% Inputs:
% wave = vector of pupil response
% minRow = row index for the minimum time of analysis time window
% maxRow = row index for the maximun time of analysis time window
% baseline corrected = boolean indicating if the baseline is already subtracted
%     if not find reference value from the first sample of "wave"
% 
% Outputs:
%     mark = vector which is 1 for the peak and 0 otherwise
%     pupilValue = the pupil size at the minimum


%
%Ensure that the window does no extend beyond the lenght of the input
if maxRow > length(wave)
    maxRow = length(wave);
end

index = find(wave==min(wave(minRow:maxRow)),1,'first');
pupilValue = wave(index);

mark = zeros(1, length(wave));
mark(index) = 1;

if baselineCorrected == 0
    'Looking for baseline within analysis window: get MAX';
%    index = find(wave==max(wave(minRow:maxRow)),1,'first');
    index == 1;
    pupilValue = pupilValue - wave(index);
    mark(index) = 1;
end