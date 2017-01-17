function [ L_est, offset_est ] = estimateurRetardOffset2(data, N) 
    
    taille = length(data);
    nbTrames = floor(taille / (N + N/4));
    gama = zeros(nbTrames,N);
    phi = zeros(nbTrames,N);
    taille_symbole = (N+N/4);
    
    data = [ data , zeros(1, N)];
    
    tab_data = zeros(nbTrames, taille_symbole+N);
    
    for i=1:nbTrames
        indice_p = (i-1)*taille_symbole + 1;
        indice_d = i*taille_symbole + N;
       tab_data(i,:) = data(indice_p : indice_d);
    end
    
   for i=1:nbTrames 
    for u=1:N
        for l=u:u+(N/4)-1
            gama(i,u) = gama(i,u) + (tab_data(i, l)*conj(tab_data(i, l+N)));
            phi(i, u) = phi(i,u) + abs(tab_data(i, l))^2 + abs(tab_data(i, l+N))^2;
        end
    end
   end
       
    correlationFull =(abs(gama) - phi);
    correlation_vec = 0;
    
    for i=1:nbTrames
       correlation_vec = [correlation_vec, correlationFull(i, :)];
    end
    
    correlation_vec = correlation_vec(2:end);
    
    if nbTrames > 1
        correlationFull(1:end -1, :);
    end
    
    correlation = sum(correlationFull);
    
%     plot(correlation_vec);
%     hold on;
%     plot(correlation);
    
    [M, I] = max(correlation);  
    L_est = I-1;
    
    
    offsetFull = (-1/(2*pi))*angle(gama(:, I));
    offset_est = mean(offsetFull); 
    
end