function [DATA, HEADERS] = loadGazeFileHeader(file, header)
%Function [DATA, HEADERS] = loadGazeFileHeader(file, header)
%
% Loads the gaze file and returns all datalines and columns in DATA-array and 
% headers in HEADERS-cell-vector. Load function is sensitive in content
% format and if the original files differ from the format displayed here, a
% new or modified load-function is needed.

%disp(['Loading file ' file '...']);

str = fileread(file);
strHeaders = fileread(header);
%disp('Replacing uncompatible marks on the file...');

% corrections to the unwanted marks on the file
str = strrep(str, '-1.#INF', '-1');
str = strrep(str, '-1.#IND', '-1');
str = strrep(str, '1.#INF', '-1');
str = strrep(str, '1.#IND', '-1');
str = strrep(str, '1.#QNAN', '-1');
str = strrep(str, '-1.#QNAN', '-1');

%corrections to chnaged names
str = strrep(str, 'Snowstorm', 'Prestimulus');

strHeaders = strrep(strHeaders, 'RightEyePupilDiameter', 'DiameterPupilRightEye');
strHeaders = strrep(strHeaders, 'LeftEyePupilDiameter', 'DiameterPupilLeftEye');
strHeaders =  strrep(strHeaders, 'Imagefile', 'Stim');


%Read header lines
HEADERS = textscan(strHeaders, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 1);

%Read data columns
%For E-prime-based gazedata
%DATA = textscan(str, '%d32 %d32 %d32 %f %d32 %d32 %d32 %f %d32 %f %f %f %f %f %f %d32 %f %f %f %f %f %f %d %d %s %s %d %s', 'HeaderLines',1, 'Delimiter', '\t');
%DATA = textscan(str, '%d32 %d32 %d32 %f %d32 %d32 %d32 %f %d32 %f %f %f %f %f %f %d32 %f %f %f %f %f %f %d %d %s %s %d %s', 'HeaderLines',1, 'Delimiter', '\t');

%For MATLAB-based gazedata! 
%f %f %f %f %f %f %f %f %f %f %f %f %d32 %f %f %f %f %f %f %f %f %f %f %f %f %d32 %f %d %d %s %s
%LeftEyePosition3dX	LeftEyePosition3dY	LeftEyePosition3dZ	LeftEyePosition3dRelativeX	LeftEyePosition3dRelativeY	LeftEyePosition3dRelativeZ	XGazePosLeftEye	YGazePosLeftEye	LeftEyeGazePoint3dX	LeftEyeGazePoint3dY	LeftEyeGazePoint3dZ	LeftEyePupilDiameter	ValidityLeftEye	RightEyePosition3dX	RightEyePosition3dY	RightEyePosition3dZ	RightEyePosition3dRelativeX	RightEyePosition3dRelativeY	RightEyePosition3dRelativeZ	XGazePosRightEye	YGazePosRightEye	RightEyeGazePoint3dX	RightEyeGazePoint3dY	RightEyeGazePoint3dZ	RightEyePupilDiameter	ValidityRightEye	TETTime	StageNum	TrialId	Imagefile	UserDefined_1
DATA = textscan(str, '%f %f %f %f %f %f %f %f %f %f %f %f %d32 %f %f %f %f %f %f %f %f %f %f %f %f %d32 %f %d %d %s %s',  'Delimiter', '\t');
        %plot(DATA{29})
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

%poisto kaikista DATA:n sarakkeista blankit rivit!


%disp('File loaded.');