% in questo script voglio fare le seguenti cose:
% 1. definire un vettore di temperature a cui voglio fare le simulazioni.
% per ora sono [300, 600, 800]
% 2. Per ogni temperatura eseguire una simulazione 
% 3. Leggere i dati scritti su file dalla simulazione
% 4. Usare i dati letti per calcolare deltaE/E
% 5. Se il deltaE/E > 0.00001 diminuisco il timestep di 2e-15
% 6. Se deltaE/E <= 0.000005 aumento il timestep di 1e-15
% 7. Calcolo la t_media