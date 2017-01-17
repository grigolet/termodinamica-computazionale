function [fx, fy, fz, epot] = forzelj(epsilon, sigma, x, y, z, numero_vicini, ...
        elenco_vicini, numero_atomi, r_prime, r_cutoff)
    
    % definisco le variabili
    diff = r_prime - r_cutoff;
    sum  = r_prime + r_cutoff;

    ee = 4*epsilon*((sigma/r_prime)^12 - (sigma/r_prime)^6);
    ff = 4*epsilon*(-12*(sigma)^12/r_prime^(13) + 6*sigma^6/r_prime^7);
    dd = ff/diff^2 - 2*ee/diff^3;
    cc = ff/(2*diff) - 3/2*dd*sum;
    aa = cc*r_cutoff^2 + 2*dd*r_cutoff^3;
    bb = -2*cc*r_cutoff - 3*dd*r_cutoff^2;
    % pol = aa + bb*x + cc*x^2 + dd*x^3;
    % pol_derivative = bb + 2*cc*x + 3*dd*x^2;
    epot = 0;

    % definisco i vettori delle forze
    fx = zeros(numero_atomi, 1);
    fy = zeros(numero_atomi, 1);
    fz = zeros(numero_atomi, 1);

    for i=1:numero_atomi
        for j=1:numero_vicini(i)
            k            = elenco_vicini(i, j);
            distanza_x   = (x(i) - x(k));
            distanza_y   = (y(i) - y(k));
            distanza_z   = (z(i) - z(k));
            distanza_tot = distanza_x^2 + distanza_y^2 + distanza_z^2;
            r_ik         = sqrt(distanza_tot);
            
            if r_ik <= r_prime
               fx(i) = fx(i) + 24*epsilon*(sigma^6)*distanza_x ...
                           * ( 2*(sigma^6)/(r_ik^6) - 1)/(r_ik^8);
               fy(i) = fy(i) + 24*epsilon*(sigma^6)*(distanza_y) ...
                           * ( 2*(sigma^6)/(r_ik^6) - 1)/(r_ik^8);
               fz(i) = fz(i) + 24*epsilon*(sigma^6)*(distanza_z) ...
                           * ( 2*(sigma^6)/(r_ik^6) - 1)/(r_ik^8);
                epot = epot + 4*epsilon*((sigma/distanza_tot)^(12) ... 
                            - (sigma/distanza_tot)^6);


            elseif r_ik < r_cutoff
                fx(i) = fx(i) - bb*distanza_x/r_ik - 2*cc*distanza_x - 3*dd*r_ik*distanza_x;
                fy(i) = fy(i) - bb*distanza_y/r_ik - 2*cc*distanza_y - 3*dd*r_ik*distanza_y;
                fz(i) = fz(i) - bb*distanza_z/r_ik - 2*cc*distanza_z - 3*dd*r_ik*distanza_z;
                [epot_istantanea, ~] = polinomial(r_ik, r_prime, r_cutoff, sigma, epsilon);
                epot = epot + epot_istantanea;
            else
                fx(i) = fx(i) + 0;
                fy(i) = fy(i) + 0;
                fz(i) = fz(i) + 0;
                epot = epot + 0;
            end

        end
    end
    epot = epot/2;
end
