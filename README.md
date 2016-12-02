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
Function che calcola `v_x, v_y, v_z` utilizzando la distribuzione rettangolare.
