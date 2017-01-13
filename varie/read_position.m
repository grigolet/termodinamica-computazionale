load ../fccseconditerzi.txt
x0 = fccseconditerzi(:,1); %prendo la prima colonna
y0 = fccseconditerzi(:,2); %il ; sopprime l''output
z0 = fccseconditerzi(:,3);
numero_atomi = numel(x0); %calcolo numero elementi

% scatter3 per plottare il cristallo
% voglio sommare le x di tutti gli atomi
xsum = 0;
for i=1:numero_atomi
    xsum = xsum + x0(i);
end
% voglio trovare il massimo
xmax = -10000;
for i=1:numero_atomi
    if x0(i) > xmax
        xmax = x0(i);
    end
end
min_distanza = 10000;
r_cutoff = 3;
% dichiaro un vettore colonna di zeri grande quanto numero_atomi
%voglio trovare la distanza minimia tra una coppia di atomi dentro al 
%file
numero_vicini = zeros(numero_atomi, 1);
% matrice a due dimensioni in cui il primo indice indica l'atomo e il
% secondo indica il numero j-esimo dei suoi vicini
elenco_vicini = zeros(numero_atomi, numero_atomi);
for i=1:numero_atomi
    for j=i+1:numero_atomi
        distanza_x = (x0(i) - x0(j))^2;
        distanza_y = (y0(i) - y0(j))^2;
        distanza_z = (z0(i) - z0(j))^2;
        distanza_tot = sqrt(distanza_x + distanza_y + distanza_z);
        if distanza_tot < min_distanza
            min_distanza = distanza_tot;
        end
    end
end

%voglio fare la stessa cosa ma anzichè trovare la distanza minore
%del cutoff e incrementare il numero di vicini per quell'atomo
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

% devo calcolare l'interazione con epsilon 0.345 e sigma = 2.644
% creo la matrice delle energie:
phi = zeros(numero_atomi, numero_atomi);

% definisco epsiolon e sigma
epsilon = 0.345;
sigma = 2.644;

for i=1:numero_atomi
    
    % per ogni atomo prendo i suoi vicini
    for j=1:numero_vicini(i)
        
        % per ogni vicino devo ricavare l'atomo k-esimo
        k = elenco_vicini(i, j);
        
        % calcolo la distanza tra i e k
        distanza_x = (x0(i) - x0(k))^2;
        distanza_y = (y0(i) - y0(k))^2;
        distanza_z = (z0(i) - z0(k))^2;
        distanza_tot = sqrt(distanza_x + distanza_y + distanza_z);
        
        % calcolo l'energia tra atomo i e k
        phi(i, k) = 4*epsilon*((sigma/distanza_tot)^(12) - (sigma/distanza_tot)^6);
    end
end

% calcolo l'energia totale come un mezzo della somma
energia_totale = 1/2 * sum(sum(phi));

%% Lezione 9-11
% voglio scrivere su file due colonne: uno con l'atomo i-esimo e l'altro
% con il numero di vicini per quell'atomo
handle = fopen('vicini.dat', 'w');
for i=1:numero_atomi
    fprintf(handle, '%d %d\n', i, numero_vicini(i));
end
fclose(handle);
load 'vicini.dat';
xplot = vicini(:, 1);
yplot = vicini(:, 2);
scatter(xplot, yplot);
























