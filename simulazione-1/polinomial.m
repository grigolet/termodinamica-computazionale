function [pol, pol_derivative] = polinomial(x, r_prime, r_cutoff, sigma, epsilon)
    % definisco le variabili
    diff = r_prime - r_cutoff;
    sum  = r_prime + r_cutoff;

    ee = 4*epsilon*((sigma/r_prime)^12 - (sigma/r_prime)^6);
    ff = 4*epsilon*(-12*(sigma)^12/r_prime^(13) + 6*sigma^6/r_prime^7);
    dd = ff/diff^2 - 2*ee/diff^3;
    cc = ff/(2*diff) - 3/2*dd*sum;
    aa = cc*r_cutoff^2 + 2*dd*r_cutoff^3;
    bb = -2*cc*r_cutoff - 3*dd*r_cutoff^2;
    pol = aa + bb*x + cc*x^2 + dd*x^3;
    pol_derivative = bb + 2*cc*x + 3*dd*x^2;
end
