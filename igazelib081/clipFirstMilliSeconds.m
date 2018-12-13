function [DATA, maxTime, cutrow] = clipFirstMilliSeconds(DATA, HEADERS, millisec)
%Function [DATA] = clipFirstMilliSeconds(DATA, HEADERS, millisec)
%
% Returns the first millisec milliseconds of DATA in same format.
%maxTime = the TTETtime value of the last row
%cutRow = the row number of the last time

rowcount = rowCount(DATA);
colcount = columnCount(DATA);

% disp(['Picking first ' num2str(millisec) ' milliseconds from data using TETTime...']);
% disp(['Datamatrix contains ' num2str(rowcount) ' rows before operation.']);

TETTime = DATA{findColumnNumber(HEADERS, 'TETTime')};
% size(TETTime)
millisec_at_start = TETTime(1);

% if there are more rows than the ms limit
if millisec_at_start + millisec < TETTime(rowcount)
    
    cutrow = find(TETTime < millisec_at_start + millisec, 1, 'last');
    
    % put all the columns after numrows as blank
    for i=1:colcount
        DATA{i}(cutrow+1:rowcount) = [];
    end
    maxTime = TETTime(cutrow) - millisec_at_start;
else
    disp('The data contains less datapoint than the millisecond-count. Not cutting anything in "clipFirstMilliseconds".');
    cutrow = rowcount;
    maxTime = TETTime(rowcount) - millisec_at_start;
end

rowcount = rowCount(DATA);

if isempty(maxTime) 
    maxTime = -1;
end
if isempty(cutrow)
    cutrow = -1;
end
%disp(['Datamatrix contains ' num2str(rowcount) ' rows after operation.']);


%TODO:: TEST THIS!!!!