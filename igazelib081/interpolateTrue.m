function [DATA] = interpolateTrue(DATA, column, validitycolumn, accepted_validities)
%Function [DATA] = interpolateUsingLastGoodValue(DATA, column, validitycolumn, accepted_validities)
%
% Interpolates values in column "column" in DATA-matrix by replacing the bad 
% value with last good value before bad values (if there is at least one good 
% value, otherwise, do nothing). Validitycolumn contains the validity markings
% for each datapoint and good validities are defined by the accepted 
% validities-parameter. 

%disp('Interpolating: using last good (or first good) value...');

rowcount = rowCount(DATA);

datavector = DATA{column};
validityvector = DATA{validitycolumn};

%plot(datavector)

% if the first value of the vector is bad, find the first non-bad.
%over_zero = find(datavector >= 0);
good_samples = ismember(validityvector, accepted_validities);


% take the first non-bad number and set that as first good
first_good = find(good_samples, 1, 'first');



% check that there was at least one good value
if isempty(first_good)
    % if not, return data as it was
 %   disp('No good data available');
 %   disp('Done.');
    return;
end

last_non_bad = datavector(first_good);
next_non_bad = -1;

% pidetaanko yli yhden interpolaatio/smoothingvaiheessa?

%next_non_badin pituus;
nnbDuration = 5;

for i=1:rowcount%-nnbDuration
    if ~ismember(validityvector(i), accepted_validities) % invalid data
        %find next good
        if next_non_bad == -1
            j = i;
            start = i;
            while ~ismember(validityvector(j), accepted_validities) && j < rowcount-nnbDuration
                j = j + 1;                
            end
            try
                %extract only positive pupil sizes for interpolation 
                nextSource = datavector(j+nnbDuration - floor(nnbDuration/3) : j+nnbDuration);
                nextSource = nextSource(find(nextSource > 0));
                %next_non_bad = mean(datavector(j : j+nnbDuration))
                if ~isnan(mean(nextSource))
                    next_non_bad =  mean(nextSource);%datavector(j+nnbDuration - floor(nnbDuration/3) : j+nnbDuration))
                else
                    next_non_bad =  datavector(j);
                end
            catch
            end
        end
%         i
%         j
         
        %If data is "scrolled" to trial end, next_non_bad may not be found
        %Used last_non_bad instead.
        if next_non_bad == -1 
            next_non_bad = last_non_bad;
        end
        %delta pupil / delta time
        slope = (next_non_bad - last_non_bad) / (j-start);
        if isnan(slope) 
            slope = 0;
        elseif isinf(slope)
            slope = 0;
        end
        
%         slope
%         next_non_bad
%         last_non_bad
%         j
%         start

        %linear trend
        datavector(i) = last_non_bad + (i-start-1)*slope;
    else
        %i
        try
            last_non_bad = mean(datavector(i-nnbDuration  : i-nnbDuration + floor(nnbDuration/3))); % datavector(i-1);
        catch
            last_non_bad = datavector(i);
        end
        
        next_non_bad = -1;
    end
end



DATA{column} = datavector;

%   disp('Done.');