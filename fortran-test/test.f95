PROGRAM test
use functions
implicit none

    ! definizione costanti
    integer, parameter :: L = 20
    integer, parameter :: n_siti = 25
    integer, parameter :: n_interazioni = 100000
    integer, parameter :: seed = 16324478
    real, parameter :: T = 10.0
    real, parameter :: k = 1/11603.
    integer :: siti(L, L), x_full, y_full, x_null, y_null, i
    integer :: ivic(4,L,L), jvic(4,L,L)
    real :: epot, eforse, deltaE, prob, epot_array(n_interazioni)

    call srand(seed)
    ! configurazione iniziale
    call riempi(siti, n_siti)
    call vicini(ivic, jvic, L)
    epot = energia(ivic, jvic, siti, L)

    do i=1,n_interazioni
        ! prendo gli indici casualmente
       call pickrandom(siti,L,1,x_full,y_full)
       call pickrandom(siti,L,0,x_null,y_null)

       ! gli scambio
       siti(x_full, y_full) = 0
       siti(x_null, y_null) = 1

       ! ricalcolo i vicini e l'energia
       call vicini(ivic,jvic,L)
       eforse = energia(ivic,jvic,siti,L)
       deltaE = eforse-epot
       prob = exp(-deltaE/(k*T))

       ! genero un numero casuale e controllo
        if (rand() <= prob) then
            epot = eforse
        else
            siti(x_full, y_full) = 1
            siti(x_null, y_null) = 0
        end if

        epot_array(i) = epot
    end do

    ! scrittura su file
    open(21,form="unformatted",file="results.bin",status="replace",access="stream")
    write(21) epot_array
    close(21)

END PROGRAM test
