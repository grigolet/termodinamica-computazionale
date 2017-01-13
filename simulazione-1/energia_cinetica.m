function [E_k, T_istantanea] = energia_cinetica(vx, vy, vz, numero_atomi, mass)

    vx2_tot = 0;
    vy2_tot = 0;
    vz2_tot  = 0;

    for i=1:numero_atomi
        vx2_tot = vx2_tot + vx(i)^2;
        vy2_tot = vy2_tot + vy(i)^2;
        vz2_tot = vz2_tot + vz(i)^2;
    end

    E_k = mass*(vx2_tot + vy2_tot + vz2_tot)/2;
    T_istantanea = 1/3 * 11603 * E_k;

end
