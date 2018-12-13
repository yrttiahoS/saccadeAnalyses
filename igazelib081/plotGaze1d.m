function [hfig] = plotGaze1d(DATA, HEADERS)
%Function [hfig] = plotGaze1d(DATA, HEADERS)
%
% Plots the gaze in DATA one-dimensionally. A handle to figure is returned.

disp('Plotting gaze (1d)...');

rowcount = rowCount(DATA);

% search column values to use
xgl = findColumnNumber(HEADERS, 'XGazePosLeftEye');
ygl = findColumnNumber(HEADERS, 'YGazePosLeftEye');
xgr = findColumnNumber(HEADERS, 'XGazePosRightEye');
ygr = findColumnNumber(HEADERS, 'YGazePosRightEye');
%yg = findColumnNumber(HEADERS, 'CursorY');
%xg = findColumnNumber(HEADERS, 'CursorX');


hfig = figure;
plot([DATA{xgr} DATA{xgl} DATA{ygr} DATA{ygl}]);

axis([0 rowcount+1 0 1]);
%axis tight;

xlabel('Datapoint');
ylabel('Pixel coordinate');

disp('Done.');