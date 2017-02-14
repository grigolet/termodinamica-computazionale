function [x ,y] = pickrandom(siti, L, full)

    x = randi(L);
    y = randi(L);
    
    while (siti(x,y) ~= full)
        x = randi(L);
        y = randi(L);
    end

end