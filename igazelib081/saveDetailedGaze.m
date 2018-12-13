function saveDetailedGaze(DATA, HEADERS, figtitle, delaytime, accepted_validities, varargin)
%Function saveDetailedGaze(DATA, HEADERS, figtitle, delaytime, accepted_validities, varargin)
%
% Function plots gaze like the DetailedGazeAnimation and saves the gaze to 
% a file specified by figtitle.

a = varargin;

plotDetailedGazeAnimation(DATA, HEADERS, figtitle, delaytime, accepted_validities, a);


print(gcf, '-dpmb', figtitle);

close;
