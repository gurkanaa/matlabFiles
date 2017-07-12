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

 

    %taking fft of long signal
    %low frequency fits
    Y = fft(longData);
    P2 = abs(Y/frameLength);
    P1 = P2(1:frameLength/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = (fs/10)*(0:(frameLength/2))/frameLength;
    [maxOfFft,index]=max(P1);
    maxOfResidue=maxOfFft;
    residueLong=longData;
    residueShort=shortData';
    %%derivative
    tLong=(0:frameLength-1)*10/fs;
    tShort=(0:frameLength-1)/fs;
    phaseShiftCoef=2*pi*4*frameLength/fs;
    parameters=[];
    tic;
    energyOfSignal=shortData'*shortData;
    while(maxOfResidue>db2mag(-60)*maxOfFft) 
%     for i=1:19
        if(f(index)~=0)
            fLow=f(index)-fs/(20*frameLength);
            fHigh=f(index)+fs/(20*frameLength);
            [frequency,phase,corr]=bisectionMethod(residueLong',fLow,fHigh,fs/10,0,0.01);
        else
            frequency=0;
            phase=0;
            corr=sum(residueLong);
        end
        xLong=cos(2*pi*frequency*tLong-phase);
        xShort=cos(2*pi*frequency*tShort-phase+phaseShiftCoef*frequency);
        residueLong=residueLong-corr*xLong/(xLong*xLong');
        residueShort=residueShort-corr*xShort/(xLong*xLong');
        parameters=[parameters;frequency phase-phaseShiftCoef*frequency corr/sqrt(xShort*xShort')];        
        Y = fft(residueLong);
        P2 = abs(Y/frameLength);
        P1 = P2(1:frameLength/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        f = (fs/10)*(0:(frameLength/2))/frameLength;
        [maxOfResidue,index]=max(P1);
    end    
    toc;
    %standard MP
    tic;
    residueShort=residueShort';
    alpha= 0;%[0,0.4,0.8,1.2,1.6,2.0,2.4];
    gamma=[];%1:5;
    freqResolution=1;
    firstWeight=parameters(1,3);
    [numberOfAtoms,energyOfResidue,windowArray,indexArray,frequencyArray,phaseArray,weightArray,residue]=findAllAtoms(residueShort,fs,energyOfSignal,50,alpha,gamma,freqResolution,firstWeight);
    toc;
        
        
        
%     klm=P1(1:end-1)-P1(2:end);
    %detecting peaks
%     dm=[];
%     peaks=[];
%     for i=1:length(klm)
%         if(i==1)
%             if(P1(i)>db2mag(-80)*max(P1))
%                 dm=[dm;i];
%                 peaks=[peaks;P1(i)];
%             end
%         elseif(((klm(i-1)<0)&&klm(i)>0)&&P1(i)>db2mag(-80)*max(P1))
%             dm=[dm;i];
%             peaks=[peaks;P1(i)];
%         end
%     end
    %peaks order
    [magnitudes,orderOfPeaks]=sort(peaks,'descend');
    %findind exact frequency in order
%     residue=longData;
%     parameters=[];
%     for i=1:length(dm)
%        if(f(dm(orderOfPeaks(i)))~=0)
%            fLow=f(dm(orderOfPeaks(i)))-fs/(20*frameLength);
%            fHigh=f(dm(orderOfPeaks(i)))+fs/(20*frameLength);
%            [frequency,phase,corr]=bisectionMethod(residue,fLow,fHigh,fs/10,0,0.01);
%            tLong=(0:frameLength-1)*10/fs;
%        else
%            frequency=0;
%            phase=0;
%            corr=sum(residue);
%        end
%         parameters=[parameters;frequency phase corr];
%         x=cos(2*pi*frequency*tLong-phase);
%         residue=residue-corr*x/(x*x');
%     end
%     
