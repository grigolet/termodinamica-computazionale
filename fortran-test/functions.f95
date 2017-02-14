MODULE functions
implicit none

contains
    SUBROUTINE riempi(siti, n_siti)
        implicit none

        integer, intent(out) :: siti(:,:)
        integer, intent(in) :: n_siti
        integer :: n_siti_riempiti = 0
        integer :: x_sito, y_sito
        integer :: L
        siti(:,:) = 0
        L = size(siti(:,1))

        ! riempi la matrice con un siti posti casualmente
        do while (n_siti_riempiti /= n_siti)
            x_sito = floor(rand()*real(L))
            y_sito = floor(rand()*real(L))
            if (siti(x_sito, y_sito) == 0) then
                n_siti_riempiti = n_siti_riempiti+1
                siti(x_sito, y_sito) = 1
            endif
        end do

    END SUBROUTINE riempi

    SUBROUTINE vicini(ivic, jvic, L)
        implicit none

        integer :: i, j 
        integer, intent(in) :: L
        integer, intent(out) :: ivic(4,L,L), jvic(4,L,L) 

        do j=1,L
            do i=1,L
                ivic(1, i, j) = i;
                jvic(1, i, j) = j-1;
                ivic(2, i, j) = i;
                jvic(2, i, j) = j+1;
                ivic(3, i, j) = i+1;
                jvic(3, i, j) = j;
                ivic(4, i, j) = i-1;
                jvic(4, i, j) = j;
                if (i == L) then
                    ivic(3, i, j) = 1;
                end if
                if (i == 1) then
                    ivic(4, i, j) = L;
                end if
                if (j == L) then
                    jvic(2, i, j) = 1;
                end if
                if (j == 1) then
                    jvic(1, i, j) = L;
                end if
            end do
        end do
    END SUBROUTINE vicini

    SUBROUTINE pickrandom(siti, L, full, x, y)

        integer, intent(in) :: L, full
        integer, intent(in) :: siti(L,L)
        integer, intent(out) :: x, y

        x = floor(rand()*L)
        y = floor(rand()*L)

        do while (siti(x,y) /= full)
            x = floor(rand()*L)
            y = floor(rand()*L)
        end do

    END SUBROUTINE pickrandom

    FUNCTION energia(ivic, jvic, siti, L) result (epot)

        integer, intent(in) :: L
        integer, intent(in) :: ivic(4,L,L), jvic(4,L,L), siti(L,L)
        real :: epot
        real :: einter = -0.2
        integer :: i,j,k
        epot = 0

        do j=1,L
            do i=1,L
                if (siti(i,j) == 1) then
                    do k=1,4
                        if (siti(jvic(k,i,j), ivic(k,i,j)) == 1) then
                            epot = epot + einter
                        end if
                    end do
                end if
            end do
        end do

        epot = epot/2

    END FUNCTION energia

END MODULE functions