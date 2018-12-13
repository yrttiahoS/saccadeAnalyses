%Script which plots pupil responses (i.e., time-diameter)
%and extracts statistics from these waves (e.g., mean, min, N)
%
%Uses data structures of "pupilAnalysis*.m" -functions
%Central data stucture is: "comb_pup_waves" (2D matrix: times-by-trials)
%Mapping of trials in "comb_pup_waves" to correct participants and stimuli
%is based on vectors "stimClass" and "filename" (1D matrix: trials)

%set plotting on/off, boolean
plotting = 0;
%set on/off to append means from each participant into matrix
wavxtract = 1;

%matrices for average responses
wwavesSN = []; %zeros(1,plotMax);
wwavesMN = []; %zeros(1,plotMax);
wwavesSP = []; %zeros(1,plotMax);
wwavesMP = []; %zeros(1,plotMax);



allStims = unique(stimClass);
allSubs = unique(filename);

%find good data rows
goods = find(combination_column == 1) % ~isnan(combination_column_2);

%Make headers for output file
stats = {'pupil_min', 'pupil_mean', 'trials'};
%conditions can be found from a vector
conditions = unique(stimClass);
outCell = {'filename'};

%loop to combine conditions and desired statistics
for i = 1:length(conditions)
    for j=1:length(stats)
        outCell(1,end+1) = {[conditions{i}  stats{j}]};
    end
end
%outCell = {'filename', 'MNpupil', 'MNpupil_ok', 'MNtrials', 'MPpupil', 'MPpupil_ok', 'MPtrials', 'SNpupil', 'SNpupil_ok', 'SNtrials', 'SPpupil', 'SPpupil_ok', 'SPtrials'};


%Axes scale for plotting
%axis1 = [0 2000 -.8 .35]; % constriction response
axis1 = [0 8500 -1.50000000000000004 .5]; %dialation response

%Esure that time range matches between analyses windows used here and in
%main function
if plotMax > winMaxRow(goods(1))
    plotMax = winMaxRow(goods(1)); %+ 10;
end
    
%make plots dock into separate figure-tabs
set(0,'DefaultFigureWindowStyle','docked') 
%Data aggregation subject-  by-subject X stim-by-stim
for i=1:length(allSubs) 
    for j=1:length(allStims)
        
        %PLOTTING COMMANDS
        subj = find(strcmp(filename, allSubs(i)));
        stimCond = find(strcmp(stimClass, allStims(j)));
             
        select = intersect(subj, stimCond);
        select = intersect(select, goods);
        
        %Get split-half of trials
        %1st half
%         select = select(1:floor(length(select)/2));   
        %2nd half
%        select = select(floor(length(select)/2)+1:length(select));
        
        %sizeOfWave = size(wave)
        waves1 = comb_pup_waves(1:plotMax,select);
        
        %calculate mean response (for plotting) if enough trials
        if length(select) >= minTrialsPlotting
            switch allStims{j}
                case 'SN'
                    wwavesSN(end+1,1:plotMax) = mean(waves1,2)';
                case 'MN'
                    wwavesMN(end+1,1:plotMax) = mean(waves1,2)';
                case 'SP'
                    wwavesSP(end+1,1:plotMax) = mean(waves1,2)';
                case 'MP'
                    wwavesMP(end+1,1:plotMax) = mean(waves1,2)';
                otherwise
                    'ERRROR IN CLASSIFICATION!!'
                    continue
            end
        end
        
        if ~isempty(waves1)
            

            %get the dip in pupil size, 
            %search is bound within window "winMinRow to winMaxRow" 
            [mark, pupilValue] = findLightResponse(mean(waves1,2)', winMinRow(goods(1)), winMaxRow(goods(1)), useBaseline);
            if(plotting)
                figure
                plot(timeaxis(1:plotMax,1),  mean(waves1,2)')
                hold all
                plot(timeaxis(1:plotMax,1), mark')
                title([allSubs(i) '____'  allStims(j) '_trials:' num2str(trialnum(select)) ' min: ' num2str(pupilValue) ])
                axis(axis1);
            end
        
            %OUTPUT STATISTICS COMMANDS    
            %filename
%             filename(select(1))
            outCell{i+1,1} = filename(select(1));
            %minimum pupil
%             mean(meanDiameter(select))
            outCell{i+1, 1 + (j-1)*length(stats) + 1} = pupilValue;
            %pupil ok
%             mean(combination_column_2(select))
            outCell{i+1,1 + (j-1)*length(stats) + 2} = mean(combination_column_2(select));
            %trial count
%             length(combination_column_2(select))
            outCell{i+1,1 + (j-1)*length(stats) + 3} = length(combination_column_2(select));
            
        end
                
    end
end

c = num2str(clock);
outputVersion = c(1:70);
outputVersion = strrep(outputVersion, '             ', '-');
outputVersion = strrep(outputVersion, '      ', '');
save(['outCell_mean' outputVersion '.mat'], 'outCell')
save(['outwaves' outputVersion '.mat'], 'wwavesSN', 'wwavesMN', 'wwavesSP','wwavesMP')
