function [hfig] = plotGaze2d(DATA, HEADERS)
%Function [hfig] = plotGaze2d(DATA, HEADERS)
%
% Plots the gaze in the DATA-array 2-dimensionally. The figure handle hfig
% is returned.

disp('Plotting gaze (2d)...');

% search column values to use
xgl = findColumnNumber(HEADERS, 'XGazePosLeftEye');
ygl = findColumnNumber(HEADERS, 'YGazePosLeftEye');
xgr = findColumnNumber(HEADERS, 'XGazePosRightEye');
ygr = findColumnNumber(HEADERS, 'YGazePosRightEye');

hfig = figure;
plot(DATA{xgl}, DATA{ygl}, 'o', DATA{xgr}, DATA{ygr}, 'x');
set(gca,'YDir','reverse');
axis([0 1 0 1]);

disp('Done.');