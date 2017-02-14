function [x, y, z, numero_atomi] = leggi_file(file_name)
    data = load(file_name);
    x = data(:,1); %prendo la prima colonna
    y = data(:,2); %il ; sopprime l''output
    z = data(:,3);
    numero_atomi = numel(x);
end 