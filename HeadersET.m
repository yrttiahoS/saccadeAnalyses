% class for eye tracking  headers

classdef HeadersET < handle
    %%
    %   datasctructures are private, use methods/functions to update them
    properties (SetAccess = private, GetAccess = public)
        % container containing headers, their column numbers, correpsonding
        % data format (maybe ALIAS(es) as well?)
        
        hds = containers.Map
        
        a = 1
        
    end
    %%
    methods
        function H = HeadersET(varargin)
            disp('HeadersET object constructed');
            H.hds('Filename') =                     struct('colNum', 1,  'format', '%s');
            H.hds('Session') =                      struct('colNum', 2,  'format', '%d');
            H.hds('ID') =                           struct('colNum', 3,  'format', '%d');
            H.hds('TETTime') =                      struct('colNum', 4,  'format', '%f');
            %H.hds('RTTime') =                      struct('colNum', 5,  'format', '%d');
            %H.hds('CursorX') =                     struct('colNum', 6,  'format', '%d');
            %H.hds('CursorY') =                     struct('colNum', 7,  'format', '%d');
            %H.hds('TimestampSec') =                struct('colNum', 8,  'format', '%d');
            %H.hds('TimestampMicrosec') =           struct('colNum', 9,  'format', '%d');
            H.hds('XGazePosLeftEye') =              struct('colNum', 5, 'format', '%f');
            H.hds('YGazePosLeftEye') =              struct('colNum', 6, 'format', '%f');
            H.hds('XCameraPosLeftEye') =            struct('colNum', 7, 'format', '%f');
            H.hds('YCameraPosLeftEye') =            struct('colNum', 8, 'format', '%f');
            H.hds('DiameterPupilLeftEye') =         struct('colNum', 9, 'format', '%f');
            H.hds('DistanceLeftEye') =              struct('colNum', 10, 'format', '%f');
            H.hds('ValidityLeftEye') =              struct('colNum', 11, 'format', '%d');
            H.hds('XGazePosRightEye') =             struct('colNum', 12, 'format', '%f');
            H.hds('YGazePosRightEye') =             struct('colNum', 13, 'format', '%f');
            H.hds('XCameraPosRightEye') =           struct('colNum', 14, 'format', '%f');
            H.hds('YCameraPosRightEye') =           struct('colNum', 15, 'format', '%f');
            H.hds('DiameterPupilRightEye') =        struct('colNum', 16, 'format', '%f');
            H.hds('DistanceRightEye') =             struct('colNum', 17, 'format', '%f');
            H.hds('ValidityRightEye') =             struct('colNum', 18, 'format', '%d');
            %H.hds('TrialId') =                     struct('colNum', 24, 'format', '%d');
            H.hds('TrialNum') =                     struct('colNum', 19, 'format', '%d');
            H.hds('Stim') =                         struct('colNum', 20, 'format', '%s');
            %H.hds('Target') =                      struct('colNum', 26, 'format', '%s');
            H.hds('LateralStimPos') =               struct('colNum', 21, 'format', '%s');
            %H.hds('AOI') =                         struct('colNum', 27, 'format', '%d');
            %H.hds('UserDefined_1') =               struct('colNum', 28, 'format', '%s');
            H.hds('StimEvent') =                    struct('colNum', 22, 'format', '%s');
            H.hds('LeftEyeGazePoint3dX') =          struct('colNum', 23, 'format', '%f');
            H.hds('LeftEyeGazePoint3dY') =          struct('colNum', 24, 'format', '%f');
            H.hds('LeftEyeGazePoint3dZ') =          struct('colNum', 25, 'format', '%f');
            H.hds('LeftEyePosition3dRelativeX') =   struct('colNum', 26, 'format', '%f');
            H.hds('LeftEyePosition3dRelativeY') =   struct('colNum', 27, 'format', '%f');
            H.hds('LeftEyePosition3dRelativeZ') =   struct('colNum', 28, 'format', '%f');
            H.hds('LeftEyePosition3dX') =           struct('colNum', 29, 'format', '%f');
            H.hds('LeftEyePosition3dY') =           struct('colNum', 30, 'format', '%f');
            H.hds('LeftEyePosition3dZ') =           struct('colNum', 31, 'format', '%f');
            H.hds('RightEyeGazePoint3dX') =         struct('colNum', 32, 'format', '%f');
            H.hds('RightEyeGazePoint3dY') =         struct('colNum', 33, 'format', '%f');
            H.hds('RightEyeGazePoint3dZ') =         struct('colNum', 34, 'format', '%f');
            H.hds('RightEyePosition3dRelativeX') =  struct('colNum', 35, 'format', '%f');
            H.hds('RightEyePosition3dRelativeY') =  struct('colNum', 36, 'format', '%f');
            H.hds('RightEyePosition3dRelativeZ') =  struct('colNum', 37, 'format', '%f');
            H.hds('RightEyePosition3dX') =          struct('colNum', 38, 'format', '%f');
            H.hds('RightEyePosition3dY') =          struct('colNum', 39, 'format', '%f');
            H.hds('RightEyePosition3dZ') =          struct('colNum', 40, 'format', '%f');
            H.hds('Block') =                        struct('colNum', 41, 'format', '%f');           
        end
        
%         function doSomething(H, val)
%             disp(num2str(val))
%             H.a = val;
%             
%             sys.SetOfSignal('dd').sumrole='hello'
%             dd = sys.SetOfSignal('dd'); 
%             dd.sumrole='hello'
%             
% %             H.hds('AOI').colNum = 111;
% %             H.hds('FieldX') = 123;
%         end
%         
%         function set.a(H, val)
%             H.a = val;
%             disp(H.a)
%         end
        
        function setColNum(H,hName,colNumIn)
        % function for setting column number for particluar headers
        % hName -  name of header
        % colNumIn - input for new column number to be stored
        
            %if input column number is out of bounds, assign -1
            if colNumIn < 1 || colNumIn > length(keys(H.hds))
                hName
                colNumIn
                colNumIn = -1;
            end
            
            % access the struct under Map field for desired header
            struct_at_hMapfield = H.hds(hName);
            % assign new column number into struct
            struct_at_hMapfield.colNum = colNumIn;
            % put struct back to header Map
            H.hds(hName) = struct_at_hMapfield;
            
        end
        
        
        function addHeader(H, name, format)
            
            headerAlreadyIncluded = max(strcmp(H.hds.keys(), name));
            if ~headerAlreadyIncluded
                lastHeaderIndex = length(H.hds);
                H.hds(name) = struct('colNum', lastHeaderIndex+1, 'format', format);
            end
            
        end
            
        
            
            
    end
    %%
end

