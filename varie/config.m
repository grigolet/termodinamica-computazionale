function config
    global epsilon;
    global sigma;
    global r_cutoff;
    global r_prime ;
    global r_z;
    global step;
    global diff;
    global sum;
    global ee;
    global ff;
    global dd;
    global cc;
    global aa;
    global bb;

    % file con i parametri di configurazione
    epsilon = 0.345;
    sigma   = 2.644;
    r_cutoff = 4.5;
    r_prime  = 4.2;
    r_z = 5;
    step  = 0.06;

    % definisco le variabili
    diff = r_prime - r_cutoff;
    sum  = r_prime + r_cutoff;

    ee = 4*epsilon*((sigma/r_prime)^12 - (sigma/r_prime)^6);
    ff = 4*epsilon*(-12*(sigma)^12/r_prime^(13) + 6*sigma^6/r_prime^7);
    dd = ff/diff^2 - 2*ee/diff^3;
    cc = ff/(2*diff) - 3/2*dd*sum;
    aa = cc*r_cutoff^2 + 2*dd*r_cutoff^3;
    bb = -2*cc*r_cutoff - 3*dd*r_cutoff^2;

end

