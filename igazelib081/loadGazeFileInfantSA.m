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

%Read header lines
HEADERS = textscan(str, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 1);

%Read data columns
%DATA = textscan(str, '%d32 %d32 %d32 %f %d32 %d32 %d32 %f %d32 %f %f %f %f %f %f %d32 %f %f %f %f %f %f %d %d %s %s %d %s', 'HeaderLines',1, 'Delimiter', '\t');
%DATA = textscan(str, '%d32 %d32 %d32 %f %d32 %d32 %d32 %f %d32 %f %f %f %f %f %f %d32 %f %f %f %f %f %f %d %d %d %d %d %d %d %s %s %s', 'HeaderLines',1, 'Delimiter', '\t');
DATA = textscan(str, '%f %f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%d32	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%d8	%f	%d8	%d8	%s	%s	%s', 'HeaderLines',1, 'Delimiter', '\t');

%GET RID OF BLANK TRIAL ID ROWS (so that these will not look like trials
%for pupilAnalysis*m
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