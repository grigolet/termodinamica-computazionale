% definizione costanti
L = 20;
n_siti = 25;
T = 100;
n_interazioni = 1000000;
plot_step = round(linspace(0,n_interazioni,50)); % voglio stampare al più 50 immagini
k = 1/11603.;
seed = 12163278;
rng(seed);

% configurazione iniziale
siti = riempi(L, n_siti);
[ivic, jvic] = vicini(L);
epot = energia(ivic, jvic, siti, L);
epot_array = zeros(n_interazioni, 1);

% simulazione
for i=1:n_interazioni
    
    % provo a fare una "mossa"
    % per farlo, prendo gli indici
    [x_notnull, y_notnull] = pickrandom(siti, L, 1);
    [x_null, y_null] = pickrandom(siti, L, 0);
    
    % scambio i posti
    siti(x_notnull, y_notnull) = 0;
    siti(x_null, y_null) = 1;
    
    % ricalcolo i vicini e l'energia
    [ivic, jvic] = vicini(L);
    eforse = energia(ivic, jvic, siti, L);
    
    deltaE = eforse - epot;
    prob = exp(-deltaE/(k*T));
    
    %genero un numero casuale e controllo 
    if rand() <= prob
        epot = eforse;
    else 
        siti(x_notnull, y_notnull) = 1;
        siti(x_null, y_null) = 0;
    end
    epot_array(i) = epot;
    
    % parte di plot
    % prendo tutti gli indici non nulli
    [x_nn, y_nn] = find(siti);
    % prendo tutti gli indici con valore nullo
    [x_null, y_null] = find(siti==0);
    if ismember(i,plot_step)
        clf
        hold on
            [x_nn_hex, y_nn_hex] = mappa_esagono(x_nn, y_nn);
            [x_null_hex, y_null_hex] = mappa_esagono(x_null, y_null);
            scatter(x_nn_hex, y_nn_hex, 'filled');
            scatter(x_null_hex, y_null_hex);
        hold off
        drawnow
    end
end

%     % prendo tutti gli indici non nulli
%     [x_nn, y_nn] = find(siti);
%     % prendo tutti gli indici con valore nullo
%     [x_null, y_null] = find(siti==0);
%     clf
%     hold on
%         scatter(x_nn, y_nn, 'filled');
%         scatter(x_null, y_null);
%     hold off




