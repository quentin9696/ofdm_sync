function [ seq_bin_RX ] = RX( data, L, offset, N)
%RX Summary of this function goes here
%   Detailed explanation goes here
    taille = (N + N/4);
    nbTrame = length(data)/taille ;
    
    tab_data = zeros(nbTrame, taille);
    
    for i=1:nbTrame
        indice_p = (i-1)*taille + 1;
        indice_d = i*taille;

       tab_data(i,:) = data(indice_p : indice_d);
    end
    
    display(tab_data);
    display(data);
end

