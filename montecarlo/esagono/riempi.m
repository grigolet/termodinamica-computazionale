function [siti] = riempi(L, n_siti)

    
    siti = zeros(L, L);
    n_siti_riempiti = 0;
    while n_siti_riempiti ~= n_siti
       x_sito = randi(L);
       y_sito = randi(L);
       if (siti(x_sito, y_sito) ~= 1)
           n_siti_riempiti = n_siti_riempiti + 1;
           siti(x_sito, y_sito) = 1;
       end
       
    end

end