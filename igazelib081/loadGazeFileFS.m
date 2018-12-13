function [DATA, HEADERS] = loadGazeFileFS(file)
%Function [DATA, HEADERS] = loadGazeFile300mus(file)
%
% Loads the gaze file and returns all datalines and columns in DATA-array and 
% headers in HEADERS-cell-vector. Load function is sensitive in content
% format and if the original files differ from the format displayed here, a
% new or modified load-function is needed.

% VERSION FOR MICROSECOND GAZEDATA;

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

%%
%strings used as column headers 
tagColName = 'UserDefined_1';
trialColName = 'TrialId';
stimColName = 'Stim';
timeColName = 'TETTime';
%%


%corrections to changed headers
str = strrep(str, 'stim', stimColName);
str = strrep(str, 'RightEyePupilDiameter', 'DiameterPupilRightEye');
str = strrep(str, 'LeftEyePupilDiameter', 'DiameterPupilLeftEye');
%the header "*validity*" contains "id", 
% will be corrupted by change from "id" to "UsedDefined_1"
%thus need to be changed to somethign else temporarily
str = strrep(str, 'idi', 'amin'); 
str = strrep(str, 'secondary_id', 'secondary_ego');
str = strrep(str, 'id', tagColName);
%change "validity" & other headers back to the original form
str = strrep(str, 'amin', 'idi');
str = strrep(str, 'secondary_ego', 'secondary_id' );
str = strrep(str, 'trialnumber', trialColName);
str = strrep(str, 'PreStim', 'Prestimulus');


%FamilySudy (FS) data have two different formats, format 1 (ID = 101-106),
%format 2 (ID >= 107)
%test if format 2, these have 'LeftEyePosition3dRelativeX' at the beginning
format2 = strncmp(str,'LeftEyePosition3dRelativeX',length('LeftEyePosition3dRelativeX'));

%Read header lines
%HEADERS = textscan(str, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 1);
if format2 
    HEADERS = textscan(str, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 1);
else
    HEADERS = textscan(str, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 1);
end

%Read data columns,   #1 #2 #3 #4 #5 #1 #2 #3 #4 #5 #1 #2 #3 #4 #5 #1 #2 #3
%%
%format headers accordign to two different formats
if format2
    % LeftEyePosition3dRelativeX
    formats(1,1:2) = '%f';
    % LeftEyePosition3dRelativeY
    formats(2,1:2) = '%f';
    % LeftEyePosition3dRelativeZ
    formats(3,1:2) = '%f';
    % LeftEyePosition3dX
    formats(4,1:2) = '%f';
    % LeftEyePosition3dY
    formats(5,1:2) = '%f';
    % LeftEyePosition3dZ
    formats(6,1:2) = '%f';
    % XGazePosLeftEye
    formats(7,1:2) = '%f';
    % YGazePosLeftEye
    formats(8,1:2) = '%f';
    % LeftEyePupilDiameter
    formats(9,1:2) = '%f';
    % ValidityLeftEye
    formats(10,1:2) = '%d';
    % RightEyePosition3dRelativeX
    formats(11,1:2) = '%f';
    % RightEyePosition3dRelativeY
    formats(12,1:2) = '%f';
    % RightEyePosition3dRelativeZ
    formats(13,1:2) = '%d';
    % RightEyePosition3dX
    formats(14,1:2) = '%f';
    % RightEyePosition3dY
    formats(15,1:2) = '%f';
    % RightEyePosition3dZ
    formats(16,1:2) = '%f';
    % XGazePosRightEye
    formats(17,1:2) = '%f';
    % YGazePosRightEye
    formats(18,1:2) = '%f';
    % RightEyePupilDiameter
    formats(19,1:2) = '%f';
    % ValidityRightEye
    formats(20,1:2) = '%d';
    % TETTime
    formats(21,1:2) = '%f';
    % aoi
    formats(22,1:2) = '%d';
    % id
    formats(23,1:2) = '%s';
    % nudged_point
    formats(24,1:2) = '%s';
    % secondary_id
    formats(25,1:2) = '%s';
    % stim
    formats(26,1:2) = '%s';
    % tet_time
    formats(27,1:2) = '%d';
    % timestamp
    formats(28,1:2) = '%f';
    % trialnumber
    formats(29,1:2) = '%d';    
