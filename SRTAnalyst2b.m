%class for SRT analysis

classdef SRTAnalyst2b  < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private, GetAccess = private)
        gf %Gazefile
        params % ParamsET
        %h %HeadersET %headers are in gf
        %trialData % no such property needed, can be local function var
        trialAtHand = 1
        
        firstTETTtime
        
        headers %Cell array =
        ttimeCol %column number
        eventCol %column number
        valrCol  %column number
        vallCol  %column number
        combxCol %column number
        combyCol %column number
        combvalCol %column number
        
        out %OutputMetrics %outputrepository
        
    end
    
    methods
        
        function a = SRTAnalyst2b(Gazefile, ParamsET)%, HeadersET)
            a.gf = Gazefile;
            a.params = ParamsET;
            %h = HeadersET;
            
            a.headers  = a.gf.getHeaders();
            a.ttimeCol = a.gf.headersObj.hds('TETTime').colNum;
            a.eventCol = a.gf.headersObj.hds('StimEvent').colNum;
            a.valrCol = a.gf.headersObj.hds('ValidityRightEye').colNum;
            a.vallCol = a.gf.headersObj.hds('ValidityLeftEye').colNum;
            a.combxCol = a.gf.headersObj.hds('CombinedX').colNum;
            a.combyCol = a.gf.headersObj.hds('CombinedY').colNum;
            a.combvalCol =a.gf.headersObj.hds('CombinedValidity').colNum;
            
            
            a.gf.headersObj.hds('CombinedX')
            a.gf.headersObj.hds('CombinedY')
            a.gf.headersObj.hds('CombinedValidity')
            
            
            a.out = OutputMetrics(a.gf.getFolder()); %arg=1 is arbitrary
            
            a.firstTETTtime = a.gf.getStartTime();
            
        end
        
        function analyzeFile(a)
            for i = 1:a.gf.getTrialCount()
                trialData = a.gf.getTrialData();
                a.analyzeTrialData(trialData);
                a.nextTrial();
            end
            a.out.writeOutput();
        end
        
        
        
        function analyzeTrialData(a, trialData)
            disp(['Processing trial ' num2str(a.trialAtHand)]);
            
            %makeDataSelectionsForAnalyses
            
            %%
            % important variables, values will be assigned conditionally
            % initialize these here
            first_time_in_side_aoi = -1;
            last_time_in_center_aoi = -1;
            re_time = -1;
            combination = -1;
            csaccp = -1; 
            
            % rows containing Face or Target
            data = getRowsContainingValue(trialData, a.eventCol , {'Face', 'Target'}); %'TargetPlay'
            
            % interpolate (even though some of the data is probably bad, interpolate all, just
            % mark the validity information in other columns)
            data = interpolateUsingLastGoodValue(data, a.combxCol, a.combvalCol, a.params.accepted_validities);
            data = interpolateUsingLastGoodValue(data, a.combyCol, a.combvalCol, a.params.accepted_validities);
            
            testVar = a.trialAtHand;
            
            
            data = medianFilterData(data, a.params.medianfilterlen, a.combyCol);
            data = medianFilterData(data, a.params.medianfilterlen, a.combxCol); %c = medfilt1(b,50);
            
            % clip the data some more, include data up to max allowed
            % re-engagement (e.g., 4000 ms)
            data_0_relimit = clipFirstMilliSeconds(data, a.headers, a.params.max_re_time);
            
            % cut the data to "start" after when target appears to the screen
            % and fit to the analysis requirements
            data_face =           getRowsContainingValue(data_0_relimit, a.eventCol, 'Face');
            data_target =         getRowsContainingValue(data_0_relimit, a.eventCol, 'Target');
                        
            %   data before maximal allowed disegagement RT (eg. 1000 ms
            %   from target onset)
            data_target_disemax = clipFirstMilliSeconds(data_target, a.headers, a.params.max_dise_time);
            
            %   data after min_dise_time i.e after minimal RT (e.g., 150 ms)
            data_disemin_disemax = clipMilliSecondsAfter(data_target_disemax, a.headers, a.params.min_dise_time);
            
            % just to align data correctly in visualization
            % length in frames, up to minSRT (eg 150)
            rowcount_target_disemin = rowCount(clipFirstMilliSeconds(data_target_disemax, a.headers, a.params.min_dise_time));
            
            % disengagement to side aoi?, sample index within peri-target
            % period
            latStimPos = getValue(data, 1, a.gf.headersObj.hds('LateralStimPos').colNum );
            
            first_time_in_sideaoi_row = gazeInAOIRow(data_disemin_disemax, a.combxCol, a.combyCol, a.params.aoi(latStimPos), 'first'); % data
            
            %target/distractor onset frame
            targetrow = find(strcmp(getColumn(data_0_relimit, a.eventCol), 'Target'), 1,'first');            
            
            if first_time_in_sideaoi_row ~= -1
                % there is a disengagement during the limited time
                % remove data after disengagment sample
                data_disemin_ft_sideaoi = clipFirstRows(data_disemin_disemax, first_time_in_sideaoi_row);
                
                % calculate last time/sample when in center aoi
                last_time_center_row = gazeInAOIRow(data_disemin_ft_sideaoi, a.combxCol, a.combyCol, a.params.aoi('center'), 'last'); % erilleen toisen ajan kanssa              
            else
                % if no disengagement, cut to max disengagement time
                data_disemin_ft_sideaoi = clipFirstMilliSeconds(data_disemin_disemax, a.headers, a.params.max_dise_time - a.params.min_dise_time); % only used in drawing rowcount
                last_time_center_row = -1;
            end
            
            %find re-engagement
            data_after_disengagement = clipLastRows(data_target, last_time_center_row + rowcount_target_disemin + 1); % data_target_end
            re_engagement_row = gazeInAOIRow(data_after_disengagement, a.combxCol, a.combyCol, a.params.aoi('center'), 'first');
                        
            % duration of face stimulus
            time_face = getDuration(data_face, a.ttimeCol); %getValue(data_face, rowCount(data_face), a.ttimeCol) - getValue(data_face, 1, a.ttimeCol); % time_face(rc) = ...
            % target duration
            time_target = getDuration(data_target, a.ttimeCol); %getValue(data_target, rowCount(data_target), a.ttimeCol) - getValue(data_target, 1, a.ttimeCol); %time_target(rc) =
            
            
            if last_time_center_row ~= -1 && first_time_in_sideaoi_row ~= -1
                % disengagement
                % calculate time in milliseconds after target onset, STORE METRIC
                last_time_in_center_aoi = getValue(data_disemin_ft_sideaoi, last_time_center_row, a.ttimeCol) - getValue(data_target_disemax, 1, a.ttimeCol); % last_time_in_center_aoi(rc)
                                
                % calculate first disengagement time to side aoi, STORE METRIC
                first_time_in_side_aoi = getValue(data_disemin_disemax, first_time_in_sideaoi_row, a.ttimeCol) - getValue(data_target_disemax, 1, a.ttimeCol); %first_time_in_side_aoi(rc)
                
                % METRICS 0-FIRST TIME IN SIDE AOI
                % analysis period contains faceonly + anticpatory RT period + accpetable RT period up to gaze reaching target
                analysis_perioid_data = clipFirstRows(data_0_relimit, targetrow + first_time_in_sideaoi_row + rowcount_target_disemin - 2);
            else
                % no disengagement
                last_time_in_center_aoi = -1;
                first_time_in_side_aoi = -1;
                
                % METRICS 0-2000
                % an- period contains face duration + maximal acceptable SRT
                analysis_perioid_data = clipFirstMilliSeconds(data_0_relimit, a.headers, time_face + a.params.max_dise_time);
            end
            
            % calculate some metrics of gaze validity
            [longest_nvr] = longestNonValidSection(analysis_perioid_data, a.valrCol, a.ttimeCol, a.params.accepted_validities);   %[longest_nvr(rc)]
            [longest_nvl] = longestNonValidSection(analysis_perioid_data, a.vallCol, a.ttimeCol, a.params.accepted_validities);   %[longest_nvl(rc)]
            [longest_nvc] = longestNonValidSection(analysis_perioid_data, a.combvalCol, a.ttimeCol, a.params.accepted_validities);%[longest_nvc(rc)]
            [validityr] = validGazePercentage(analysis_perioid_data, a.valrCol, a.params.accepted_validities);     %[validityr(rc), validityl(rc)]
            [validityl] = validGazePercentage(analysis_perioid_data, a.vallCol, a.params.accepted_validities);     %[validityr(rc), validityl(rc)]
            
            
            %%%%%%%%%%%%%%%%%
            % duration of the analysis period (ca. 1150 - 1200 ms)
            time_analysis_perioid = getValue(analysis_perioid_data, rowCount(analysis_perioid_data), a.ttimeCol) - getValue(analysis_perioid_data, 1, a.ttimeCol); %time_analysis_perioid(rc)
            
            % proportion time gaze was in center AOI before reaching
            % target, STORE METRIC
            inside_aoi = gazeInAOIPercentage(analysis_perioid_data, a.combxCol, a.combyCol, a.ttimeCol, a.params.aoi('center')); % data_before_disengagement, inside_aoi(rc)
            %a.out.appendData('% inside center aoi bef disengagement', inside_aoi);
            
            % boolean for case where AOI changed after data break, STORE METRIC
            aoi_violation = AOIBorderViolationDuringNonValidSection(analysis_perioid_data, a.combxCol, a.combyCol, a.combvalCol, ...
                a.params.aoi('center'), a.params.accepted_validities); % data_before_disengagement, aoi_violation(rc)
            %aoi_violation(rc) = AOIBorderViolationDuringNonValidSection(data_disemin_ft_sideaoi, combx, comby, combval, aoi('center'), accepted_validities); % data_before_disengagement
            
            % gather information to the csv-file(s)
            stimInThisTrial = getValue(data, 1, a.gf.headersObj.hds('Stim').colNum);           
            numberOfThisTrial = getValue(data, 1, a.gf.headersObj.hds('TrialNum').colNum);
            
            
            technical_error = longest_nvc > a.params.longest_nonvalid_tresh || aoi_violation == 1 || inside_aoi <  a.params.inside_aoi_tresh || ...
                time_target < a.params.min_target_time || time_face < a.params.min_face_time;
            % gather information about to the combined column
            if technical_error
                % violation of conditions
                combination = -1;
                re_time = -1;
                csaccp = -1;
            elseif last_time_in_center_aoi >= 0
                % gaze shifts
                combination = last_time_in_center_aoi;
                csaccp = cumulativeSaccadePotential(combination, a.params.min_dise_time, a.params.max_dise_time); %csaccp(rc)
                if re_engagement_row ~= -1 % re-engagement happends
                    re_time = getValue(data_after_disengagement, re_engagement_row, a.ttimeCol) - getValue(data_after_disengagement, 1, a.ttimeCol);
                else % no re-engagement (max)
                    re_time = -2;
                end
            else
                % gaze stays center (no disengagement)
                combination = a.params.max_dise_time;
                csaccp = cumulativeSaccadePotential(combination, a.params.min_dise_time, a.params.max_dise_time);
                re_time = -1;
            end
             
