% diseOO - disengagement analysis with Object-Oriented/Class-based design
% a script for running ET/SRT analysis using dedicated Classes

% Section 1: set parametes

%path for library
addpath(genpath([pwd '\gazeAnalysisLib1_07_4b'])

% Make parameters object with default settings,
% EXCEPT FOR EXTENDED MAX TIME FOR "Censoring" SRT values
params = ParamsET('min_dise_time', 0, 'max_dise_time', 3500);

% Make headers object with default settings
h = HeadersET();

% Folder for input and output data
folder = uigetdir();%

% Extract an array of filenames
files = findGazeFilesInFolder(folder, params.ending);

%%
% Section 2: Run analyses for all files

for i=1:length(files)
    gf = Gazefile('filename', files{i},'headersObj', h, 'folder', folder, 'params', params);%, 'limitrows', 10000); 
    analyst = SRTAnalyst2b(gf, params);
    analyst.analyzeFile();
end

