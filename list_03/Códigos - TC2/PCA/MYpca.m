function Y=MYpca(D,Q)
[d,n]=size(D');
C_x=cov(D);
[U D]=eig(C_x);
Diag=diag(D);
[sorted index]=sort(Diag,'descend');
Proj=zeros(d,Q); % projeção
for j=1:Q
Proj(:,j)=U(:,index(j));
end
Y=D*Proj; %primeiras K componentes