else
    %LeftEyeNx
    formats(1,1:2) = '%f';
    %LeftEyeNy
    formats(2,1:2) = '%f';
    %LeftEyePosition3dRelativeX
    formats(3,1:2) = '%f';
    %LeftEyePosition3dRelativeY
    formats(4,1:2) = '%f';
    %LeftEyePosition3dRelativeZ
    formats(5,1:2) = '%f';
    %LeftEyePosition3dX
    formats(6,1:2) = '%f';
    %LeftEyePosition3dY
    formats(7,1:2) = '%f';
    %LeftEyePosition3dZ
    formats(8,1:2) = '%f';
    %LeftEyePupilDiameter
    formats(9,1:2) = '%f';
    %RightEyeNx
    formats(10,1:2) = '%d';
    %RightEyeNy
    formats(11,1:2) = '%f';
    %RightEyePosition3dRelativeX
    formats(12,1:2) = '%f';
    %RightEyePosition3dRelativeY
    formats(13,1:2) = '%d';
    %RightEyePosition3dRelativeZ
    formats(14,1:2) = '%f';
    %RightEyePosition3dX
    formats(15,1:2) = '%f';
    %RightEyePosition3dY
    formats(16,1:2) = '%f';
    %RightEyePosition3dZ
    formats(17,1:2) = '%f';
    %RightEyePupilDiameter
    formats(18,1:2) = '%f';
    %TETTime
    formats(19,1:2) = '%f';
    %ValidityLeftEye
    formats(20,1:2) = '%d';
    %ValidityRightEye
    formats(21,1:2) = '%d';
    %XGazePosLeftEye
    formats(22,1:2) = '%f';
    %XGazePosRightEye
    formats(23,1:2) = '%f';
    %YGazePosLeftEye
    formats(24,1:2) = '%f';
    %YGazePosRightEye
    formats(25,1:2) = '%f';
    %nudged_transform_l
    formats(26,1:2) = '%s';
    %nudged_transform_r
    formats(27,1:2) = '%s';
    %aoi
    formats(28,1:2) = '%d';
    %id
    formats(29,1:2) = '%s';
    %stim
    formats(30,1:2) = '%s';
    %tet_time
    formats(31,1:2) = '%d';
    %timestamp
    formats(32,1:2) = '%f';
    %trialnumber
    formats(33,1:2) = '%d';
end

formatString = '';
for i=1:length(formats)
    formatString = [formatString formats(i,:) ' '];
end
%%

DATA = textscan(str, formatString, 'HeaderLines',1, 'Delimiter', '\t');

%Handle BLANK missing trial#s
%look for tag column
%find column number first
tagCol = find(cellfun(@(x) ~isempty(cell2mat(strfind(x,  tagColName  ))), HEADERS)); %find indices of strings
tags = DATA{tagCol};
%find non-empty tags
index1 = cellfun(@(x) strcmp(x,'Wait'), tags, 'UniformOutput', 1);
index2 = cellfun(@(x) strcmp(x,'Prestimulus'), tags, 'UniformOutput', 1);
index3 = cellfun(@(x) strcmp(x,'Face'), tags, 'UniformOutput', 1);
index4 = cellfun(@(x) strcmp(x,'Response'), tags, 'UniformOutput', 1);
index = index1 + index2 + index3 + index4;
%find last row preceding first trial, first blanks end here
ff = find(index == 1);
lastNonTrial = ff(1);

%find trial id column
trialCol = find(cellfun(@(x) ~isempty(cell2mat(strfind(x,  trialColName  ))), HEADERS)); %find indices of strings
trialIDs = DATA{trialCol};

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
DATA{trialCol} = trialIDs;

%convert TETTime from microseconds to milliseconds
%first find time column
timeCol = find(cellfun(@(x) ~isempty(cell2mat(strfind(x,  timeColName  ))), HEADERS)); %find indices of strings
DATA{timeCol} = DATA{timeCol}/1000;


%get vector from "stimulus name" column
stimCol = find(cellfun(@(x) ~isempty(cell2mat(strfind(x,  stimColName  ))), HEADERS)); %find indices of strings;
stim = DATA{stimCol};

%stim = arrayfun(@(x) strcat('#',x), stim, 'unif', 0)

for i=1:length(stim)
    stim{i} = ['#' stim{i} '#'];
end

%Replace numerical "codes" with actual filenames
stim = strrep(stim,'#3#','inf1hap.bmp');
stim = strrep(stim,'#4#','inf1sad.bmp');
stim = strrep(stim,'#5#','inf3hap.bmp');
stim = strrep(stim,'#6#','inf3sad.bmp');
stim = strrep(stim,'#7#','inf6hap.bmp');
stim = strrep(stim,'#8#','inf6sad.bmp');
stim = strrep(stim,'#9#','inf7hap.bmp');
stim = strrep(stim,'#10#','inf7sad.bmp');
stim = strrep(stim,'#11#','inf9hap.bmp');
stim = strrep(stim,'#12#','inf9sad.bmp');
stim = strrep(stim,'#13#','inf12hap.bmp');
stim = strrep(stim,'#14#','inf12sad.bmp');
stim = strrep(stim,'#15#','inf13hap.bmp');
stim = strrep(stim,'#16#','inf13sad.bmp');
stim = strrep(stim,'#17#','inf14hap.bmp');
stim = strrep(stim,'#18#','inf14sad.bmp');
stim = strrep(stim,'#19#','inf15hap.bmp');
stim = strrep(stim,'#20#','inf15sad.bmp');

%put stim back to DATA
DATA{stimCol} = stim;




