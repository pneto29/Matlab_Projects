clc;
clear all; close all;

clear, clc
S = importdata ('dermatologia.txt');

[p N_atb]=size(S);
m=mean(S')';
%usando o COV
tic
Cx_1=cov(S')/(N_atb-1);
toc
%usando a equação maior com o for
tic
Soma=zeros();
for i=1:N_atb,
Soma=Soma+(S(:,i)-m)*(S(:,i)-m)';
end
Cx_2=Soma/(N_atb);
toc
tic
Rx=(1/N_atb)*S*S';
Cx_3=Rx-(m*m');
toc
% replicando a matriz de médias
tic
M=repmat(m,1,N_atb);
Cx_4=(1/N_atb)*(S-M)*(S-M)';
toc
