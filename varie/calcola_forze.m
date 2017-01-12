function calcola_forze
    global numero_atomi numero_vicini elenco_vicini;
    global r_prime;
    global fx fy fz;
    global x0 y0 z0;
    global epsilon sigma;
    for i=1:numero_atomi
            for j=1:numero_vicini(i)
                k            = elenco_vicini(i, j);
                distanza_x   = (x0(i) - x0(k));
                distanza_y   = (y0(i) - y0(k));
                distanza_z   = (z0(i) - z0(k));
                distanza_tot = distanza_x^2 + distanza_y^2 + distanza_z^2;
                r_ik         = sqrt(distanza_tot);
                
                if r_ik <= r_prime
                   fx(i) = fx(i) + 24*epsilon*(sigma^6)*distanza_x ...
                               * ( 2*(sigma^6)/(r_ik^6) - 1)/(r_ik^8);
                   fy(i) = fy(i) + 24*epsilon*(sigma^6)*(distanza_y) ...
                               * ( 2*(sigma^6)/(r_ik^6) - 1)/(r_ik^8);
                   fz(i) = fz(i) + 24*epsilon*(sigma^6)*(distanza_z) ...
                               * ( 2*(sigma^6)/(r_ik^6) - 1)/(r_ik^8);
                else
                   fx(i) = fx(i) - bb*distanza_x/r_ik - 2*cc*distanza_x - 3*dd*r_ik*distanza_x;
                   fy(i) = fy(i) - bb*distanza_y/r_ik - 2*cc*distanza_y - 3*dd*r_ik*distanza_y;
                   fz(i) = fz(i) - bb*distanza_z/r_ik - 2*cc*distanza_z - 3*dd*r_ik*distanza_z;
                end
                    
            end
        end
end