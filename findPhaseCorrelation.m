function [corr,phase]=findPhaseCorrelation(data,f,ts,fs)
%%%finds the correlation of data with cosine signal in phase and this phase
if(f==0)
    corr=sum(data);
    phase=0;
else
    t=ts:ts+length(data)-1;
    t=t/fs;
    corrcos=cos(2*pi*f*t)*data;
    corrsin=sin(2*pi*f*t)*data;
    if (corrcos > 0)
        phase = atan(corrsin / corrcos);
    else
        phase = atan(corrsin / corrcos) + pi;
    end

        corr = sqrt(corrcos*corrcos + corrsin*corrsin);
end