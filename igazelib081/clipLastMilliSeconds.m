function [DATA, cutrow] = clipLastMilliSeconds(DATA, HEADERS, millisec)
%Function [DATA] = clipFirstMilliSeconds(DATA, HEADERS, millisec)
%
% Returns the last millisec milliseconds of DATA in same format.

%does not work right!
%millisec
rowcount = rowCount(DATA);
colcount = columnCount(DATA);

% disp(['Picking first ' num2str(millisec) ' milliseconds from data using TETTime...']);
% disp(['Datamatrix contains ' num2str(rowcount) ' rows before operation.']);

TETTime = DATA{findColumnNumber(HEADERS, 'TETTime')};

millisec_at_start = TETTime(1);
%millisec_at_start + millisec
% if there are more rows than the ms limit
if millisec_at_start + millisec < TETTime(rowcount)
    
    cutrow = find(TETTime > millisec_at_start + millisec, 1, 'first');
    TETTime(cutrow) - TETTime(1);
    % put all the columns after numrows as blank
    for i=1:colcount
        DATA{i}(1:cutrow-1) = [];
    end
else
    disp('The data contains less datapoint than the millisecond-count. Not cutting anything.');
    cutrow = 1;
end

rowcount = rowCount(DATA);

%disp(['Datamatrix contains ' num2str(rowcount) ' rows after operation.']);


%TODO:: TEST THIS!!!!