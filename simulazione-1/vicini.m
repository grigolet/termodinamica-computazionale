function [numero_vicini, elenco_vicini, epot] = vicini(x, y, z, ...
        numero_atomi, r_cutoff, r_prime, epsilon, sigma)
    % dichiaro la grandezza dei vettori per motivi di performance
    numero_vicini = zeros(numero_atomi);
    elenco_vicini = zeros(numero_atomi, numero_atomi);
    epot = 0;
    for i=1:numero_atomi
        for j=1:numero_atomi
            if i ~= j
                distanza_x = (x(i) - x(j))^2;
                distanza_y = (y(i) - y(j))^2; 
                distanza_z = (z(i) - z(j))^2;
                distanza_tot = sqrt(distanza_x + distanza_y + distanza_z);
                if distanza_tot < r_cutoff
                    numero_vicini(i) = numero_vicini(i) + 1;
                    elenco_vicini(i, numero_vicini(i)) = j;
                    % calcolo l'energia tra atomo i e k
                    if distanza_tot <= r_prime
                        epot = epot + 4*epsilon*((sigma/distanza_tot)^(12) ... 
                                    - (sigma/distanza_tot)^6);

                    else
                        [epot_istantanea, ~] = polinomial(distanza_tot, r_prime, r_cutoff, sigma, epsilon);
                        epot = epot + epot_istantanea;
                    end
                end
                
            end          
        end

    end
    epot = epot * 0.5;
end