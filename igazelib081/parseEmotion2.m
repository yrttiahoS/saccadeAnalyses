function emo = parseEmotion2(stimfilename)
%function emo = parseEmotion(stimfilename)
%
% Function figures out emotional category from stimulus filename.

%INPUT; stimfilename = string, name of the stimulus file
%OUPTUT: emo = string, indicates the emotion category
%     examples: ++129A.bmp is strong positive, sp
%                +174B.bmp is mild positive, mp
%               --176A.bmp is strong negative, sn
%                -196b.bmp is mild negative, mn

%SA studies
if length(strfind(stimfilename,'-')) == 2
    emo = 'SN';
elseif length(strfind(stimfilename,'-')) == 1
    emo = 'MN';
elseif length(strfind(stimfilename,'+')) == 2
    emo = 'SP';
elseif length(strfind(stimfilename,'+')) == 1
    emo = 'MP';
%Familystudy 
elseif length(strfind(stimfilename,'hap')) == 1
    emo = 'hap';
elseif length(strfind(stimfilename,'sad')) == 1
    emo = 'sad';
%if no match
else
    emo = 'MISSING';
end

