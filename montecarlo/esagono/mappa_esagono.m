function [iex, jex] = mappa_esagono(i, j)

    % (i,j) -> (iex, jex)
    % per ogni j ho che jex = sqrt(3)/2*j
    % se j è dispari iex = i
    % se j è parti   iex = i + 0.5

    j_pari = mod(j,2) == 0;
    jex = j * sqrt(3)/2;
    iex = i;
    iex(j_pari) = iex(j_pari) + 0.5;
    

end