% calcolo le forze lungo x, y, x

% carico lo script con le definizioni del polinomio
load('polinomial', '-mat');

% carico i dati
load fccseconditerzi.txt
x0 = fccseconditerzi(:,1); %prendo la prima colonna
y0 = fccseconditerzi(:,2); %il ; sopprime l''output
z0 = fccseconditerzi(:,3);

% calcolo e istanzioni vettori
numero_atomi = numel(x0); %calcolo numero elementi

% calcolo fz al variare della z di 16
r_z = 5;
step = 0.06;
% uso un altro ciclo per il numero di vicini
z0(16) = z0(16) + r_z;

% creo il file da salvare
nome_file =strcat('z_vs_fz.dat');
handle = fopen(nome_file, 'w');

for c=1:100

    % creo le matrici con elenco e numero vicini
    numero_vicini = zeros(numero_atomi, 1);
    elenco_vicini = zeros(numero_atomi, numero_atomi);

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

    % definisco i vettori delle forze
    fx = zeros(numero_atomi, 1);
    fy = zeros(numero_atomi, 1);
    fz = zeros(numero_atomi, 1);

    for i=1:numero_atomi
        for j=1:numero_vicini(i)
            k            = elenco_vicini(i, j);
            distanza_x   = (x0(i) - x0(k));
            distanza_y   = (y0(i) - y0(k));
            distanza_z   = (z0(i) - z0(k));
            distanza_tot = distanza_x^2 + distanza_y^2 + distanza_z^2;
            r_ik         = sqrt(distanza_tot);
            
            if r_ik <= r_prime
               fx(i) = fx(i) + 24*epsilon*(sigma^6)*distanza_x ...
                           * ( 2*(sigma^6)/(r_ik^6) - 1)/(r_ik^8);
               fy(i) = fy(i) + 24*epsilon*(sigma^6)*(distanza_y) ...
                           * ( 2*(sigma^6)/(r_ik^6) - 1)/(r_ik^8);
               fz(i) = fz(i) + 24*epsilon*(sigma^6)*(distanza_z) ...
                           * ( 2*(sigma^6)/(r_ik^6) - 1)/(r_ik^8);
            else
               fx(i) = fx(i) - bb*distanza_x/r_ik - 2*cc*distanza_x - 3*dd*r_ik*distanza_x;
               fy(i) = fy(i) - bb*distanza_y/r_ik - 2*cc*distanza_y - 3*dd*r_ik*distanza_y;
               fz(i) = fz(i) - bb*distanza_z/r_ik - 2*cc*distanza_z - 3*dd*r_ik*distanza_z;
            end
                
        end
    end

    % finito di contare tutti gli atomi salvo il raggio di cutoff e
    % l'energia potenziale
    fprintf(handle, '%f %f\n', z0(16), fz(16));

    % decremento z0(16)
    z0(16) = z0(16) - step;
end

fclose(handle);

