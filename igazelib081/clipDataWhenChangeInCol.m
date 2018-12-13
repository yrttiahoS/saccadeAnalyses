function [DATA] = clipDataWhenChangeInCol(uDATA, column)
%Function [DATA] = clipDataWhenChangeInCol(uDATA, column)
%
% Clips uDATA and returns DATA, a clipped cell-table. Data is being clipped
% according to the column (number) when the value in the column is
% different from previous row a new clip is formed. This function can
% handle both a numerical and cellstring column values as separators.

rowcount = rowCount(uDATA);
colcount = columnCount(uDATA);


% go throught all rows in the uDATA matrix
clipdifferentiator = 0;
clipcounter = 0;
first_round = 1;
for i=1:rowcount
    
    % check if the value on the column was string or numerical and make the
    % comparison according to that
    testid = uDATA{column}(i);
    if iscell(uDATA{column}(i))
       wasdifferent = ~strcmp(testid, clipdifferentiator);
    else
        wasdifferent = testid ~= clipdifferentiator;
    end
    
    % handle the change in column value here
    if wasdifferent || i == rowcount % if change or last row of the file
        clipdifferentiator = testid;
       
        if first_round
            first_round = 0;
        else
            clipcounter = clipcounter + 1;
            for j=1:colcount
                tDATA{j} = uDATA{j}(tempvar:i-1);
            end
            DATA{clipcounter} = tDATA;
        end
        tempvar = i;
    end
    
end
