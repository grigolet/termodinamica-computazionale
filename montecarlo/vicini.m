function [ivic, jvic] = vicini(L)

    ivic = zeros(4,L,L);
    jvic = zeros(4,L,L);

    for i=1:L
        for j=1:L
            ivic(1, i, j) = i;
            jvic(1, i, j) = j-1;
            ivic(2, i, j) = i;
            jvic(2, i, j) = j+1;
            ivic(3, i, j) = i+1;
            jvic(3, i, j) = j;
            ivic(4, i, j) = i-1;
            jvic(4, i, j) = j;
            
            if i == L
                ivic(3, i, j) = 1;
            end
            if i == 1
                ivic(4, i, j) = L;
            end
            if j == L
                jvic(2, i, j) = 1;
            end
            if j == 1
                jvic(1, i, j) = L;
            end
        end
    end
end