function distvector = distanceBetwEyesInTheScreen(DATA, HEADERS)
%Function distvector = distanceBetwEyesInTheScreen(DATA, HEADERS)
%
% Returns the maximum distance between eyes in the screen. Assumes the
% columns to be named e.g. 'XGazePosLeftEye'.


%disp(['Finding distance between eyes in the screen...']);

rowcount = rowCount(DATA);

% search column values to use
xgl = findColumnNumber(HEADERS, 'XGazePosLeftEye');
ygl = findColumnNumber(HEADERS, 'YGazePosLeftEye');
xgr = findColumnNumber(HEADERS, 'XGazePosRightEye');
ygr = findColumnNumber(HEADERS, 'YGazePosRightEye');

% calculate distance between x and y coordinate in 
for i=1:rowcount
    xdiff = abs(DATA{xgl}(i) - DATA{xgr}(i));
    ydiff = abs(DATA{ygl}(i) - DATA{ygr}(i));
    distvector(i) = sqrt(xdiff^2+ydiff^2);
end

%disp('Done.');