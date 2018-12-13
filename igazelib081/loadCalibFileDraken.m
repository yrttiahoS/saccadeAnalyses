function [DATA, HEADERS] = loadCalibFileDraken(file)
%Function [DATA, HEADERS] = loadGazeFile300mus(file)
%
% Loads the gaze file and returns all datalines and columns in DATA-array and 
% headers in HEADERS-cell-vector. Load function is sensitive in content
% format and if the original files differ from the format displayed here, a
% new or modified load-function is needed.

% VERSION FOR MICROSECOND GAZEDATA; Oct 9th, 2015

%disp(['Loading file ' file '...']);
disp('load calib data')

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
% str = strrep(str, 'tag', 'UserDefined_1');
% str = strrep(str, 'trialnumber', 'TrialId');
% str = strrep(str, 'PreStim', 'Prestimulus');


%Read header lines
HEADERS = textscan(str, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s ', 1);
%HEADERS = textscan(str, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 1);



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
formats(23,1:2) = '%d';
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
%find non-empty tags
index1 = cellfun(@(x) strcmp(x,'Calibdot'), tags, 'UniformOutput', 1);
index2 = cellfun(@(x) strcmp(x,'Prestimulus'), tags, 'UniformOutput', 1);
index3 = cellfun(@(x) strcmp(x,'Face'), tags, 'UniformOutput', 1);
index = index1 + index2 + index3;
%find last row preceding first trial, first blanks end here
ff = find(index == 1);
lastBlankAtStart = ff(1)-1;
firstBlankAtEnd = ff(end)+1;

% %get trial id column
% trialIDs = DATA{23};
% 
% 
% 
% 
% %advance trial numbers (originally 0-based: 0,1,2...., change to 1,2,3,...)
% trialIDs(index==1) = trialIDs(index==1)+1;
% 
% %loop through rows of trialID numbers and extrapolate missing=0 values
% for i=1:length(trialIDs)
%     %extrapolate to replace zero values in trials
%     if trialIDs(i) == 0 && i > lastNonTrial
%         trialIDs(i) = trialIDs(i-1);
%     end
% end
%         
% %put updated trialIDs back to DATA
% DATA{23} = trialIDs;

%convert TETTime from microseconds to milliseconds
DATA{21} = DATA{21}/1000;


%get vector from "stimulus name" column
stim = DATA{22};

%stim = arrayfun(@(x) strcat('#',x), stim, 'unif', 0)



for i = 1:length(DATA)
    DATA{i} = DATA{i}(lastBlankAtStart+1:firstBlankAtEnd-1);
    %disp('crop from beginningä')
end

a=1;
