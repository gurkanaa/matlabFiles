function [frequency,phase,corr]=bisectionMethod(data,fLow,fHigh,fs,ts,freqResolution)
%%%finds exact frequency with bisection method
%frequencyResolution=freqResolution;
goldenRatio=1.61803398875;
while (fHigh - fLow > freqResolution)
    f1 = fHigh - (fHigh - fLow) / goldenRatio;
    f2 = fLow + (fHigh - fLow) / goldenRatio;
    [corrf1,phase1]=findPhaseCorrelation(data,f1,ts,fs);
    [corrf2,phase2]=findPhaseCorrelation(data,f2,ts,fs);
    if (corrf2 > corrf1)
        corr=corrf2;
        fLow = f1;
        phase = phase2;
        frequency = f2;
    else
        corr=corrf1;
        fHigh = f2;
        phase = phase1;
        frequency = f1;
    end
end

	