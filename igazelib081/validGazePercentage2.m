function [rpercentage, lpercentage] = validGazePercentage2(DATA, HEADERS,valcol, accepted_validities)
%Function [rpercentage, lpercentage] = validGazePercentage(DATA, HEADERS, accepted_validities)
%
% Function examines data and returns the amount of valid data. Accepted
% validities contains the validity marks to be considered "good".

%disp('Calculating validity percentage...');

rval = valcol;
lval = valcol;

% calculate the count of good data (value in the column 0)
rtotal = length(DATA{rval});
rgood = length(DATA{rval}(ismember(DATA{rval}, accepted_validities)));

ltotal = length(DATA{lval});
lgood = length(DATA{lval}(ismember(DATA{lval}, accepted_validities))); %BUG corrected: this read the rval

rpercentage = rgood/rtotal;
lpercentage = lgood/ltotal;

%valid_percentage = mean([rpercentage lpercentage]);

%disp('Done.');

%%% TODO: TEST THAT THIS WORKS CORRECTLY