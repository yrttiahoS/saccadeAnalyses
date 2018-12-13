function [DATA] = getRowsContainingValue(DATA, column, value)
%Function [DATA] = getRowsContainingValue(DATA, column, value)
%
% Takes the rows that contain specified value in specified column. Value
% can be a value, or a vector of values (strings: cell vector) of values.

rowcount = rowCount(DATA);
colcount = columnCount(DATA);

%disp(['Getting rows that contain specified value in column ' num2str(column) '.']);
%disp(['Datamatrix contains ' num2str(rowcount) ' rows before operation.']);

rows_not_found = [];

for i=1:rowcount   
    % check if the value on the column was string or numerical and make the
    % comparison according to that
    testid = DATA{column}(i);
    if iscell(DATA{column}(i))
       cntsvec = strcmp(testid, value);
    else
       cntsvec = testid == value;
    end

    % if row does not contain that
    cnts = max(cntsvec);
    if ~cnts
        rows_not_found = [rows_not_found i];
    end
    
end

% remove every found value
for j=1:colcount
   DATA{j}(rows_not_found) = [];
end

rowcount = rowCount(DATA);
%disp(['Datamatrix contains ' num2str(rowcount) ' rows after operation.']);
