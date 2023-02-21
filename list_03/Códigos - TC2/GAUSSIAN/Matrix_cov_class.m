function [Fclass] = Matrix_cov_class(dataset)
DATA=dataset.dados;
LABEL=dataset.target;
alpha=0.01;
[separate_class,all_labels]=samples(DATA,LABEL);
NN=zeros(1,all_labels);
%===============================================
cov_each_class=cell(1,all_labels);
invarse_covClass=cell(1,all_labels);
%===============================================
[p,~]=size(DATA);
%===============================================

meanClass=zeros(p,all_labels);
%===============================================
for i=1:all_labels
    [p,NN(i)]=size(separate_class{i});
    %===============================================
    mi=mean(separate_class{i}')';%média
    %===============================================
    %matriz de correlacao
    Matrix_CorE_est=(1/NN(i))*separate_class{i}*separate_class{i}';
    %===============================================
    %matriz de covariancia por classe estimada
    %pelo modo simples - menor tempo
    cov_each_class{i}=Matrix_CorE_est-(mi*mi');
    %===============================================
    %Aplicando regularizacao simples para ajudar na invertibilidade
    %Thikonov
    cov_each_class{i}=cov_each_class{i}+alpha*eye(p);
    %===============================================
    %inversa resolvida depois da regularizacao
    invarse_covClass{i}=inv(cov_each_class{i});
    %invarse_covClass{i}=pinv(cov_each_class{i});
    %===============================================
    % Media de cada classe
    meanClass(:,i)=mean(separate_class{1,i}')';
end
Fclass.x=separate_class;
Fclass.Matrix_cov_class=cov_each_class;
Fclass.invMatrix_cov_class=invarse_covClass;
Fclass.qtd_labels=all_labels;
Fclass.meanClass=meanClass;
Fclass.p=p;
end