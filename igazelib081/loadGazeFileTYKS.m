function [DATA, HEADERS] = loadGazeFileTYKS(file)
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
str = strrep(str, 'stimtag', 'Stim');
str = strrep(str, 'RightEyePupilDiameter', 'DiameterPupilRightEye');
str = strrep(str, 'LeftEyePupilDiameter', 'DiameterPupilLeftEye');
str = strrep(str, 'id', 'UserDefined_1');
str = strrep(str, 'ValUserDefined_1ityBothEyes', 'ValidityBothEyes');
str = strrep(str, 'trialnumber', 'TrialId');
str = strrep(str, 'Prestim', 'Prestimulus');



%Read header lines
HEADERS = textscan(str, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 1);
%HEADERS = textscan(str, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 1);



%Read data columns,   #1 #2 #3 #4 #5 #1 #2 #3 #4 #5 #1 #2 #3 #4 #5 #1 #2 #3
%%
%LeftEyeNy
formats(1,1:4) = '%f  ';
%LeftEyeNx
formats(2,1:4) = '%f  ';
%RightEyeNy
formats(3,1:4) = '%f  ';
%RightEyeNx
formats(4,1:4) = '%f  ';
%RightEyePupilDiameter
formats(5,1:4) = '%f  ';
%YGazePosLeftEye
formats(6,1:4) = '%f  ';
%XGazePosRightEye
formats(7,1:4) = '%f  ';
%TETTime
formats(8,1:4) = '%d64';
%LeftEyePosition3dRelativeX
formats(9,1:4) = '%f  ';
%LeftEyePosition3dRelativeY
formats(10,1:4) = '%f  ';
%RightEyePosition3dRelativeY
formats(11,1:4) = '%f  ';
%RightEyePosition3dRelativeX
formats(12,1:4) = '%f  ';
%LeftEyePupilDiameter
formats(13,1:4) = '%f  ';
%XGazePosLeftEye
formats(14,1:4) = '%f  ';
%YGazePosRightEye
formats(15,1:4) = '%f  ';
%ValidityBothEyes
formats(16,1:4) = '%d  ';
%stimtag
formats(17,1:4) = '%s  ';
%aoitag
formats(18,1:4) = '%s  ';
%trialnumber
formats(19,1:4) = '%d  ';
%timestamp
formats(20,1:4) = '%f  ';
%id
formats(21,1:4) = '%s  ';



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

%look for tag column, which has values like: "Face", "Prestimulus", etc.
%these describe stim event...
tags = DATA{21};
%find non-empty tags
index1 = cellfun(@(x) strcmp(x,'Wait'), tags, 'UniformOutput', 1);
index2 = cellfun(@(x) strcmp(x,'Prestimulus'), tags, 'UniformOutput', 1);
index3 = cellfun(@(x) strcmp(x,'Face'), tags, 'UniformOutput', 1);
index = index1 + index2 + index3;
%find last row preceding first trial, first blanks end here
ff = find(index == 1);
lastNonTrial = ff(1);

%get trial id column
trialIDs = DATA{19};

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
DATA{19} = trialIDs;

%convert TETTime from microseconds to milliseconds
DATA{8} = DATA{8}/1000;


%get vector from "stimulus name" column
stim = DATA{17};

%stim = arrayfun(@(x) strcat('#',x), stim, 'unif', 0)

for i=1:length(stim)
    stim{i} = ['#' stim{i} '#'];
end


%Replace numerical "codes" with actual filenames
%0"Black.png"
% 1"Fix.png"
stim = strrep(stim,'#2#','op'); %face
stim = strrep(stim,'#3#','on'); %
stim = strrep(stim,'#4#','un');
stim = strrep(stim,'#5#','up');
%put stim back to DATA
DATA{17} = stim;




