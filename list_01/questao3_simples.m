%POLYCARPO SOUZA NETO
%MESTRADO EM ENGENHARIA DE TELEINFORMÁTICA
%LISTA 1 - QUESTÃO 3
%==========================================================================
x=[80.07 48.07 52.40 32.01]';%indivíduo
%rotulos - patologias
ms=[51.69 12.82 43.54 38.86]';
me=[71.51 20.75 64.11 50.77]';
mh=[47.64 17.40 35.46 30.24]';
%==========================================================================
%Cálculo das distâncias
dist_1=sqrt(((x-ms)'*(x-ms)));
new_dist_1=find(dist_1==min(dist_1));
dist_2=sqrt(((x-me)'*(x-me)));
new_dist_2=find(dist_1==min(dist_2));
dist_3=sqrt(((x-mh)'*(x-mh)));
new_dist_3=find(dist_1==min(dist_3));
%=========================================================================
%Tabela de resultados
name={'Resultados'};
T = table(dist_1,dist_2,dist_3,...
'RowNames',name)
