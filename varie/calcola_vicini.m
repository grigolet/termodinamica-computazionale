function calcola_vicini
    global numero_vicini numero_atomi 
    global elenco_vicini
    global x0 y0 z0
    global r_cutoff
    
    % creo le matrici con elenco e numero vicini
    for i=1:numero_atomi
        for j=1:numero_atomi
            if i ~= j
                distanza_x = (x0(i) - x0(j))^2;
                distanza_y = (y0(i) - y0(j))^2; 
                distanza_z = (z0(i) - z0(j))^2;
                distanza_tot = sqrt(distanza_x + distanza_y + distanza_z);
                if distanza_tot < r_cutoff
                    numero_vicini(i) = numero_vicini(i) + 1;
                    elenco_vicini(i, numero_vicini(i)) = j;
                end            
            end          
        end 
    end
end