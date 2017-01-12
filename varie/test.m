% Creo un programma che dato il raggio minimo e il raggio massimo di cut
% off e uno step su cui eseguo
r_min_cutoff = 2;
r_max_cutoff = 5;
step = 0.2;

% definisco epsiolon e sigma
epsilon = 0.345;
sigma = 2.644;

% creo un vettore 
r_cutoff = [r_min_cutoff:step:r_max_cutoff];


load fccseconditerzi.txt
x0 = fccseconditerzi(:,1); %prendo la prima colonna
y0 = fccseconditerzi(:,2); %il ; sopprime l''output
z0 = fccseconditerzi(:,3);

numero_atomi = numel(x0); %calcolo numero elementi


numero_vicini = zeros(numero_atomi, 1);
elenco_vicini = zeros(numero_atomi, numero_atomi);

for numero_raggio=1:numel(r_cutoff)
    %voglio fare la stessa cosa ma anzichè trovare la distanza minore
    %del cutoff e incrementare il numero di vicini per quell'atomo
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
                end
            end
        end
    end

    nome_file =strcat('vicini', string(r_cutoff(numero_raggio)), '.dat');
    handle = fopen(nome_file, 'w');
    for i=1:numero_atomi
        fprintf(handle, '%d %d\n', i, numero_vicini(i));
    end
    fclose(handle);

end

hold on
% altro ciclo per sport in cui leggo tutti i file e li plottoo
for numero_raggio=1:numel(r_cutoff)
    % devo usare importdata perchè così posso decidere a che array
    % assegnare il contenuto del file. load non va bene
    nome_file = 'vicini' + string(r_cutoff(numero_raggio)) + '.dat';
    % le {} indicando il contenuto della cella in quella posizione. 
    % Le () restituiscono una cella con i dati contenuti negli indici
    % specificati
    data = load(char(nome_file));
    xplot = data(:, 1);
    yplot = data(:, 2);
    scatter(xplot, yplot);
end
hold off


