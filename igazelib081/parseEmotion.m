function emo = parseEmotion(stimfilename)
%function emo = parseEmotion(stimfilename)
%
% Function figures out emotional category from stimulus filename.

%INPUT; stimfilename = string, name of the stimulus file
%OUPTUT: emo = string, indicates the emotion category
%     examples: ++129A.bmp is strong positive, sp
%                +174B.bmp is mild positive, mp
%               --176A.bmp is strong negative, sn
%                -196b.bmp is mild negative, mn

%Capture key characters from the beginnning of string into emoSign
% emoSign = ''; 
% i = 1;
% while stimfilename(i) == '+' || stimfilename(i) == '-'
%     emoSign = [emoSign stimfilename(i)];
%     i = i + 1;
% end

if length(strfind(stimfilename,'-')) == 2
    emo = 'SN';
elseif length(strfind(stimfilename,'-')) == 1
    emo = 'MN';
elseif length(strfind(stimfilename,'+')) == 2
    emo = 'SP';
elseif length(strfind(stimfilename,'+')) == 1
    emo = 'MP';
else
    emo = 'MISSING';
end

%Assign emotion class as SN (strong negative) etc.
% switch emoSign
%     case '--'
%         emo = 'SN';
%     case '-'
%         emo = 'MN';
%     case '++'
%         emo = 'SP';
%     case '+'
%         emo = 'MP';
%     otherwise
%         emo = 'MISSING';
% end