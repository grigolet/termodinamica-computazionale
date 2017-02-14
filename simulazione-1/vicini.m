function [numero_vicini, elenco_vicini, x_verlet, y_verlet, z_verlet] = ...
                vicini(x, y, z, numero_atomi, r_cutoff)
    % dichiaro la grandezza dei vettori per motivi di performance
    numero_vicini = zeros(numero_atomi);
    elenco_vicini = zeros(numero_atomi, numero_atomi);
    x_verlet = zeros(numero_atomi, 1);
    y_verlet = zeros(numero_atomi, 1);
    z_verlet = zeros(numero_atomi, 1);
    % global n_call;
    % n_call = n_call + 1;
    
    % raggio verlet
    r_verlet = r_cutoff + 0.3;    
    
    for i=1:numero_atomi
        % salvo le posizioni di verlet
        x_verlet(i) = x(i);
        y_verlet(i) = y(i);
        z_verlet(i) = z(i);
        for j=1:numero_atomi
            if i ~= j
                % uso le posizioni di verlet per motivi di performance
                distanza_x = (x_verlet(i) - x(j))^2;
                distanza_y = (y_verlet(i) - y(j))^2; 
                distanza_z = (z_verlet(i) - z(j))^2;
                distanza_tot = sqrt(distanza_x + distanza_y + distanza_z);
                if distanza_tot < r_verlet
                    numero_vicini(i) = numero_vicini(i) + 1;
                    elenco_vicini(i, numero_vicini(i)) = j;

                end
            end
        end
    end
end