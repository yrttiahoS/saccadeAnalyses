function emo = parseEmotionBoston(stimfilename)
%function emo = parseEmotion(stimfilename)
%
% Function figures out emotional category from stimulus filename.

%INPUT; stimfilename = string, name of the stimulus file
%OUPTUT: emo = string, indicates the emotion category
%     examples: Dhappy2.bmp is HAPPY
%stimfilename
if ~isempty(strfind(stimfilename,'happy'))
    emo = 'Happy';
elseif ~isempty(strfind(stimfilename,'angry'))
    emo = 'Angry';
elseif ~isempty(strfind(stimfilename,'fearful'))    
    emo = 'Fear';
elseif ~isempty(strfind(stimfilename,'neutral'))    
    emo = 'Neutral';
else
    emo = 'Missing';
end
