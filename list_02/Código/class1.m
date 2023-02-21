load 'patologias.txt'
dados=patologias; % X[p N]
[p N]=size(dados);
m=mean(dados')';
% equacao 68 - for grande
tic
soma=zeros(p);
for i=1:N,
    soma=soma+(dados(:,i)-m)*(dados(:,i)-m)';
end
Cx_1=soma/(N);
toc
% equacao 69 - economico
tic
Rx=(1/N)*dados*dados';
Cx_2=Rx-(m*m');
toc
% equacao 70- replicando amtriz de medias
tic
M=repmat(m,1,N);
Cx_3=(1/N)*(dados-M)*(dados-M)';
toc
% recursivo - a
tic
mx=dados(:,1);
Rx=mx*mx';
for n=2:N
    a=n/(n+1);
    Rx=a*Rx+(1-a)*dados(:,n)*dados(:,n)';
    mx=a*mx+(1-a)*dados(:,n);
end
Cx_4=Rx-(mx*mx');
toc
%cov nativo do matlab
tic
Cx_5=cov(dados');
toc