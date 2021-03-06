function [DATA, HEADERS] = loadGazeFile300mus(file)
%Function [DATA, HEADERS] = loadGazeFile300mus(file)
%
% Loads the gaze file and returns all datalines and columns in DATA-array and 
% headers in HEADERS-cell-vector. Load function is sensitive in content
% format and if the original files differ from the format displayed here, a
% new or modified load-function is needed.

% VERSION FOR MICROSECOND GAZEDATA; Oct 9th, 2015

%disp(['Loading file ' file '...']);

str = fileread(file);

%disp('Replacing uncompatible marks on the file...');

% corrections to the unwanted marks on the file
str = strrep(str, '-1.#INF', '-1');
str = strrep(str, '-1.#IND', '-1');
str = strrep(str, '1.#INF', '-1');
str = strrep(str, '1.#IND', '-1');
str = strrep(str, '1.#QNAN', '-1');
str = strrep(str, '-1.#QNAN', '-1');

%correction for changed datavalues
% str = strrep(str, 'Snowstorm', 'Prestimulus');

%corrections to changed headers
str = strrep(str, 'stim', 'Stim');
str = strrep(str, 'RightEyePupilDiameter', 'DiameterPupilRightEye');
str = strrep(str, 'LeftEyePupilDiameter', 'DiameterPupilLeftEye');
str = strrep(str, 'tag', 'UserDefined_1');
str = strrep(str, 'trialnumber', 'TrialId');
% str = strrep(str, 'PreStim', 'Prestimulus');


%Read header lines
HEADERS = textscan(str, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s ', 1);
% new header col for secondary trialid
HEADERS{end+1} = {'TrialId2'};

%Read data columns,   #1 #2 #3 #4 #5 #1 #2 #3 #4 #5 #1 #2 #3 #4 #5 #1 #2 #3
%%
%LeftEyePosition3dRelativeX	
formats(1,1:2) = '%f';
%LeftEyePosition3dRelativeY	
formats(2,1:2) = '%f';
%LeftEyePosition3dRelativeZ	
formats(3,1:2) = '%f';
% LeftEyePosition3dX	
formats(4,1:2) = '%f';
%LeftEyePosition3dY	
formats(5,1:2) = '%f';
%LeftEyePosition3dZ	
formats(6,1:2) = '%f';
%XGazePosLeftEye	
formats(7,1:2) = '%f';
%YGazePosLeftEye	
formats(8,1:2) = '%f';
%LeftEyePupilDiameter	
formats(9,1:2) = '%f';
%ValidityLeftEye	
formats(10,1:2) = '%d';
%RightEyePosition3dRelativeX	
formats(11,1:2) = '%f';
%RightEyePosition3dRelativeY	
formats(12,1:2) = '%f';
%RightEyePosition3dRelativeZ	
formats(13,1:2) = '%d';
%RightEyePosition3dX	
formats(14,1:2) = '%f';
%RightEyePosition3dY	
formats(15,1:2) = '%f';
%RightEyePosition3dZ	
formats(16,1:2) = '%f';
%XGazePosRightEye	
formats(17,1:2) = '%f';
%YGazePosRightEye	
formats(18,1:2) = '%f';
%RightEyePupilDiameter	
formats(19,1:2) = '%f';
%ValidityRightEye	
formats(20,1:2) = '%d';
%TETTime	
formats(21,1:2) = '%f';
%stim	
formats(22,1:2) = '%s';
%aoi	
formats(23,1:2) = '%f';
%tag	
formats(24,1:2) = '%s';
%trialnumber	
formats(25,1:2) = '%d';
%starttime	
formats(26,1:2) = '%f';
%aoi_coord	
formats(27,1:2) = '%s';
%endtime	
formats(28,1:2) = '%d';


formatString = '';
for i=1:length(formats)
    formatString = [formatString formats(i,:) ' '];
end
%%


DATA = textscan(str, formatString, 'HeaderLines',1, 'Delimiter', '\t');
% DATA = textscan(str, '%d %d %d %f %d %d %d %f %d %f %f %f %f %f %f %d %f %f %f %f %f %f %f %f %f %d %f %d %d %s %s', 'HeaderLines',1, 'Delimiter', '\t');
%DATA = textscan(str, '%d32 %d32 %d32 %f %d32 %d32 %d32 %f %d32 %f %f %f %f %f %f %d32 %f %f %f %f %f %f %d %d %d %d %d %d %d %s %s %s', 'HeaderLines',1, 'Delimiter', '\t');

%DATA = textscan(str, '%d32 %d32 %d32 %f %d32 %d32 %d32 %f %d32 %f %f %f %f %f %f %d32 %f %f %f %f %f %f %d %d %d %d %d %d %d %s %s %s', 'HeaderLines',0, 'Delimiter', '\t');

%Handle BLANK missing trial#s

%look for tag column
tags = DATA{24};

%replace Wait with Neutral in "tags"
tags = strrep(tags,'Wait','Neutral');

%find non-empty tags
index1 = cellfun(@(x) strcmp(x,'Wait'), tags, 'UniformOutput', 1);
index2 = cellfun(@(x) strcmp(x,'Neutral'), tags, 'UniformOutput', 1);
index3 = cellfun(@(x) strcmp(x,'Sad'), tags, 'UniformOutput', 1);
index = index1 + index2 + index3;
%find last row preceding first trial, first blanks end here
ff = find(index == 1);
lastNonTrial = ff(1);

%get trial id column
trialIDs = DATA{25};

%advance trial numbers (originally 0-based: 0,1,2...., change to 1,2,3,...)
trialIDs(index==1) = trialIDs(index==1)+1;

%loop through rows of trialID numbers and extrapolate missing=0 values
for i=1:length(trialIDs)
    %extrapolate to replace zero values in trials
    if trialIDs(i) == 0 && i > lastNonTrial
        trialIDs(i) = trialIDs(i-1);
    end
end
        
%put updated trialIDs back to DATA
DATA{25} = trialIDs;

%convert TETTime from microseconds to milliseconds
DATA{21} = DATA{21}/1000;


%get vector from "stimulus name" column
stim = DATA{22};

%stim = arrayfun(@(x) strcat('#',x), stim, 'unif', 0)

for i=1:length(stim)
    stim{i} = ['#' stim{i} ];
end

%Replace numerical "codes" with actual filenames
%0"Black.png"
% 1"Fix.png"
stim = strrep(stim,'#3','ntr');
stim = strrep(stim,'#2','sad');
stim = strrep(stim,'#4','cat');
%put stim back to DATA
DATA{22} = stim;


%%
% insert new trialid column, value changes at sad-onset (normally for
% wait-onset)
%  

%vector for new trial ids, changinf at "sad"
trialIDs2 = zeros(1,length(tags));
%running trial ID2 number, increase by 1 at every new "sad"
tID2 = 0;
for i=2:length(tags)
    if strcmp(tags(i),'Sad') && ~strcmp(tags(i-1),'Sad')
        tID2 = tID2 + 1;
        disp('found')
    end
    trialIDs2(i) = tID2;
end
% insert new trial2 column to data
DATA{end+1} = trialIDs2';
