function [newdatacol, newvalcol] = combineEyes(DATA, col1, col2, c1val, c2val, accepted_validities)
%Function [newcol] = combineEyes(DATA, col1, col2)
%
% combines two columns to one by using the validity of columns. Function
% takes the mean of 


%disp('Combining two columns into one.');

badval = 4;%-1;

newdatacol = zeros(rowCount(DATA),1);
newvalcol = zeros(rowCount(DATA),1);


% for each datapoint
for i=1:rowCount(DATA)
        
    if ismember(DATA{c1val}(i), accepted_validities) && ismember(DATA{c2val}(i), accepted_validities)
        % both validities are okay
        newdatacol(i) = mean([DATA{col1}(i), DATA{col2}(i)]);
        newvalcol(i) = DATA{c1val}(i);
        
    elseif ismember(DATA{c1val}(i), accepted_validities) && ~ismember(DATA{c2val}(i), accepted_validities)
        newdatacol(i) = DATA{col1}(i);
        newvalcol(i) = DATA{c1val}(i);
    
    elseif ismember(DATA{c2val}(i), accepted_validities) && ~ismember(DATA{c1val}(i), accepted_validities)
        newdatacol(i) = DATA{col2}(i);
        newvalcol(i) = DATA{c2val}(i);
    
    else
        newdatacol(i) = -1;
        newvalcol(i) = badval;
        
    end
    
    
end

%disp('Done.');