%POLYCARPO SOUZA NETO
%MESTRADO EM ENGENHARIA DE TELEINFORMÁTICA
%LISTA 1 - QUESTÃO 5
%==========================================================================
C1=[1 -0.8 0.1; -0.8 9 -0.1; 0.1 -0.3 4];
C1t=C1'; %transposto->teste de simetria
C1det=det(C1); %determinante->deve ser maior que zero
C1eig=eig(C1); %calculo de autovalores->saber se são positivos
%=========================================================================
C2= [1 0 0;0 1 0;0 0 0];
C2t=C2'; %transposto->teste de simetria
v2=rand(3,1); %vetor randomico nao nulo
mult2= v2'*C2*v2; %multiplicacao pelo vetor nao nulo e maior que zero
C2eig=eig(C2); %calculo de autovalores->saber se são positivos
C2det=det(C2); %determinante->deve ser maior quezero
%=========================================================================
C3=[4 -0.8 0.1; -0.8 9 -0.1; 0.1 -0.1 16];
C3t=C3'; %simetrica
v3=rand(3,1);  %vetor randomico nao nulo
mult3= v3'*C3*v3; %multiplicacao pelo vetor nao nulo e maior que zero
C3det=det(C3); %determinante->deve ser maior quezero 
C3eig=eig(C3); %calculo de autovalores->saber se são positivos



