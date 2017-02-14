% in questo script voglio fare le seguenti cose:
% 1. definire un vettore di temperature e un delta_t a cui voglio fare le simulazioni.
% per ora sono [300, 600, 800]
% 2. Per ogni temperatura eseguire una simulazione 
% 3. Leggere i dati scritti su file dalla simulazione
% 4. Usare i dati letti per calcolare deltaE/E
% 5. Calcolo temperatura_media
% 6. Se il deltaE/E > 0.00001 diminuisco il timestep del 20%
% 7. Se deltaE/E <= 0.000005 aumento il timestep del 20%

% 8. Se (temperatura_media-temperatura_simulazione)/temperatura_simulazione
%    è > 0.05 alzo la temperatura di 10k. Se è < -0.05 abbasso di 5k
close all;
clearvars;
delete('log.txt');

% 1
simulazioni_temperature = 2*[300, 600, 800, 1500];

% 2
parfor i=1:length(simulazioni_temperature)
    % apro un file di log per vedere se tutto va bene
    [handle, message] = fopen('log.txt', 'a');
    if handle == -1
        error('Couldn''t write to log.txt: %s', message);
    end
    % definisco una variabile che mi dice quando posso smettere di iterare
    ok_energia = 0;
    ok_temperatura = 0;
    % parallelizzo il calcolo e lo metto in job così non mi si impalla
    % tutto
    t_simulazione = simulazioni_temperature(i);
    delta_t = 1e-15;
    
    % continuo a eseguire simulazioni finchè non ho trovato una temperatura
    % e un delta t soddisfacente. Questo si traduce in controllare l'errore
    % sull'energia e sulla temperatura.
    while ok_energia == 0 || ok_temperatura == 0

        main_no_global(t_simulazione, delta_t)
        % 3, 4, 5
        [e_medio, delta_e, t_media, sigma] = analisi_data(t_simulazione);
        fprintf(handle, strcat( ...
            'E medio       : %f\n' , ...
            't_media       : %f\n' , ...
            'ΔE            : %.10f\n' , ...
            'sigma         : %.10f\n'), ...
            e_medio, t_media, delta_e, abs(sigma));
        % 6, 7
        if ok_energia == 0
            
            fprintf(handle, 'Δt            : %f \n', delta_t);
            
            if abs(sigma) > 0.00001
                delta_t = delta_t*60/100;
                fprintf(handle, 'Δt troppo grande\n');
            elseif abs(sigma) < 0.000005
                delta_t = delta_t * 140/100;
                fprintf(handle, 'Δt troppo piccolo t\n');
            else
                ok_energia = 1;
                fprintf(handle, '-----------------------------\n');
                fprintf(handle, '|Trovato un Δt soddisfacente|\n');
                fprintf(handle, '-----------------------------\n');
            end
        end
        % 8
        if ok_temperatura == 0
            
            fprintf(handle, 'T simulazione : ' + string(t_simulazione) + '\n');            
            errore_temp = (2*t_media - t_simulazione)/t_simulazione; 
            
            if  errore_temp > 0.05
                t_simulazione = t_simulazione + 10;
                fprintf(handle, 'ΔT: %.4f troppo grande\n', errore_temp);
            elseif errore_temp <= -0.05
                t_simulazione = t_simulazione - 10;
                fprintf(handle, 'ΔT: %.4f troppo piccola\n', errore_temp);
            else
                ok_temperatura = 1;
                fprintf(handle, '-----------------------------------\n');
                fprintf(handle, '|Trovata temperatura soddisfacente|\n');
                fprintf(handle, '-----------------------------------\n');
            end
        end
    end

    fprintf(handle, 'Temperatura trovata: %f\n', t_simulazione);
    fprintf(handle, 'Delta t trovato: %f\n', delta_t);
    st = fclose(handle);
    if st ~= 0
        error( 'Error code from close: %d, file: log.txt', script);
    end
end