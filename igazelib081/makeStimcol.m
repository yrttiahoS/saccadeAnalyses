function [DATA, codeValidity] = makeStimcol(filename, DATA, stimCodes, stimCNum, trialCNum)
%synopsis [stimcol] = makeStimcol(DATA,colnum)
%Function puts correct stimulus codes into DATA.
%
%output:
%DATA = all data(?)
%codeValidity = boolean expressing whether valid stimCodes were in the data
%   1 = valid codes found, 0 = invalid codes found

%input:
%DATA = all gazedata
%stimCNum = column number for stimulus data
%trialCNum = coulumn number for trialnumbers



%files with bad stimulus column have this following string on every row
badName = 'lumimyrsky';

%by default the validity is OK, change if "badName" found
codeValidity = 1;

%get the first row from stimulus column

stimuli = DATA(1,stimCNum);

%initialize stimulus code column
%stimcol = cell(length(DATA{1}),1);
stimcol = repmat({'öö'},length(DATA{1}),1);


%extract headeres (for participants) and stimulus codes
%if no stim codes available: do nothing
if ~isempty(stimCodes)
    headers = stimCodes.headers;
    codes = stimCodes.codes;
end

%if bad stimulus name is found, begin corrections
%(strfind((stimuli{1,1}(1)),badName))
if ~isempty(cell2mat(strfind((stimuli{1,1}(1)),badName)))
    
    'BAD STIMULUS CODE; REPLACING'
    codeValidity = 0;
    
    %1. check participant/gazedata name from 
    [pathstr, name, ext] = fileparts(filename);
    participant = find(strcmp(headers,name));
    %['name: ' name]
    %['col: ' num2str(participant)]
    
    %2. check number of trials
    trials = DATA(1,trialCNum);
    nTrials = trials{1,1}(end,1);
    
    %3 find indexes of trial changes: eg., for 1st, 2nd, 3rd trial etc.
    clipdata = clipDataWhenChangeInCol(DATA, trialCNum);
    clipcount = length(clipdata);
    
    %first row of clip in DATA
    beginRow = 1;
    
    %% for each clip/trial, do
    for i=1:clipcount
        whole_data = clipdata{i};
        %'length(whole_data{1,1})'
        %length(whole_data{1,1})
        %'codes(i,participant)'
        %codes(i,participant)
               
        
     %   'rows'
     %   beginRow
        endRow = beginRow + length(whole_data{1,1}) - 1;
        stimcol(beginRow:endRow,1);
        %codes(i,participant)
        
        atest = stimcol(beginRow:endRow,1);
        btest = repmat({codes(i,participant)},length(whole_data{1,1}),1);
        %i
        stimcol(beginRow:endRow,1) = repmat(codes(i,participant)    ,length(whole_data{1,1}),1);
        
        beginRow = endRow + 1;
    end
    
    sc = cell(1,1);
    sc{1} = stimcol;
    
       
    DATA(1, stimCNum) = sc;
 
    
    
end
