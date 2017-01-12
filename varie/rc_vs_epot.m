% script per visualizzare un grafico dell'energia potenziale al variare 
% del raggio di cut off
% devo leggere nei file dei vicini il raggio e i vari dati sugli atomi
% con i vicini.

% parametri di configurazione
r_min_cutoff = 2;
r_max_cutoff = 25;
step = 0.1;
epsilon = 0.345;
sigma = 2.644;
step_r_prime = 0.3;

% creo un vettore 
r_cutoff = [r_min_cutoff:step:r_max_cutoff];
r_prime = r_cutoff - step_r_prime;

% carico i dati
load fccseconditerzi.txt
x0 = fccseconditerzi(:,1); %prendo la prima colonna
y0 = fccseconditerzi(:,2); %il ; sopprime l''output
z0 = fccseconditerzi(:,3);

% calcolo e istanzioni vettori
numero_atomi = numel(x0); %calcolo numero elementi
numero_vicini = zeros(numero_atomi, 1);
elenco_vicini = zeros(numero_atomi, numero_atomi);

nome_file =strcat('rc_vs_epot.dat');
handle = fopen(nome_file, 'w');

for numero_raggio=1:numel(r_cutoff)
    %voglio fare la stessa cosa ma anzichè trovare la distanza minore
    %del cutoff e incrementare il numero di vicini per quell'atomo
    epot = 0;
    for i=1:numero_atomi
        for j=1:numero_atomi
            if i ~= j
                distanza_x = (x0(i) - x0(j))^2;
                distanza_y = (y0(i) - y0(j))^2;
                distanza_z = (z0(i) - z0(j))^2;
                distanza_tot = sqrt(distanza_x + distanza_y + distanza_z);
                if distanza_tot < r_cutoff(numero_raggio)
                    numero_vicini(i) = numero_vicini(i) + 1;
                    elenco_vicini(i, numero_vicini(i)) = j;
                    % calcolo l'energia tra atomo i e k
                    epot = epot + 2*epsilon*((sigma/distanza_tot)^(12) - (sigma/distanza_tot)^6);
                end
            end
        end
    end

    % finito di contare tutti gli atomi salvo il raggio di cutoff e
    % l'energia potenziale
    fprintf(handle, '%f %f\n', r_cutoff(numero_raggio), epot);
end

fclose(handle);