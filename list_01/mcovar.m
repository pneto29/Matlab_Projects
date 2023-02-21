%POLYCARPO SOUZA NETO
%MESTRADO EM ENGENHARIA DE TELEINFORMÁTICA
%LISTA 1 - QUESTÃO 8 -Método 3 %equacao 66
%==========================================================================
function C=mcovar(X)
[N p]=size(X);
soma=zeros(p);
[N p]=size(X);
M= sum(X)/N;
for i=1:N,
    soma=soma + (X(i,:)-M)'*(X(i,:)-M);
end
C=soma/(N-1);
