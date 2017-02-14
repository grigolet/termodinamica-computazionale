function epot = energia(ivic, jvic, siti, L)

    epot = 0;
    einter = -0.2;

    for i=1:L
        for j=1:L
            if siti(i, j) == 1
               for k=1:6
                    if siti(jvic(k,i,j), ivic(k,i,j)) == 1
                        epot = epot + einter;
                    end
               end
            end
        end
    end
    
    epot = epot / 2;
end