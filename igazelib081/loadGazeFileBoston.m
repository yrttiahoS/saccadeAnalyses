function [DATA, HEADERS] = loadGazeFileBoston(file)
%Function [DATA, HEADERS] = loadGazeFileBoston(file)
%
% Loads the gaze file and returns all datalines and columns in
% DATA-array and headers in HEADERS-cell-vector.

%disp(['Loading file ' file '...']);
file
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
HEADERS = textscan(str, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 1);

%Read data columns
%DATA = textscan(str, '%d32 %d32 %d32 %f %d32 %d32 %d32 %f %d32 %f %f %f %f %f %f %d32 %f %f %f %f %f %f %d %d %s %s %d %s', 'HeaderLines',1, 'Delimiter', '\t');
DATA = textscan(str, '%d32 %d32 %d32 %f %d32 %d32 %d32 %f %d32 %f %f %f %f %f %f %d32 %f %f %f %f %f %f %d %d %s %s %d %s %s %s', 'HeaderLines',1, 'Delimiter', '\t');

%disp('File loaded.');