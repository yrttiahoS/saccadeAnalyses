function [longest_streak] = longestNonValidSection2(    DATA, valcol, timecol, accepted_validities, minGoodStreak)
%Function [longestr, longestl] = longestNonValidSection(data, HEADERS, accepted_validities)
%
% Calculates the validities for each eye separately. The result is calculated 
% and returned in TETTime.

%disp('Calculating longest non-valid section...');

datavector = DATA{valcol};
timevector = DATA{timecol};

%calculate number of desired good frames
sample_duration = mean(timevector(2:length(timevector),1) - timevector(1:length(timevector)-1,1));

nGoodFrames = ceil(minGoodStreak/sample_duration); 
%['nGoodFrames: ' num2str(nGoodFrames)]
    
longest_streak = 0;

if length(timevector)<2
   return; 
end

current_start = timevector(1);

for i=2:length(datavector)
    
    %calculate a limit point for look-advance of good frames
    iStop = i + nGoodFrames;
    if iStop > length(datavector)
        iStop = length(datavector);
    end
    
%     i
%     datavector(i:iStop,1)
    
    % if current streaks continue?
    if ~ismember(datavector(i), accepted_validities) % invalid data
        current = timevector(i) - current_start;
    %require that nGoodFrames ahead are also valid
    else
        if min(ismember(datavector(i:iStop,1),accepted_validities))
            current_start = timevector(i);
            current = 0; 
        else
            current = timevector(i) - current_start;
        end
    end
    
    % if current streak surpasses longest one?
    if current > longest_streak
        longest_streak = current;
    end
    
end



%disp('Done.');
