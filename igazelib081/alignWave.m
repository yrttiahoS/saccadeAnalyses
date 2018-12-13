function waveOut = alignWave(waveIn, maxTime, defaultTrig, currentTrig)
%function waveOut = alignWave(waveIn, maxTime, defaultTrig, currentTrig)
% Shifts wave in time so that the trigger coincides with the reference
% timevalue (defaultTrig). Can be used e.g., for aligning jittered waves
% before averaging.
% 
% Parameters in:
% waveIn = input 1-d waveform
% maxTime = maximum length for output vector (samples i.e., vector indices)
% defaultTrig = reference trigger time value (samples)
% currentTrig = specific trigger timevalue for the input wave
% 
% Parameter(s) out:
% waveOut = output wave, which is aligned to defaultTrig
% 
% Key variables within algorithm
% padding = zeros that will be padded after timeshift to compensate for
% samples that are removed from the beginnning part. (The idea is to keep
% aligned wave vector equal in size to the original input vector.)

% Generate paddinng
if currentTrig <= defaultTrig %if already aligned, make empty padding
    timeShift = defaultTrig - currentTrig;
    padding = zeros(1, timeShift);
    waveOut = [padding waveIn];
elseif currentTrig > defaultTrig
    timeShift = currentTrig - defaultTrig;
    padding = zeros(1, timeShift);
    %put some extra padding
    padding = [padding padding];
    waveOut = [waveIn padding];
    % align wave by timeshift and pad to compensate for lost elements
    waveOut = waveOut( timeShift+1 : length(waveIn)+timeShift )   ;
end




% 
%  length(waveIn)
%  timeShift
% length(padding)



%crop result to maximum time limit
 waveOut = waveOut(1:maxTime); 

