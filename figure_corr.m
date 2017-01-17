subplot(3,1,1);
[acor,lag] = xcorr(TX(64, 1, 0, 0, 1000, 1), 270); 
plot(lag, acor);
subplot(3,1,2);
[acor,lag] = xcorr(TX(128, 1, 0, 0, 1000, 1), 270); 
plot(lag, acor);
subplot(3,1,3);
[acor,lag] = xcorr(TX(256, 1, 0, 0, 1000, 1), 270); 
plot(lag, acor);