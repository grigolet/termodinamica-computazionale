
data = load('simulazione-gabbie.txt');

e_pot  = data(:,1);
e_k    = data(:,2);
t_inst = data(:,3);

hold on
plot(e_pot + e_k)
plot(t_inst)
hold off

legend('Energia totale', 'Temperatura istantanea');