%%%modified code with shortlong fft method
%%%modified code with shortlong fft method
clear;
clc;
%data read
fid=fopen('motorcurrent.txt','r');%includes only 11 frame
data=fscanf(fid,'%f');
fclose(fid);
fs=50000;%20kHz signal
frameLength=2*8192; %all ffts will be of length 16384
data=reshape(data,frameLength,length(data)/frameLength);
shortData=data(:,5);
dummy=reshape(data(:,1:10),1,10*frameLength);
longData=dummy(1:10:end);

 
%peak detection

 
    %taking fft of both signals
    Y = fft(longData);
    P2 = abs(Y/frameLength);
    P1 = P2(1:frameLength/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = (fs/10)*(0:(frameLength/2))/frameLength;
    [dummy,index]=max(P1);
    %%derivative    
    klm=P1(1:end-1)-P1(2:end);
    %detecting peaks
    dm=[];
    peaks=[];
    for i=1:length(klm)
        if(i==1)
            if(P1(i)>db2mag(-80)*max(P1))
                dm=[dm;i];
                peaks=[peaks;P1(i)];
            end
        elseif(((klm(i-1)<0)&&klm(i)>0)&&P1(i)>db2mag(-80)*max(P1))
            dm=[dm;i];
            peaks=[peaks;P1(i)];
        end
    end
    %peaks order
    [magnitudes,orderOfPeaks]=sort(peaks,'descend');
    %findind exact frequency in order
    residue=longData;
    parameters=[];
    for i=1:length(dm)
       if(f(dm(orderOfPeaks(i)))~=0)
           fLow=f(dm(orderOfPeaks(i)))-fs/(20*frameLength);
           fHigh=f(dm(orderOfPeaks(i)))+fs/(20*frameLength);
           [frequency,phase,corr]=bisectionMethod(residue,fLow,fHigh,fs/10,0,0.01);
           tLong=(0:frameLength-1)*10/fs;
       else
           frequency=0;
           phase=0;
           corr=sum(residue);
       end
        parameters=[parameters;frequency phase corr];
        x=cos(2*pi*frequency*tLong-phase);
        residue=residue-corr*x/(x*x');
    end
klmslmsl
    
