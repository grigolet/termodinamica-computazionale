function [e_medio, delta_e, t_media, sigma] = analisi_data(temperature)
    file_name = char(strcat(strrep(string('output/') + string(round(temperature,2)),'.',''),'.txt'));
    
    data    = load(file_name);
    e_tot   = data(:,1);
    temp    = data(:,2);
    t_media = mean(temp);
    delta_e = std(e_tot);
    e_medio = mean(e_tot);
    sigma   = delta_e/e_medio;
end