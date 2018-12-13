function [DATA, HEADERS] = loadGazeFile(file)
%Function [DATA, HEADERS] = loadGazeFile(file)
%
% Loads the gaze file and returns all datalines and columns in DATA-array and 
% headers in HEADERS-cell-vector. Load function is sensitive in content
% format and if the original files differ from the format displayed here, a
% new or modified load-function is needed.

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
str = strrep(str, 'Snowstorm', 'Prestimulus');

%corrections to changed headers
str = strrep(str, 'Target', 'Stim');
str = strrep(str, 'RightEyePupilDiameter', 'DiameterPupilRightEye');
str = strrep(str, 'LeftEyePupilDiameter', 'DiameterPupilLeftEye');


%Read header lines
HEADERS = textscan(str, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 1);



%Read data columns,   #1 #2 #3 #4 #5 #1 #2 #3 #4 #5 #1 #2 #3 #4 #5 #1 #2 #3
%%
%LeftEyePosition3dX		
formats(1,1:2) = '%f';
%LeftEyePosition3dY	
formats(2,1:2) = '%f';
%LeftEyePosition3dZ	
formats(3,1:2) = '%f';
%LeftEyePosition3dRelativeX	
formats(4,1:2) = '%f';
%LeftEyePosition3dRelativeY	
formats(5,1:2) = '%f';
%LeftEyePosition3dRelativeZ	
formats(6,1:2) = '%f';
%XGazePosLeftEye	
formats(7,1:2) = '%f';
%YGazePosLeftEye	
formats(8,1:2) = '%f';
%LeftEyeGazePoint3dX	
formats(9,1:2) = '%f';
%LeftEyeGazePoint3dY	
formats(10,1:2) = '%f';
%LeftEyeGazePoint3dZ	
formats(11,1:2) = '%f';
%LeftEyePupilDiameter	
formats(12,1:2) = '%f';
%ValidityLeftEye	
formats(13,1:2) = '%d';
%RightEyePosition3dX	
formats(14,1:2) = '%f';
%RightEyePosition3dY	
formats(15,1:2) = '%f';
%RightEyePosition3dZ	
formats(16,1:2) = '%f';
%RightEyePosition3dRelativeX
formats(17,1:2) = '%f';
%RightEyePosition3dRelativeY
formats(18,1:2) = '%f';
%RightEyePosition3dRelativeZ
formats(19,1:2) = '%f';
%XGazePosRightEye
formats(20,1:2) = '%f';
%YGazePosRightEye
formats(21,1:2) = '%f';
%RightEyeGazePoint3dX
formats(22,1:2) = '%f';
%RightEyeGazePoint3dY
formats(23,1:2) = '%f';
%RightEyeGazePoint3dZ
formats(24,1:2) = '%f';
%RightEyePupilDiameter
formats(25,1:2) = '%f';
%ValidityRightEye	
formats(26,1:2) = '%d';
%TETTime	
formats(27,1:2) = '%f';
%StageNum
formats(28,1:2) = '%d';
%TrialId	
formats(29,1:2) = '%d';
%Target	
formats(30,1:2) = '%s';
%UserDefined_1
formats(31,1:2) = '%s';

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
%find rows without TRIAL ID
rowsBlank = find((DATA{29} == 0));
%list all rows
rowsAll = 1:size(DATA{29});
%mark non-blank rows = 1 (blanks = 0)
rowsGood = (~ismember(rowsAll,rowsBlank));

%replace all data columnns with non-blank columns
for i = 1:length(DATA)
    DATA{i} = DATA{i}(rowsGood);
end;


%a=0;

%disp('File loaded.');