clear all;
close all;
delete('simulazione-gabbie.txt');

% parametri di configurazione
file_name    = '../fccseconditerzi.txt';
epsilon      = 0.345;
sigma        = 2.644;
r_cutoff     = 4.5;
r_prime      = 4.2;
r_z          = 5;
step         = 0.06;
temperature  = 1500;
mass         = 108*1.66e-27/16;
seed         = 16324478;
n_iterazioni = 1000;
delta_t      = 1e-15;
global n_call;
n_call =  0;

% inizializzazione matrici e vettori
[x, y, z, numero_atomi] = leggi_file(file_name);
e_tot        = zeros(n_iterazioni, 1);
e_k          = zeros(n_iterazioni, 1);
t_istantanea = zeros(n_iterazioni, 1);
[vx, vy, vz] = velocita_iniziali(numero_atomi, temperature, mass, seed);

% calcolo dei vicini
[numero_vicini, elenco_vicini, x_verlet, y_verlet, z_verlet] = vicini(x, y, z, ...
       numero_atomi, r_cutoff);

% calcolo delle forze
[fx, fy, fz] = forzelj(epsilon, sigma, x, y, z, numero_vicini, ...
    elenco_vicini, numero_atomi, r_prime, r_cutoff);

% apro il file per la scrittura
write_file = fopen('simulazione-gabbie.txt', 'a');

for i=1:n_iterazioni
    % inizializzo la distanza massima
    d_max = 0;
    
    % ricalcolo le nuove posizioni
    for c=1:numero_atomi
        x(c) = x(c) + vx(c)*delta_t + 1/2*fx(c)/mass*delta_t^2;
        y(c) = y(c) + vy(c)*delta_t + 1/2*fy(c)/mass*delta_t^2;
        z(c) = z(c) + vz(c)*delta_t + 1/2*fz(c)/mass*delta_t^2;
        distanza = sqrt((x(c)-x_verlet(c))^2 + (y(c)- y_verlet(c))^2 + (z(c)-z_verlet(c))^2);
        if distanza > d_max
            d_max = distanza;
        end
    end
    
    % controllo secondo le gabbie di Verlet
    if d_max >= 1/2*(0.3)
        % ricalcolo i vicini
        [numero_vicini, elenco_vicini, x_verlet, y_verlet, z_verlet] = vicini(x, y, z, ...
        numero_atomi, r_cutoff);
    end

    fx_vecchia = fx;
    fy_vecchia = fy;
    fz_vecchia = fz;    
    
    % ricalcolo le forze
    [fx, fy, fz, energia_potenziale] = forzelj(epsilon, sigma, x, y, z, numero_vicini, ...
        elenco_vicini, numero_atomi, r_prime, r_cutoff);

    % calcolo le velocità
    for k=1:numero_atomi
        vx(k) = vx(k) + 1/(2*mass)*(fx_vecchia(k) + fx(k))*delta_t;
        vy(k) = vy(k) + 1/(2*mass)*(fy_vecchia(k) + fy(k))*delta_t;
        vz(k) = vz(k) + 1/(2*mass)*(fz_vecchia(k) + fz(k))*delta_t;
    end

    % calcolo l'energia cinetica e la temperatura
    [e_k(i), t_istantanea(i)] = energia_cinetica(vx, vy, vz, numero_atomi, mass);
    % e_tot(i) = e_k(i) + energia_potenziale;
    fprintf(write_file, '%f %f %f\n', energia_potenziale, e_k(i), t_istantanea(i));

end

fclose(write_file);
