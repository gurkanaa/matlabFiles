function initialFrequency=searchInit(data,fs)
%%%finds maximum frequency elemnt in fourier domain
L=length(data);
Y = fft(data);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(L/2))/L;
[dummy,index]=max(P1);
initialFrequency=f(index);