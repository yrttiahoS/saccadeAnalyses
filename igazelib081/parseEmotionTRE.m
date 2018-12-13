function emo = parseEmotionTRE(stimfilename)
%function emo = parseEmotion(stimfilename)
%
% Function figures out emotional category from stimulus filename.

%INPUT; stimfilename = string, name of the stimulus file
%OUPTUT: emo = string, indicates the emotion category
%     examples: Dhappy2.bmp is HAPPY
%stimfilename
if ~isempty(strfind(stimfilename,'happy'))
    emo = 'Hapy';
elseif ~isempty(strfind(stimfilename,'control'))
    emo = 'Conl';
elseif ~isempty(strfind(stimfilename,'fearful'))    
    emo = 'Feal';
elseif ~isempty(strfind(stimfilename,'neutral'))    
    emo = 'Neul';
else
    emo = 'Miss';
end
