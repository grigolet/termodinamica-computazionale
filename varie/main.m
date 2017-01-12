global x0 y0 z0 numero_atomi
global numero_vicini elenco_vicini
global fx fy fz
% dati in lettura
load fccseconditerzi.txt
x0 = fccseconditerzi(:,1); %prendo la prima colonna
y0 = fccseconditerzi(:,2); %il ; sopprime l''output
z0 = fccseconditerzi(:,3);
numero_atomi = numel(x0); %calcolo numero elementi

% carico le variabili
config;

% creo il file da salvare
nome_file = strcat('z_vs_fz.dat');
handle = fopen(nome_file, 'w');

for c=1:100
    % calcolo la matrice dei vicini
    numero_vicini = zeros(numero_atomi, 1);
    elenco_vicini = zeros(numero_atomi, numero_atomi);
    
    calcola_vicini;
    
     % definisco e azzero i vettori delle forze
    fx = zeros(numero_atomi, 1);
    fy = zeros(numero_atomi, 1);
    fz = zeros(numero_atomi, 1);
    
    calcola_forze;
    
    % finito di contare tutti gli atomi salvo il raggio di cutoff e
    % l'energia potenziale
    fprintf(handle, '%f %f\n', z0(16), fz(16));

    % decremento z0(16)
    z0(16) = z0(16) - step;
    
end

fclose(handle);

