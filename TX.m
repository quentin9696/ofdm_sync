function [ signal ] = TX( N, seed, offset, L, snr, nbTrame)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  generation d'un signal OFDM   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rng(seed);
signalOFDM = 0;

for i=1:nbTrame
    mod = 2*N; % On enleve les 2*PC 

    seqBin= round(rand(1,mod));  % Genere bits 

    seqQPSK = 0;

    % Binary to QPSK
    for i = 1:2:mod-1
        symbole = seqBin(i:i+1);
        symboleCode = 0;

        if symbole == [0 1]
            symboleCode = -1 + j;
        elseif symbole == [0 0]
            symboleCode = 1 + j;
        elseif symbole == [1 0]
            symboleCode = 1 - j;
        else
            symboleCode = -1 - j;
        end

        seqQPSK = [seqQPSK, symboleCode];

    end

         seqQPSK = seqQPSK(2:end); % On enleve le 1er terme qui vaut 0
         
         signaliFFT = ifft(seqQPSK); %iFFT
         
         %Prefix 
         signalUnitaire = [ signaliFFT((N - (N/4) + 1 ):end) , signaliFFT];
         
         signalOFDM = [signalOFDM, signalUnitaire];
         % On ajoute + 1 car 16 - 4 = 12 on commence à l'indice 13 !!
%          figure 
%          plot(abs(signalUnitaire));
         
end
     signalOFDM = signalOFDM(2:end);
     
     %Test de la valeur de la puissance moyenne d'un symble 
     %Pour le test : prendre un nombre N, voila la valeur retrourné par
     %l'algo et comparer avec la valeur théorique 2/N => It works !
     %val = mean(abs(signalOFDM).*abs(signalOFDM))
     
     %Ajout de l'offsef !
     for l = 1:length(signalOFDM) 
         signalOffset(l) = signalOFDM(l) * exp(j*2*pi*offset*(l-1)/N);
     end
     
     %Retard de L ech (N + N/4)

     signalRetard = [zeros(1,L), signalOffset];
     
    %Ajoute AWGN
    %On en deduit la variance par un savant calcul !
    %var = 2/(N*(10^(snr/10)));
    var = 0;
    for i=1:length(signalRetard)
        signalBruite(i) = signalRetard(i) + (randn(1,1) * sqrt(var) + 1j*(randn(1,1) * sqrt(var)) );  
    end
    
    signal = signalBruite;
%      figure
%      plot(abs(signal), 'g');
end

