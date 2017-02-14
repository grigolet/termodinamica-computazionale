function [ivic, jvic] = vicini(L)

    ivic = zeros(6,L,L);
    jvic = zeros(6,L,L);

    for i=1:L
        for j=1:L
            if mod(j,2) == 0
                % calcolo vicini
                ivic(1, i, j) = i-1;
                jvic(1, i, j) = j;
                ivic(2, i, j) = i+1;
                jvic(2, i, j) = j;
                ivic(3, i, j) = i-1;
                jvic(3, i, j) = j+1;
                ivic(4, i, j) = i;
                jvic(4, i, j) = j+1;
                ivic(5, i, j) = i-1;
                jvic(5, i, j) = j-1;
                ivic(6, i, j) = i;
                jvic(6, i, j) = j-1;
                
            else 
                % calcolo
                ivic(1, i, j) = i-1;
                jvic(1, i, j) = j;
                ivic(2, i, j) = i+1;
                jvic(2, i, j) = j;
                ivic(3, i, j) = i;
                jvic(3, i, j) = j+1;
                ivic(4, i, j) = i+1;
                jvic(4, i, j) = j+1;
                ivic(5, i, j) = i;
                jvic(5, i, j) = j-1;
                ivic(6, i, j) = i+1;
                jvic(6, i, j) = j-1;

            end               
            
            % pbc 
            if i == 1
                ivic(1, i, j) = L;
                % jvic(1, i, j) = j;
                if mod(j,2) == 0
                    ivic(3, i, j) = L;
                    ivic(5, i, j) = L;
                    % jvic(3, i, j) = j+1;
                    % jvic(5, i, j) = j-1; 
                end
            end
            if i == L
                ivic(2, i, j) = 1;
                % jvic(2, i, j) = j;
                if mod(j,2) ~= 0
                    ivic(4, i, j) = 1;
                    % jvic(4, i, j) = j+1;
                    ivic(6, i, j) = 1;
                    % jvic(6, i, j) = j-1; 
                end
            end
            if j == L
                % ivic(3, i, j) = i;
                jvic(3, i, j) = 1;
                % ivic(4, i, j) = i+1;
                jvic(4, i, j) = 1;
            end
            if j == 1
                % ivic(5, i, j) = i-1;
                jvic(5, i, j) = L;
                % ivic(6, i, j) = i;
                jvic(6, i, j) = L;
            end
        end
    end
end