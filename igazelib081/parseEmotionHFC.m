function emo = parseEmotionHFC(stimfilename)
%function emo = parseEmotion(stimfilename)
%
% Function figures out emotional category from stimulus filename.
% Is designed for HFC or happy, fearful, and control conditions.

%INPUT; stimfilename = string, name of the stimulus file
%OUPTUT: emo = string, indicates the emotion category
%     examples: controlfe1.png
%               controlha1.png
%               fearful1.png
%               happy1.png

emo = stimfilename(1:9);

