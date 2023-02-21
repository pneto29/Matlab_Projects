clc;
clear all; close all;

clear, clc
x1=[1 2]'; 
x2=[-1 3]'; 
x3=[1 -1]';
S=[x1 x2 x3];

[p N_atb]=size(S);
m=sum(S')';
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
tic
Rx=(1/N_atb)*S*S';
Cx_3=Rx-(m*m');
toc
% replicando a matriz de médias
tic
M=repmat(m,1,N_atb);
Cx_4=(1/N_atb)*(S-M)*(S-M)';
toc
tic
Rx=m*m';
for n=1:N_atb
    a=n/(n+1);
    Rx=a*Rx+(1-a)*S(:,n)*S(:,n)';
    mx=a*m+(1-a)*S(:,n);
end
Cx_6=Rx-(mx*mx');
toc