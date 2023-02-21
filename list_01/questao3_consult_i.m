x=[80.07 48.07 52.40 32.01]';%indivíduo
k=3; m=cell(1,k);
vet_distancia=zeros(1,k);
m{1}=[51.69 12.82 43.54 38.86]';
m{2}=[71.51 20.75 64.11 50.77]';
m{3}=[47.64 17.40 35.46 30.24]';
for i=1:k
vet_distancia(i)=sqrt(((x-m{i})'*(x-m{i})));
end
vet_esp(i)=find(vet_distancia==min(vet_distancia))
%Tabela de resultados
name={'Resultados'};
T = table(vet_distancia(1),vet_distancia(2),vet_distancia(3),...
'RowNames',name)
boxplot(vet_esp(1),vet_esp(2),vet_esp(3))