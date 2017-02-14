# 9 - 11

Bisogna scrivere su file due colonne: uno in cui c'è l'atomo i-esimo e l'altro
in cui c'è il numero di suoi vicini.

Usare:

```matlab
handle = fopen('file.dat', 'w')

```

# 18 - 11

* Usare `global` per i parametri di configurazione
* La sintassi `nome_file` chiama il file `nome_file.m` ed esegue il contenuto
* La sintassi per le funzioni di un file `nome_file` è:
```{matlab}
function nome_file_o_funzione
    global var1
    global var2
    % code stuff
end
```
# 2-12
Bisognerà generare dei numeri casuali in un intervallo di distribuzione di
probabilità rettangolare. Se l'intervallo è compreso in $-c, +c$ e ho un
generatore di numeri casuali tra 0 e 1, allora posso generare un numero casuale
compreso tra -c e +c usando
```
random_number = rand()*2*c -c
```
Vogliamo avere il modo di tenere traccia dei numeri casuali generati. Per tale
scopo utilizzeremo il seed utilizzato per generare i numeri.

## Da fare
* Function che calcola `v_x, v_y, v_z` utilizzando la distribuzione rettangolare.
 Alla fine calcolare $ <v_x^2> $
* Calcolare $ T_{efficace} $ da $ 3/2kT = 1/2 m(v_x^2 + v_y^2 + v_z^2) $
* Sottrare ad ogni velocità il valore del valor medio
Esempio di codice da usare:
```{matlab id:"iw7io87b"}
% argomenti globali
seed = 1241315213;
rng(seed);
global temperatura_iniziale = 1500; % in kelvin
global massa = 108*1.66e-27/16
% velocità iniziali
function [vx0, vy0, vz0] = v_init(numero_atomi);
    vx0 = zeros(numero_atomi, 1);
    % ... per le altre componenti
    vx0_totale = 0;
    cost = sqrt(3*temperatura/(11603*massa)) % costante c
    for i=1:numero_atomi
        % genera il numero casuale per le varie componenti e aggiungile
        vx0(i) = cost*(2*rand-i);
        vx0_totale = vx0_totale + vx0(i);
    end
end
```

# 6 - 12
Ultimo step è quello di integrare l'equazione di Newton al variare del tempo t.
Nel calcolare $ x(t) $ possiamo usare gli sviluppi in serie di Taylor. Più
termini tronchiamo e più errore commettiamo

Noi vogliamo uno schema in cui forniamo le posizioni iniziali del cristallo e
le velocità iniziali utilizzando la distribuzione costante/maxwelliana. Però
ad esempio, non sapremmo che accelerazioni iniziali usare. Un algoritmo che si
può utilizzare è quello di Verlet, che mette in relazioni le posizioni in due
tempi rispetto alla loro accelerazione. L'accelerazione la calcoliamo come F/m
ed F è ricavabile dal potenziale di Lennard-Jones. Il problema dell'algortimo è
che la velocità si può calcolare solo una volta note le posizioni e di
conseguenza gli errori commessi sono maggiori rispetto a quelli sulle posizioni.
siccome stiamo studiando un sistema a N particelle, in cui si devono conservare
N, V, E, stiamo trattando un **ensemble microcanonico**.

Si dimostra che esiste un algoritmo equivalente chiamato **velocity Verlet**.
L'algoritmo consiste nel fare evolvere sia la velocità che le posizioni  secondo
le relazioni nella slide.
Per esempio, se voglio calcolare $ x(T) $ scriverò:
$$
x(T) = x(0) + v(0)\Delta T + \frac{1}{2}a(0)\Delta T^2
$$
* $ x(0) $ le leggo dall'input
* $ v(0) $ uso la disitrubzione maxwelliana
* $ a(0) $ calcolo le forze e divido per la massa

Nel calcolare la velocità poi:
$$
v(t)  = v(0) + \frac{a(0) + a(\Delta T)}{2}\Delta T
$$
* $ a(\Delta T) $ è la forza relativa alle nuovi posizioni appena calcolate.

è suggerito di scrivere nel main
```{matlab}
call readinput;
call vicini;
call forze;
for imd=1:nmd
    for i=1:numero_atomi
        x(i) = x(i)*delta_t + 1/2*fx(i)/m*delta_t^2;
        % stesso per y e z
    end
    % mi calcolo le vecchie accelerazioni
    acc_vecchia_x = fx_vecchia/m
    % ora che ho calcolato le posizioni calcolo le velocità. Prima però
    % devo calcolare di nuovo le forze e i vicini
    call forze;
    call vicini;
    for i=1:numero_atomi
        vx(i) = vx(i) + 1/(2*mass)*(fx_vecchia(i) - fx(i))*delta_t
    end
end
```

Nell'ambito di un ensemble microcanonico usiamo il teorema di equipartizione
dell'energia per calcolare la temperatura a partire dall'energià cinetica.
Servirà una funzione per convertire energia cinetica in temperatura e viceversa.
La temperatura è una misura istantea:
$$
    K(t) = \frac{1}{2}\sum_i m_i v_i^2 \\
    K(t) = \frac{3N k_b  T(t)}{2}
$$