%             % gather information about to the combined column
%             if last_time_in_center_aoi >= 0  % last_time_in_center_aoi
%                 % gaze shifts
%                 if a.params.longest_nonvalid_tresh < longest_nvc ||  aoi_violation == 1 || inside_aoi < a.params.inside_aoi_tresh
%                     % violation of conditions
%                     combination = -1;
%                     re_time = -1;
%                     csaccp = -1;
%                 else
%                     combination = last_time_in_center_aoi; % combination_column(rc)
%                     
%                     % this case do re-engagement test
%                     data_after_disengagement = clipLastRows(data_target, last_time_center_row + rowcount_target_disemin + 1); % data_target_end
%                     re_engagement_row = gazeInAOIRow(data_after_disengagement, a.combxCol, a.combyCol, a.params.aoi('center'), 'first');
%                     
%                     if re_engagement_row ~= -1
%                         % re-engagement happends
%                         re_time = getValue(data_after_disengagement, re_engagement_row, a.ttimeCol) - getValue(data_after_disengagement, 1, a.ttimeCol); 
%                     else
%                         % no re-engagement (max)
%                         re_time = -2;
%                     end
%                     
%                     % csaccp, STORE METRIC
%                     csaccp = cumulativeSaccadePotential(combination, a.params.min_dise_time, a.params.max_dise_time); %csaccp(rc)
%                 end
%                 
%             else
%                 % gaze stays center (no disengagement)
%                 if longest_nvc  > a.params.longest_nonvalid_tresh ||  aoi_violation == 1 || inside_aoi < a.params.inside_aoi_tresh || ...
%                         time_target < a.params.min_target_time || time_face < a.params.min_face_time
%                     % violation of conditions, STORE METRICs
%                     combination = -1;
%                     csaccp = -1;
%                 else
%                     combination = a.params.max_dise_time;
%                     csaccp = cumulativeSaccadePotential(combination, a.params.min_dise_time, a.params.max_dise_time);
%                 end
%                 re_time = -1;
%             end
            
            % Append results to output object
            a.out.appendData('Filename', {a.gf.getFilename});
            a.out.appendData('Stimulus', {stimInThisTrial});
            a.out.appendData('Trial number', numberOfThisTrial);
            
            a.out.appendData('Analysis perioid len', time_analysis_perioid);
            a.out.appendData('Face up', time_face);
            a.out.appendData('TETtime1', a.gf.getStartTime());
            a.out.appendData('Face up TET', getValue(data_face, rowCount(data_face), a.ttimeCol));
            a.out.appendData('Target up', time_target);
            
            a.out.appendData('last time in center aoi', last_time_in_center_aoi); 
            a.out.appendData('first time in side aoi', first_time_in_side_aoi);  
            
            a.out.appendData('longest non-valid streak (r)', longest_nvr);
            a.out.appendData('longest non-valid streak (l)', longest_nvl);
            a.out.appendData('longest non-valid combined', longest_nvc);
            a.out.appendData('valid gaze r %', validityr);
            a.out.appendData('valid gaze l %', validityl);
          
            a.out.appendData('% inside center aoi bef disengagement', inside_aoi);
            a.out.appendData('aoi violation', aoi_violation);
            
            a.out.appendData('Lateral stim position', {latStimPos})
            a.out.appendData('combination', combination);
            a.out.appendData('csaccpindex', csaccp);
            a.out.appendData('re-engagement time', re_time);
            
            
            
%             function makeDataSelectionsForAnalyses
%             end
            
        end
        
        
        %         function takeTrialData(a)
        %             trialData = Gazefile.getTrialClip();
        %         end
        %
        %         function getRow()
        %         end
        
    
        function nextTrial(a)
                a.trialAtHand = a.trialAtHand + 1;
                if a.trialAtHand > a.params.cliplimit
                    a.trialAtHand = a.params.cliplimit;
                end
        end
    
    end

end

