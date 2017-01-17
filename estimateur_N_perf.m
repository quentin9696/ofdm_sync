clear all;
N_vec=[64 128 256 512 1024];
snr_vec=[-20:0.5:10];
proba = zeros(1, length(snr_vec));

n_MC = 300;%
for N=N_vec
    i=1;
    for snr = snr_vec
        nb_bon = 0;
        for seed=1:n_MC
           L = randi(N) - 1; 
           offset = rand(1,1) - 0.5;
           N_est = est_N(TX(N, seed, offset, L, snr, 10));
           if N_est == N
               nb_bon = nb_bon + 1;
           end
        end

        proba(i) = nb_bon/n_MC;

        i= i + 1;
    end
    
    figure(2)
    hold on;
    plot(snr_vec, proba, 'DisplayName', sprintf('N = %d', N));
end

legend('show');
grid on;

