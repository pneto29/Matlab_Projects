%POLYCARPO SOUZA NETO
%MESTRADO EM ENGENHARIA DE TELEINFORMÁTICA
%LISTA 1 
%==========================================================================
x1=[1 2]'; %vetor 1
x2=[-1 3]'; %vetor 2
x3=[1 -1]'; %vetor 3
S=[x1 x2 x3]; %concatenacao dos vetores que formam a matriz
[p N_atb]=size(S);
m=mean(S')';
%usando o COV
tic
Cx_1=cov(S')/(N_atb-1);
toc
%usando a equação maior com o for
tic
Soma=zeros(p);
for i=1:N_atb,
    Soma=Soma+(S(:,i)-m)*(S(:,i)-m)';
end
Cx_2=Soma/(N_atb);
toc
% método econômico
tic
Rx=(1/N_atb)*S*S';
Cx_3=Rx-(m*m');
toc
% replicando a matriz de médias
tic
M=repmat(m,1,N_atb);
Cx_4=(1/N_atb)*(S-M)*(S-M)';
toc
%implementação Profº Guilherme Slide
tic
Cx_5=mcovar(X);
toc

