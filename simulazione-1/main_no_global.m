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


[x, y, z, numero_atomi] = leggi_file(file_name);
e_tot        = zeros(numero_atomi, 1);
e_k          = zeros(numero_atomi, 1);
t_istantanea = zeros(numero_atomi, 1);
[vx, vy, vz] = velocita_iniziali(numero_atomi, temperature, mass, seed);


[numero_vicini, elenco_vicini, energia_potenziale] = vicini(x, y, z, ...
       numero_atomi, r_cutoff, r_prime, epsilon, sigma);

% test per il calcolo delle velocità iniziali
[fx, fy, fz] = forzelj(epsilon, sigma, x, y, z, numero_vicini, ...
    elenco_vicini, numero_atomi, r_prime, r_cutoff);

for i=1:n_iterazioni
    for c=1:numero_atomi
        x(c) = x(c) + vx(c)*delta_t + 1/2*fx(c)/mass*delta_t^2;
        y(c) = y(c) + vy(c)*delta_t + 1/2*fy(c)/mass*delta_t^2;
        z(c) = z(c) + vz(c)*delta_t + 1/2*fz(c)/mass*delta_t^2;
    end

    fx_vecchia = fx;
    fy_vecchia = fy;
    fz_vecchia = fz;

    [numero_vicini, elenco_vicini, energia_potenziale] = vicini(x, y, z, ...
        numero_atomi, r_cutoff, r_prime, epsilon, sigma);
    
    [fx, fy, fz] = forzelj(epsilon, sigma, x, y, z, numero_vicini, ...
        elenco_vicini, numero_atomi, r_prime, r_cutoff);

    for k=1:numero_atomi
        vx(k) = vx(k) + 1/(2*mass)*(fx_vecchia(k) + fx(k))*delta_t;
        vy(k) = vy(k) + 1/(2*mass)*(fy_vecchia(k) + fy(k))*delta_t;
        vz(k) = vz(k) + 1/(2*mass)*(fz_vecchia(k) + fz(k))*delta_t;
    end

    [e_k, t_istantanea(i)] = energia_cinetica(vx, vy, vz, numero_atomi, mass);
    e_tot(i) = e_k + energia_potenziale;

end
