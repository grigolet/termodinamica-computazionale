% prendo la z dell'atomo 16 e la sposto di 5
% fisso r_cutoff = 3
% calcolo la distanza

r_z = 5;
step = 0.06;

% carico lo script con le definizioni del polinomio
load('polinomial', '-mat');

nome_file =strcat('z_vs_epot.dat');
handle = fopen(nome_file, 'w');

% carico i dati
load fccseconditerzi.txt
x0 = fccseconditerzi(:,1); %prendo la prima colonna
y0 = fccseconditerzi(:,2); %il ; sopprime l''output
z0 = fccseconditerzi(:,3);

% calcolo e istanzioni vettori
numero_atomi = numel(x0); %calcolo numero elementi
numero_vicini = zeros(numero_atomi, 1);
elenco_vicini = zeros(numero_atomi, numero_atomi);


z0(16) = z0(16) + r_z;

for k=1:100
    %voglio fare la stessa cosa ma anzichè trovare la distanza minore
    %del cutoff e incrementare il numero di vicini per quell'atomo
    epot = 0;
    epot_non_corretto = 0;
    for i=1:numero_atomi
        for j=1:numero_atomi
            if i ~= j
                distanza_x = (x0(i) - x0(j))^2;
                distanza_y = (y0(i) - y0(j))^2;
                distanza_z = (z0(i) - z0(j))^2;
                distanza_tot = sqrt(distanza_x + distanza_y + distanza_z);
                if distanza_tot < r_cutoff
                    %numero_vicini(i) = numero_vicini(i) + 1;
                    %elenco_vicini(i, numero_vicini(i)) = j;
                    epot_non_corretto = epot_non_corretto + ...
                        2*epsilon*((sigma/distanza_tot)^(12) - (sigma/distanza_tot)^6);

                    
                    if distanza_tot <= r_prime
                        epot = epot + 2*epsilon*((sigma/distanza_tot)^(12) ... 
                                    - (sigma/distanza_tot)^6);

                    elseif distanza_tot > r_prime && distanza_tot < r_cutoff
                        epot = epot + (aa + bb*distanza_tot + cc*distanza_tot^2 ...
                                    + dd*distanza_tot^3)/2;
                    end
                end
                
            end          
        end 
    end

    % finito di contare tutti gli atomi salvo il raggio di cutoff e
    % l'energia potenziale
    fprintf(handle, '%f %f %f\n', z0(16), epot, epot_non_corretto);

    % decremento z0(16)
    z0(16) = z0(16) - step;
end

fclose(handle);

% plot dei grafici
% colonna 1: z
% colonna 2: epot
% colonna 3: epot non raccordata
epot_data = load('z_vs_epot.dat');
plot(epot_data(:,1), epot_data(:, 2));
hold on 
plot(epot_data(:,1), epot_data(:,3));
hold off