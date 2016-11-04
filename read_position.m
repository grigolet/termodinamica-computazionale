load fccseconditerzi.txt
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
            end
        end
    end
end     
