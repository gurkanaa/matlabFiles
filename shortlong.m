%%%long time and short time fixed point ffts
clear;
clc;

fs=20000;%20kHz signal
fftSize=2*8192; %all ffts will be of length 8192
numberOfFrames=16;
t=(1:16*fftSize)/fs;
%%parameters of signals: two close frequency
f1=50.2;
w1=4;
p1=1.4;
s1=w1*cos(2*pi*f1*t-p1);

f2=49.4;
w2=3;
p2=0.4;
s2=w2*cos(2*pi*f2*t-p2);

s=s1+s2;%generated signal

shortData1=s(7*fftSize+1:8*fftSize);
longData1=s(1:16:end);

%taking fft of both signals
Y = fft(shortData1);
P2 = abs(Y/fftSize);
P1 = P2(1:fftSize/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(fftSize/2))/fftSize;
[dummy,index]=max(P1);
if(f(index)<1000)
    Y = fft(longData1);
    P2 = abs(Y/fftSize);
    P1 = P2(1:fftSize/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = (fs/16)*(0:(fftSize/2))/fftSize;
    [dummy,index]=max(P1);
    initialFrequency=f(index);
end
% [frequency,phase,corr]=frequencyPhaseSearch(longData1,fs/16,0,0.01);
phase=angle(Y(index));
frequency=initialFrequency;
xPred=cos(2*pi*frequency*t+phase);
weight=P1(index);
sNew=s-weight*xPred;
% plot(sNew)
% plot(s)
% hold on
% plot(sNew)



shortData=sNew(7*fftSize+1:8*fftSize);
longData=sNew(1:16:end);

%taking fft of both signals
Y = fft(shortData);
P2 = abs(Y/fftSize);
P1 = P2(1:fftSize/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(fftSize/2))/fftSize;
[dummy,index]=max(P1);
if(f(index)<1000)
    Y = fft(longData);
    P2 = abs(Y/fftSize);
    P1 = P2(1:fftSize/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = (fs/16)*(0:(fftSize/2))/fftSize;
    [dummy,index]=max(P1);
    initialFrequency=f(index);
end

% [frequency,phase,corr]=frequencyPhaseSearch(longData,fs/16,0,0.01);
phase=angle(Y(index))
weight=P1(index)
frequency=initialFrequency;
xPred=cos(2*pi*frequency*t+phase);

sNew2=sNew-weight*xPred;
plot(sNew2)
shortData=sNew2(7*fftSize+1:8*fftSize);
longData=sNew2(1:16:end);
 plot(shortData)