# 10-01
Bisogna trovare i time step ottimali per diverse T. Per temperatura si intende
la temperatura a *equilibrio raggiunto*. All'equilibirio la temperatura comunque
oscilla perchè l'ensemble è (N, V, E), quindi T non si conserva. Ciò significa
che la parte iniziale in cui la T oscilla o ha comportamenti bizzarri non è
interessante.
I primi $2$ps di simulazione saranno da buttare (equilibration time).
Il tempo max della simulazione lo possiamo fissare a 12ps, simulando
effettivamente 10ps. Si calcola la temperatura media durante la simulazione.
Controllare sempre la conservazione dell'energia. BIsogna fare un  grafico
che mostra come varia nel tempo l'energia totale e la temperatura. In realtà
non sarà mai perfettamente conservata per colpa del calcolatore.
L'energia è conservata se $ \delta E / E \leq 10^{-5}$. La fluttuazione relativa
è semplicemente la deviazione standard. Questa cosa va sempre controllata.
Se dobbiamo fare una simulazione a 300K, fissiamo a 600K, vediamo la media della
simulazione e poi correggiamo (con margine del 5% di errore) il valore iniziale
della temperatura.
Si parla di time step ideale come il time step più grnde per cui l'energia rimane
conservata secondo la definiziojne scritta sopra. Il range da provare e da cui
non bisogna uscire è $10^{-14} - 10^{-16}$.
#### Trovare il timestep ideale per le seguenti temperature:
* 300 K
* 600 K
* 800 K
Si può anche trovare il timestep ideale per 800 K, che è il caso peggiore, ed
utilizzarlo anche per le altre temperature.

# 13-01
Si può fare andare il programma più velocemente, senza sacrificare i risultati
delle traiettorie, energie e temperature calcolate.
Il metodo si chiama **Metodo delle Gabbie di Verlet**. Dobbiamo implementarla
senza troppi aiuti.
Nel nostro programma i cicli più lenti sono i cicli doppi che portano via il
quadrato del tempo ($ O(numero_{atomi}^2) $). Nonostante abbiamo usato la matrice
nvic, il nostro programma scala con il quadrato del numero di atomi. Questo è
dovuto al fatto che ogni volta ricalcoliamo il numero vicini all'interno del
ciclo più grande.
Per usare il metodo, nel punto in cui verifichiamo `r<r_prime` bisogna cambiare
il codice usando tre condizioni
```{matlab}
if r < r_prime
    % calcola con 4*epsilon ...
else if r < r_c
    % calcola con il polinomio ...
else if r > r_c
    % parte importante
    epot = epot + 0
end
```
Se non rifacciamo la lista dei vicini e usiamo sempre la stessa, riusciamo a
capire se gli atomi si sono mossi. Questo perchè se un atomo dovesse uscire dal
raggio di cutoff grazie alla terza condizione non viene cambiato il suo
contributo al potenziale. Questo non va bene però se avevo un atomo fuori dalla
lista dai vicini e dopo un certo delta_t entra nel raggio di cutoff. In questo
caso è tutto sbagliato.

*Come si fa ad ovviare?*
Il metodo delle gabbie serve proprio a questo. Introduciamo un nuovo raggio,
chiamato **Raggio di Verlet**. Dev'essere un po' più grande (per adesso mettiamolo
a `r_c + 0.4`). Questo sarà il raggio che useremo quando dobbiamo creare la
lista dei vicini.
Quindi chiamiamo i vicini una prima volta e consideriamo vicini anche quelli
compresi tra `r_c` e `r_verlet`. Così facendo quando calcoliamo il potenziale
se un atomo stava fuori dal raggio di cutoff ma dentro quello di verlet allora
verrà considerato.

La situazione peggiore che può capitare è quella in cui un atomo esterno al
raggio di verlet si muove in direzione dell'atomo su cui sto calcolando i vicini
dopo un'iterazione temporale.
Allora potrei calcolare lo spostamento massimo e valutare se è minore della
semidifferenza tra il raggio di cutoff e quello di verlet. Se non è verificata
la condizione allora ricalcolo i vicini.
Esempio di codice
```{matlab id:"ixvl9rce"}
    vicini(...)
    for imd=1:12000
        x = x + ... %calcolo le posizioni
        % mi calcolo la distanza
        d = sqrt((x(i) - x_verlet(i))^2 + (...)^2 + (...)^2)
        if d > 0.4*(r_verlet - r_c)
            vicini(...)
        end
    end
```

# 24-01
Se voglio fare una simulazione di bulk, come si compora realmente il materiale?
HO sempre degli effetti di superficie dovuti al fatto che gli atomi sentono dei
potenziali diversi da quelli interni
### PBC
Periodic Boundary conditions: modo per eliminare gli effetti di superficie
nel codice significa sostituire alle distanze fra gli atomi la distanza fra
l'atomo in considerazione e la sua immagine più vicina.
Inoltre le forze cambiano di segno se ripeto l'immagine.
Servono le dimensioni della cella
Ogni volta che abbiamo una funzione del tipo:
```{matlab}
dx = x(i)- x(j);
```
Se vogliamo confrontare il codice PBC con il codice non PBC

# 31-01
Fare una simulazione microcanonica signfica che oltre al fatto che si conserva
l'energia, se faccio una media temporale delle osservabili, questa è uguale
ai valori dell'ensemble microcanonico (per ipotesi ergodica).

In un ensemble canonico invece, ho una probabilità di effettuare una collisione
della particella con il termostato. Da questa probabilità riottengo una
distribuzione maxwelliana da cui estraggo la temperatura. Così facendo però
perdo le informazioni momentanea dell'energia che avevano le particelle. In
sostanza è come effettuare una simulazione di gas di particelle libere. La
temperatura istantea calcolata non è costante (altrimenti sarebbe un ensemble
isocinetico.) ma quella estratta dalla maxwelliana (quella vera) è conservata.
