clear all 
close all;

figure;
%%%%%%%%%%%%% Paramètres %%%%%%%%%%%%%%
snr_vec=[-10:1:10];%[-10:1:10];%6;%[ 4 6];
obs_vec=[1 15 30 50]%[1 10];%[1 15 30 50];%[16 30 50 60];%[30]
N=128;
nbr_obs = 10;%10;%500;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k=1;
erreur_quad_L = zeros(length(obs_vec), length(snr_vec));
erreur_quad_offset = zeros(length(obs_vec), length(snr_vec));
for obs=obs_vec
    i=1;
    for snr=snr_vec
        L_est_tab = zeros(1,nbr_obs);
        Off_est_tab = zeros(1, nbr_obs);
       for seed=1:nbr_obs
          L_reel = randi(N) - 1; 
          offset_reel = rand(1,1) - 0.5;
          %L_reel = 24;
          %offset_reel = 0.2;
          [L, off] = estimateurRetardOffset2(TX(N,seed, offset_reel, L_reel, snr, obs),N);
          L_est_tab(seed) = (L-L_reel)^2 /N^2 ;
          Off_est_tab(seed) = (off-offset_reel)^2;%/offset_reel^2;
       end

        erreur_quad_L(k,i) = mean(L_est_tab);
        erreur_quad_offset(k,i) = mean(Off_est_tab);

        i= i+1 ;
    end
    erreur_quad_L_vec = erreur_quad_L(k,:);
    erreur_quad_off_vec = erreur_quad_offset(k,:);
    figure(1);
    semilogy(snr_vec, erreur_quad_L_vec, 'DisplayName', sprintf('Obs = %d', obs));
    hold on;
    figure(2);
    semilogy(snr_vec, erreur_quad_off_vec, 'DisplayName', sprintf('Obs = %d', obs));
    hold on;
    k=k+1;
end
figure(1);
grid on;
legend('show');
figure(2);
grid on;
legend('show');
% figure;
% semilogy(snr_vec, erreur_quad_offset);
% legend(sprintf('Obs = %d', obs_vec(1)), sprintf('Obs = %d', obs_vec(2)),sprintf('Obs = %d', obs_vec(3)))
% hold on;
% grid on;