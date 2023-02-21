clear all;
close all;
C_x= [1 1 1;1 2 1;1 1 3];
C_xt=C_x'; %transposto->teste de simetria
vet_n_nulo=rand(3,1); %vetor randomico nao nulo
prod= vet_n_nulo'*C_x*vet_n_nulo; %multiplicacao pelo vetor nao nulo e maior que zero
C_xeig=eig(C_x) %calculo de autovalores->saber se são positivos
C_xdet=det(C_x) %determinante->deve ser maior quezero
