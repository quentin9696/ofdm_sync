function [ N_est ] = est_N( data )
%EST_N Summary of this function goes here
%   Detailed explanation goes here
    
[acor,lag] = xcorr(data, 1030, 'unbiased');
acor=abs(acor);
[M, I] = max([acor(64 + 1031) , acor(128 + 1031) , acor(256 + 1031), acor(512 + 1031), acor(1024 + 1031)]);

N_est = 2^(I+5);

end

