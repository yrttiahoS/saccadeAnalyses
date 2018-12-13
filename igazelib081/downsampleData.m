function DATA2 = downsampleData(DATA1,  dataSamplingrate, targetSamplingrate)
% DATA2 = downsampleData(DATA1,  dataSamplingrate, targetSamplingrate)
% input params
% DATA1 - data to be processed, 1xN cell, where each cell contains large
%        1xROWS 
% dataSamplingrate - sampling rate of the input DATA1 (precalculated)
% targetSamplingrate - the desired sampling rate for output DATA
% output params
% DATA2 - version of DATA1 with desired sampling rate


nDS = 1;%downsampling factor, keeps every nth sample  
nUS = 1;%upsampling factor, inserts n – 1 zeros between samples

%calculate factors for upsampling and downsampling using Rational fraction approximation
[nUS, nDS] = rat(targetSamplingrate/dataSamplingrate);

for i = 1:length(DATA1)
    
    dat = DATA1{i}';
    dat = reshape(repmat(dat,nUS,1), 1, []);
    dat = downsample(dat, nDS);
    
    DATA2{i} = dat';
    
end


% 
% %example
% sr = 120;
% timeaxis2 = (0:(1000/sr):8000)';
% sr = 300;
% timeaxis1 = (0:(1000/sr):8000)';
% taxis = upsample(timeaxis1, 2);
% taxis2 = downsample(taxis, 5);

%%
% %generate signal with sampling rare, sr = 1000 Hz
% signal = 1:3.3333333333333333333333:8000;
% %extract sr
% srFile = 1000/mean(signal(2:length(signal)) - signal(1:length(signal)-1));
% 
% % signal = repmat('masa',600);
% 
% targetFrq = 120; %desired sampling rate in Hz
% currentFrq = 300; %sampling rate found in current signal
% currentFrq = srFile;
% 
% nDS = 1;%downsampling factor, keeps every nth sample  
% nUS = 1;%upsampling factor, inserts n – 1 zeros between samples
% 
% %calculate factors for upsampling and downsampling using Rational fraction approximation
% [nUS, nDS] = rat(targetFrq/currentFrq);
% 
% %change sampling rate by combined up- and downsampling
% signal2 = reshape(repmat(signal,nUS,1), 1, []); %kron(signal,ones(1,nUS));%  interp(signal,nUS); %upsample(signal,nUS);
% signal3 = downsample(signal2, nDS);
% 
% % check resultant sr
% srNew = 1000/mean(signal3(2:length(signal3)) - signal3(1:length(signal3)-1));
% % 
