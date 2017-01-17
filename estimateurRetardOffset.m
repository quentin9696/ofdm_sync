function [ L_est, offset_est ] = estimateurRetardOffset(data, N) 
    
    taille = length(data);
    nbTrames = floor(taille / (N + N/4));
    taille2 = nbTrames * N;
    gama = zeros(1,taille2);
    phi = zeros(1,taille2);
    taille_symbole = (N+N/4);
    data = [ data , zeros(1, N)];
    
    tab_data = zeros(nbTrames, taille_symbole+N);
    
    for i=1:nbTrames-1
        indice_p = (i-1)*taille_symbole + 1;
        indice_d = i*taille_symbole + N;

       tab_data(i,:) = data(indice_p : indice_d);
    end
    
    
    for k=0:(nbTrames-2)
        for u= 1:N
           for l=u:(u+(N/4)-1)
               gama(u + (k*N)) = gama(u + (k*N)) + tab_data(k+1, l) * conj(tab_data(k+1, l+N));%data(l+(k*N + k*(N/4)))*conj(data(l+N+(k*N + k*(N/4))));
               phi(u + (k*N)) = phi(u + (k*N)) + abs(tab_data(k+1,l))^2 + abs(tab_data(k+1, l+N))^2;  %abs(data(l+(k*N + k*(N/4))))^2 + abs(data(l+N+(k*N + k*(N/4))))^2;
           end
               phi(u + (k*N)) = phi(u + (k*N)) * 0.5;
        end
    end
    
    correlationFull =(abs(gama) - phi);
    
    correlation = zeros(1, N);
    
    %plot(correlationFull, 'r');
    
    for k=0:14% DBG nbTrames-1
        for i=1:N
            correlation(i) = correlation(i) + correlationFull(i+k*N);
        end
    end
    
    [M, I] = max(correlation);  
%     figure
%     grid on;
%     hold on;
%     plot(correlation/nbTrames, 'r');
%     plot(correlationFull, 'b');
    L_est = I-1;
    
    offset = zeros(1,nbTrames-1);
    
    for i=1:nbTrames-1
       offset(i) = (-1/(2*pi))*angle(gama(I + ((i -1) * N)));
    end
    
    offset_est = mean(offset(1:15));%DBG
    %Offset_est = (-1/(2*pi))*arg(gama(I))
end