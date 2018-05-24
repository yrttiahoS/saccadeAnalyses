% class for eye tracking data reading

classdef Gazefile < handle
    
    properties (SetAccess = private)
        params% = ParamsET()
        filename
        headersObj
        folder
        DATA
        HEADERS %headers obejct better?, HeadersET.m
        trial
        meanData
        colNums = containers.Map
        clipdata
        clipcount
        limitrows
        
    end
    
    methods
        
        function GF = Gazefile(varargin)
            
            %check optional input from varargin
            p = inputParser;
            addParamValue(p,'params', GF.params);
            addParamValue(p,'filename', GF.filename);
            addParamValue(p,'headersObj', GF.headersObj);
            addParamValue(p,'folder', GF.folder);
            addParamValue(p,'limitrows', GF.limitrows);
            
            parse(p,varargin{:});
            fields = fieldnames(p.Results);
            disp(fields)
            %change parameters with optional input
            for fn=fields'
                GF.(cell2mat(fn)) = p.Results.(cell2mat(fn));
            end
            
            GF.trial = 1;
            
            %use input filename and headers object to load data
            GF.loadData();
            
            GF.findColumnNumbers();
            GF.clipData();
            
        end
        
        function loadData(GF)
            [GF.DATA, GF.HEADERS] = loadGazedataFile2(GF.filename, GF.headersObj, 'limitrows', GF.limitrows);
        end
        
        function findColumnNumbers(GF)
            
            % find COLUMN NUMBERS to know what to operate
            % these may be unneccessary because of HeadersET object!
            GF.colNums('xgazel') = colNum(GF.HEADERS, 'XGazePosLeftEye');
            GF.colNums('ygazel') = colNum(GF.HEADERS, 'YGazePosLeftEye');
            GF.colNums('xgazer') = colNum(GF.HEADERS, 'XGazePosRightEye');
            GF.colNums('ygazer') = colNum(GF.HEADERS, 'YGazePosRightEye');
            GF.colNums('valr') = colNum(GF.HEADERS, 'ValidityRightEye');
            GF.colNums('vall') = colNum(GF.HEADERS, 'ValidityLeftEye');
            GF.colNums('event') = colNum(GF.HEADERS, 'StimEvent');
            GF.colNums('ttime') = colNum(GF.HEADERS,'TETTime');            
            
            %add new headers to headersObject, 
            GF.headersObj.addHeader('CombinedX', '%d')
            %GF.headersObj.hds('CombinedX')
            GF.headersObj.addHeader('CombinedY', '%d')
            %GF.headersObj.hds('CombinedY')
            GF.headersObj.addHeader('CombinedValidity', '%d')
            %GF.headersObj.hds('CombinedValidity')
            
            
            % combine x and y -coordinates on both eyes to one 'combined'
            % coordinate for x and y (if one eye is good, use that, otherwise
            % mean of both eyes)
            [combinedx, ~] = combineEyes2(GF.DATA, GF.colNums('xgazer'), GF.colNums('xgazel'), GF.colNums('valr'), GF.colNums('vall'), ...
                GF.params.accepted_validities);
            [combinedy, newcombined] = combineEyes2(GF.DATA, GF.colNums('ygazer'), GF.colNums('ygazel'), GF.colNums('valr'), GF.colNums('vall'), ...
                GF.params.accepted_validities);
            
            % add these new columns to data-structure
            [GF.DATA, GF.HEADERS] = addNewColumn(GF.DATA, GF.HEADERS, combinedx, 'CombinedX');
            [GF.DATA, GF.HEADERS] = addNewColumn(GF.DATA, GF.HEADERS, combinedy, 'CombinedY');
            [GF.DATA, GF.HEADERS] = addNewColumn(GF.DATA, GF.HEADERS, newcombined, 'CombinedValidity');
            
            % new columns numbers
            % these may be unneccessary because of HeadersET object!
            GF.colNums('combx') = colNum(GF.HEADERS, 'CombinedX');
            GF.colNums('comby') = colNum(GF.HEADERS, 'CombinedY');
            GF.colNums('combval') = colNum(GF.HEADERS, 'CombinedValidity');
            
            
            
        end
        
        function clipData(GF)
            
            GF.DATA = replaceStringsInColumn(GF.DATA, GF.colNums('event'), 'TargetPlay', 'Target');
            GF.DATA = getRowsContainingValue(GF.DATA, GF.colNums('event'), {'Face', 'Target'});
    
            
            % clip data to separate clips according to change in column "TrialId"
            GF.clipdata = clipDataWhenChangeInCol(GF.DATA, colNum(GF.HEADERS, 'TrialNum'));
            
            GF.clipcount = length(GF.clipdata);
            
            % limit clip
            if GF.params.cliplimit < GF.clipcount
                GF.clipcount = GF.params.cliplimit;
            end
            
        end
        
        function n = getTrialCount(GF)
            n = GF.clipcount;
        end
        
        function data = getTrialData(GF)
            
            if GF.trial <= GF.getTrialCount()
                data = GF.clipdata{GF.trial};
                GF.trial = GF.trial + 1;
            else
                disp('Trial couter went index out of bounds!');
            end
            
        end
        
        
        function ttime1 = getStartTime(GF)
            ttime1 = getValue(GF.DATA, 1, GF.headersObj.hds('TETTime').colNum);
        end
        
        function dims = getDataSize(GF)
            dims = size(GF.DATA);
            
        end
        
        function fn = getFilename(GF)
            fn = GF.filename;
        end
        
        function headers = getHeaders(GF)
            headers = GF.HEADERS;    
        end
        
        function folder = getFolder(GF)
            folder = GF.folder;
        end
        
        
    end
    
end


