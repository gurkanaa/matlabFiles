function [frequency,phase,corr]=frequencyPhaseSearch(data,fs,ts,freqResolution)
%%finds the frquency and phase of best fitting cosine atom
initialFrequency=searchInit(data,fs);
fLow=initialFrequency-0.5*fs/length(data);
fHigh=initialFrequency+0.5*fs/length(data);
if(fLow<0)
    frequency=0;
    phase=0;
else
    [frequency,phase,corr]=bisectionMethod(data,fLow,fHigh,fs,ts,freqResolution);
end