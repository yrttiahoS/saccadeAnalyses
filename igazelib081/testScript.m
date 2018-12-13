function testScript(file)
%Function testScript(file)
%
% Common testing place for new scripts. By default contains simple example
% script.

accepted_validities = [0 1];

% Load a file
[DATA, HEADERS] = loadGazeFile(file);

% Clip the data according to change in the column named 'TrialId'
trialid_col = findColumnNumber(HEADERS, 'TrialId');
clipdata = clipDataWhenChangeInCol(DATA, trialid_col);

% now loop each "chunk"
clipcount = length(clipdata);
for i=1:clipcount
    data = clipdata{i};

    % take the first 2000 milliseconds (or less) from the chunk
    data = clipFirstMilliSeconds(data, HEADERS, 2000);

    % perform interpolation for each of the gaze-coordinate
    data = interpolateUsingLastGoodValue(data, findColumnNumber(HEADERS, 'XGazePosLeftEye'), findColumnNumber(HEADERS, 'ValidityLeftEye'), accepted_validities);
    data = interpolateUsingLastGoodValue(data, findColumnNumber(HEADERS, 'YGazePosLeftEye'), findColumnNumber(HEADERS, 'ValidityLeftEye'), accepted_validities);
    data = interpolateUsingLastGoodValue(data, findColumnNumber(HEADERS, 'XGazePosRightEye'), findColumnNumber(HEADERS, 'ValidityRightEye'), accepted_validities);
    data = interpolateUsingLastGoodValue(data, findColumnNumber(HEADERS, 'YGazePosRightEye'), findColumnNumber(HEADERS, 'ValidityRightEye'), accepted_validities);
    
    % median filter data with window length 37
    data = medianFilterData(data, 37, findColumnNumber(HEADERS, 'XGazePosRightEye'));
    data = medianFilterData(data, 37, findColumnNumber(HEADERS, 'YGazePosRightEye'));
    data = medianFilterData(data, 37, findColumnNumber(HEADERS, 'XGazePosLeftEye'));
    data = medianFilterData(data, 37, findColumnNumber(HEADERS, 'YGazePosLeftEye'));
    
    % calculate the distance travelled in this data chunk
    [a, b] = distanceTravelled(data, HEADERS, 1.6, 0.5)
    
    % last, plot an animation of the gaze during this chunk
    plotDetailedGazeAnimation(data, HEADERS, '', 0, accepted_validities, 0);
end