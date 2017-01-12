function [vx, vy, vz, Ex, Ey, Ez, temperatura_efficace, ...
    temperatura_efficace_shift, temperatura_efficace_changed] = ... 
    velocita_iniziali (numero_atomi, temperatura, massa, seed)
    % generazione dal seed
    rng(seed);

    % definizione costante e vettori velocità
    const = sqrt(3*temperatura/(11603*massa));

    vx = zeros(numero_atomi, 1);
    vy = zeros(numero_atomi, 1);
    vz = zeros(numero_atomi, 1);
    
    vx_2 = zeros(numero_atomi, 1);
    vy_2 = zeros(numero_atomi, 1);
    vz_2 = zeros(numero_atomi, 1);

    % calcolo velocità e velocità quadratiche con numeri casuali
    for i=1:numero_atomi
        vx(i) = 2*const*rand - const;
        vy(i) = 2*const*rand - const;
        vz(i) = 2*const*rand - const;
        
        vx_2(i) = vx(i)^2; 
        vy_2(i) = vy(i)^2; 
        vz_2(i) = vz(i)^2; 
    end
    
    % calcolo valori medi della velocità
    vx_medio = mean(vx);
    vy_medio = mean(vy);
    vz_medio = mean(vz);

    % calcolo velocita quadratica media
    vx_medio_2 = mean(vx_2);
    vy_medio_2 = mean(vy_2);
    vz_medio_2 = mean(vz_2);
    
    % calcolo energia cinetica    
    Ex = 1/2*massa*vx_medio_2;
    Ey = 1/2*massa*vy_medio_2;
    Ez = 1/2*massa*vz_medio_2;

    % calcolo temperatura efficace
    temperatura_efficace = 1/3 * massa * 11603 * (vx_medio_2 + ...
                           vy_medio_2 + vz_medio_2);
    
    % ora cambio le velocità:    
    for i=1:numero_atomi
        vx(i) = vx(i) - vx_medio;
        vy(i) = vy(i) - vy_medio;
        vz(i) = vz(i) - vz_medio;
        
        vx_2(i) = vx(i)^2; 
        vy_2(i) = vy(i)^2; 
        vz_2(i) = vz(i)^2; 
    end

    % di nuovo la velocità media
    vx_medio = mean(vx);
    vy_medio = mean(vy);
    vz_medio = mean(vz);

    % calcolo velocita quadratica media
    vx_medio_2 = mean(vx_2);
    vy_medio_2 = mean(vy_2);
    vz_medio_2 = mean(vz_2);
    
    % ricalcolo la nuova temperatura efficace shiftata
    temperatura_efficace_shift = 1/3 * massa * 11603 * (vx_medio_2 + ...
                           vy_medio_2 + vz_medio_2);

                       
    % ricalcolo le velocità per un fattore sqrt(temp/teff_shift)     
    for i=1:numero_atomi
        vx(i) = vx(i) * sqrt(temperatura/temperatura_efficace_shift);
        vy(i) = vy(i) * sqrt(temperatura/temperatura_efficace_shift);
        vz(i) = vz(i) * sqrt(temperatura/temperatura_efficace_shift);
        
        vx_2(i) = vx(i)^2; 
        vy_2(i) = vy(i)^2; 
        vz_2(i) = vz(i)^2; 
    end
    
    % calcolo velocita quadratica media
    vx_medio_2 = mean(vx_2);
    vy_medio_2 = mean(vy_2);
    vz_medio_2 = mean(vz_2);

    temperatura_efficace_changed = 1/3 * massa * 11603 * (vx_medio_2 + ...
                           vy_medio_2 + vz_medio_2);

end
