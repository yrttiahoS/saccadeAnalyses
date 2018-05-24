function [DATA, HEADERS] = loadGazedataFile2(file, h, varargin)
%Function [DATA, HEADERS] = loadGazedataFile(file, loadGazedataFile(files{j})
%
% Loads the gaze file and returns all datalines and columns in DATA-array and 
% headers in HEADERS-cell-vector. 
%
% Load function is sensitive in content
% format and you need to specify that as a parameter. The format follows
% Matlab's common format e.g. in textscan function (e.g. '%s %f %f %s' for
% data where first column contains strings, second and third float-numbers 
% and fourth again strings). Column headers are assumed to be in the same 
% file and similar numbers as columns in the actual data.

addpath(genpath('C:\Users\infant\Documents\MATLAB\igazelib\gazeAnalysisLib1_07_4'))

disp(['Reading file ' file '...']);

str = fileread(file);




%
disp('Done.');
disp('Replacing uncompatible marks on the file...');

% corrections to the unwanted marks on the file (some usual found in
% gazedata files)
str = strrep(str, '-1.#INF', '-1');
str = strrep(str, '-1.#IND', '-1');
str = strrep(str, '1.#INF', '-1');
str = strrep(str, '1.#IND', '-1');
str = strrep(str, '1.#QNAN', '-1');
str = strrep(str, '-1.#QNAN', '-1');

disp('Done.');
disp('Loading file to datastructs...');

% count columns
% find 1st line change
lineEnd = min(strfind(str, char(10)));
% fin number of tabulations on 1st line
tabInds  = strfind(str(1:lineEnd), char(9));
columncount = length(tabInds) + 1;

% form header format string
headerformat = ['%s' repmat('%s',1, columncount-1)];

%%

%Read header lines
HEADERS = textscan(str, headerformat, 1);

%intialize dataformat
dataformat = '';

%loop through headers to write dataformats down
for i=1:length(HEADERS)
    %get formatSPec for ith headers
    colHeader = cell2mat(HEADERS{i});
    hFormat = h.hds(colHeader).format;
    
    %set column number for particular header in header-object
    h.setColNum(colHeader, i);
    
    %append formatSpec to a string of formatSpecs
    dataformat = [dataformat hFormat];
    
end

%Read data columns
DATA = textscan(str, dataformat, 'HeaderLines', 1, 'Delimiter', '\t');

%limit rows, optionally, typically datalength > 60,000 rows

limitrows = Inf;
p = inputParser;
addParamValue(p,'limitrows',limitrows);
parse(p,varargin{:});
limitrows = p.Results.limitrows;
disp(limitrows)
[DATA] = clipFirstRows(DATA, limitrows); 

disp('File loaded.');

%%
% datamatrix is equal in column (probably the last row is corrupted)
% if not -> remove last row
if ~testDataConsistency(DATA)
    rowcount = rowCount(DATA);
    DATA = clipFirstRows(DATA, rowcount-1);
end

%%
% combine certain values together

% use header object h to get column number 
colnumStim = h.hds('Stim').colNum;
DATA = replaceStringsInColumn(DATA, colnumStim, 'Dangry.bmp', 'angry.bmp');
DATA = replaceStringsInColumn(DATA, colnumStim, 'Dfearful.bmp', 'fearful.bmp');
DATA = replaceStringsInColumn(DATA, colnumStim, 'Dhappy.bmp', 'happy.bmp');
DATA = replaceStringsInColumn(DATA, colnumStim, 'Dneutral.bmp', 'neutral.bmp');
DATA = replaceStringsInColumn(DATA, colnumStim, 'Dangry2.bmp', 'angry.bmp');
DATA = replaceStringsInColumn(DATA, colnumStim, 'Dfearful2.bmp', 'fearful.bmp');
DATA = replaceStringsInColumn(DATA, colnumStim, 'Dhappy2.bmp', 'happy.bmp');
DATA = replaceStringsInColumn(DATA, colnumStim, 'Dneutral2.bmp', 'neutral.bmp');

DATA = replaceStringsInColumn(DATA, colnumStim, 'control2.bmp', 'control.bmp');
DATA = replaceStringsInColumn(DATA, colnumStim, 'happy2.bmp', 'happy.bmp');
DATA = replaceStringsInColumn(DATA, colnumStim, 'fearful2.bmp', 'fearful.bmp');
DATA = replaceStringsInColumn(DATA, colnumStim, 'neutral2.bmp', 'neutral.bmp');
DATA = replaceStringsInColumn(DATA, colnumStim, 'FearControl.bmp', 'control.bmp');
DATA = replaceStringsInColumn(DATA, colnumStim, 'HappyControl.bmp', 'control.bmp');
DATA = replaceStringsInColumn(DATA, colnumStim, 'NeutralControl.bmp', 'control.bmp');

% the old way was to find column numbers with function
% DATA = replaceStringsInColumn(DATA, colNum(HEADERS, 'Stim'), 'Dangry.bmp', 'angry.bmp');
% DATA = replaceStringsInColumn(DATA, colNum(HEADERS, 'Stim'), 'Dfearful.bmp', 'fearful.bmp');
% DATA = replaceStringsInColumn(DATA, colNum(HEADERS, 'Stim'), 'Dhappy.bmp', 'happy.bmp');
% DATA = replaceStringsInColumn(DATA, colNum(HEADERS, 'Stim'), 'Dneutral.bmp', 'neutral.bmp');
% DATA = replaceStringsInColumn(DATA, colNum(HEADERS, 'Stim'), 'Dangry2.bmp', 'angry.bmp');
% DATA = replaceStringsInColumn(DATA, colNum(HEADERS, 'Stim'), 'Dfearful2.bmp', 'fearful.bmp');
% DATA = replaceStringsInColumn(DATA, colNum(HEADERS, 'Stim'), 'Dhappy2.bmp', 'happy.bmp');
% DATA = replaceStringsInColumn(DATA, colNum(HEADERS, 'Stim'), 'Dneutral2.bmp', 'neutral.bmp');
% 
% DATA = replaceStringsInColumn(DATA, colNum(HEADERS, 'Stim'), 'control2.bmp', 'control.bmp');
% DATA = replaceStringsInColumn(DATA, colNum(HEADERS, 'Stim'), 'happy2.bmp', 'happy.bmp');
% DATA = replaceStringsInColumn(DATA, colNum(HEADERS, 'Stim'), 'fearful2.bmp', 'fearful.bmp');
% DATA = replaceStringsInColumn(DATA, colNum(HEADERS, 'Stim'), 'neutral2.bmp', 'neutral.bmp');
% DATA = replaceStringsInColumn(DATA, colNum(HEADERS, 'Stim'), 'FearControl.bmp', 'control.bmp');
% DATA = replaceStringsInColumn(DATA, colNum(HEADERS, 'Stim'), 'HappyControl.bmp', 'control.bmp');
% DATA = replaceStringsInColumn(DATA, colNum(HEADERS, 'Stim'), 'NeutralControl.bmp', 'control.bmp');

