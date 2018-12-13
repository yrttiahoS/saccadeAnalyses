function hfig = plotPupilAnimation(DATA, HEADERS, columns, figtitle, delaytime, accepted_validities, savegaze, imageparameters, aois, markertimes, disptext)
%Function hfig = plotGazeAnimation(DATA, HEADERS, figtitle, columns, delaytime, accepted_validities, savegaze, imageparameters, aois, markertimes, disptext)
%
% Function plots gaze animation of the participant read from the
% DATA-matrix. figtitle specifies the name of the figure. Varargin may
% contain still images that are placed in the animation accordingly.
% Delaytime is to tune the loop slower if the computer is "too" fast.
% varargin format is what follows:
% {imagefile, coordinates, startrow, endrow}
% coordinates are in the form [xstart xend ystart yend] ( from 0-1 sceen and 
% with the same alignment as eyetracker, assumed top:0 bottom:1 left:0, right 1)
% columns = [xcol ycol valcol timecol]


'plotter'
% load imagefiles and do other tunings
for i=1:length(imageparameters)
    parameters = imageparameters{i};
    img{i} = imread(parameters{1});
    
    % Image goes up-and down, but as here we have upside down coordinates
    % it's okay.
    
    % because of the structure of the loop later (begins from 2 rather
    % than 1), change the start-time 1 to 2 as it makes little difference
    % to the viewer and facilitates the loops
    if parameters{3} == 1
        parameters{3} = 2;
        imageparameters{i} = parameters;
    end
end


% columns to use
colL = columns(1); %left eye column
colR = columns(2); %right eye column
colComb = columns(5); %average(?) of left and right; out from combineEyes()

dL = DATA{colL};
yl = DATA{colR};
combData = DATA{colComb};

val = DATA{columns(3)};

valp = (~ismember(val, accepted_validities) * (-1000) ) -0.01;

rowcount = rowCount(DATA);

starttime = getValue(DATA, 1, columns(4));

minLim = 2.5;
if(max(dL) > 0) 
    maxLim = max(dL)+0.5;
else
    %'maxlim is one'
    maxLim = 1;
    minLim = 0.9
end

if minLim > maxLim
    maxLim = minLim + 0.5;
end


axlimits = [minLim maxLim minLim maxLim];

% create figure
scrsz = get(0,'ScreenSize');
hfig = figure('Position', [0.2*scrsz(3) 0.2*scrsz(4) scrsz(3)/2 scrsz(4)/1.5]); %hfig = figure('Position', [0.2*scrsz(3) 0.2*scrsz(4) scrsz(3)/2 scrsz(4)/1.5]);
%hfig = figure;
set(hfig, 'name', figtitle, 'numbertitle', 'off');


% initialize the upper axes for coordinates
% a1 = subplot(2,1,1);
 %h1 = plot(xl(1), yl(1), 'o' ); %, 'erasemode', 'background');
% axis(axlimits);
% width = 0.40;
% set(a1, 'position', [(1-width)/2 0.5838 width 0.3412])
% set(a1,'YDir','reverse');
% title('Gaze in the display, Trial: '  );
% 
% % draw aoi's to upper axis
% for i=1:length(aois)
%     hold on;
%     aoi = aois{i};
%     plot([aoi(1) aoi(1) aoi(2) aoi(2) aoi(1)], [aoi(3) aoi(4) aoi(4) aoi(3) aoi(3)], 'r'); %, 'erasemode', 'background');
%     hold off;
% end

% initialize the lower axes for time-view
a2 = subplot(1,1,1);

disp_text_area = uicontrol('Style', 'text', 'string', disptext, 'horizontalalignment', 'left', 'units', 'normalized', 'position', [0.05 0.01 0.90 0.03], 'fontsize', 15, ...
                           'backgroundcolor', 'white'); %get(gcf, 'color'));
x = zeros(1, rowcount);
%x(1) = 0;

% construct timevector
for i=1:rowcount
    %x(i) = getValue(DATA, i, findColumnNumber(HEADERS, 'TETTime')) - starttime;
    x(i) = getValue(DATA, i, columns(4)) - starttime;
end

%x = 1:rowcount;
limits = [minLim maxLim];

%debug
%rowCount(DATA)
%markertimes

%plot lower panel
h2 = plot([0 0], [limits(1) limits(2)], 'k',  x, DATA{colL}, x, ...
    DATA{colR},  x, DATA{colComb}, x, valp + minLim+.1 , '.', x(markertimes), DATA{colL}(markertimes), 'ko');%, 'markersize', 3);

[min(x) max(x) limits(1) limits(2)]
axis([min(x) max(x) limits(1) limits(2)]);

%xlabel(['Time: ' '0']);
title(['Pupils: left=blue, right=green, combined=red, validity=cyan. ' disptext]);
xlabel('Time from start (ms)');
ylabel('Pupil size');

%set(gcf, 'currentaxes', a1);

% if uncheck, makes the drawing significantly slower
%legend(h2, 'Time', 'XR', 'XL', 'YR','YL', 'VR', 'VL', 'Location','NorthEastOutside');

% for i=2:rowcount
% 
%     % go through the images and plot those that have been selected
%     for j=1:length(imageparameters)
%         
%         parameters = imageparameters{j};
%         if parameters{3} == i
% %             hold on;
% %             coord = parameters{2};
% %             siz = size(img{j});
% 
%             %imx = [0:1:siz(2)]./siz(2).*(coord(2)-coord(1))+ coord(1);%-1/2*siz(2)/xres+0.5;
%             %imy = [0:1:siz(1)]./siz(1).*(coord(4)-coord(3))+ coord(3);%-1/2*siz(1)/yres+0.5;
%             %imghandle(j) = image(imx, imy, img{j}, 'parent', a1);
%             %uistack(imghandle(j), 'bottom');
%             hold off;
%         end
%         
%         if parameters{4} == i
%             delete(imghandle(j));
%         end
%     end
%     
%     if dL(i) > 0 
%         msize = dL(i) * 10;
%     else
%         msize = .0001;
%     end
%     %set(h1(1), 'Xdata', dL(1:i), 'Ydata', yl(1:i) , 'MarkerSize',3 );
%     
%     set(h2(1), 'Xdata', [x(i) x(i)], 'Ydata', [limits(1) limits(2)]);
%     %xlabel(a2, ['Time: ' num2str(round(getValue(DATA, i, findColumnNumber(HEADERS, 'TETTime')) - starttime))]);
%     
%     
%     
%     % uncomment if drawing too slow
%     if mod(i,5)==0
%      drawnow;
%     end
%     
%     pause(delaytime);
% end

set(h2(1), 'Xdata', [-1 -1], 'Ydata', [limits(1) limits(2)]);

if savegaze
        print(gcf, '-dpng', figtitle );
end
