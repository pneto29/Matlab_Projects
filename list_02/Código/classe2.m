%lendo conjunto de dados
load 'patologias.txt'
load 'pacientes.txt'
%arquivo com os rotulos
labels= patologias;
%diagnosticos
diag=pacientes;
[p N]=size(diag);
%encontrar os rotulos
labels_tot=zeros(1,N);
for i=1:N
    labels_tot(i)=find(patologias(:,i)==max(patologias(:,i)));
end
%vetor de rotulos sem repeticao
vet_labels=unique(labels_tot);
%tamanho e quantidade de rotulos
num_labels=length(vet_labels);
%separar as classes por rotulos
separate_class=cell(1,num_labels);
for i=1:num_labels
    index=find(labels_tot==vet_labels(i));
    separate_class{i}=diag(:,index);
end
%calcular matriz pra cada classe
Matrix_cov_class=cell(1,num_labels);
%calcualr posto por classe
find_rank=cell(1,num_labels);
%encontrar numero de condicionamento por classe
find_number_condit=cell(1,num_labels);
for i=1:num_labels
    [~,Ni]=size(separate_class{i});
    %media dos dados por classe
    m_class=mean(separate_class{i}')';
    Matrix_CorE_est=(1/Ni)*separate_class{i}*separate_class{i}'
    %calcula matriz de covariancia
    Matrix_cov_class{i}=Matrix_CorE_est-(m_class*m_class');
    %tamanho de cada classe 
    %necessario para verificar posto
    size_each_class=size(separate_class{i});
    %posto de cada classe
    find_rank{i}=rank(Matrix_cov_class{i});
    %numero de condicionamento
    %norm-2 default
    find_number_condit{i}=cond(Matrix_cov_class{i});
    %normas p genericas
    %norma de Frobenius
    find_number_condit_fro{i}=cond(Matrix_cov_class{i},'fro');
    %norma 1
    find_number_condit_hum{i}=cond(Matrix_cov_class{i},1);
    %norma infinita
    find_number_condit_inf{i}=cond(Matrix_cov_class{i},'inf');
    find_number_rcondit{i}=rcond(Matrix_cov_class{i});

end
%pega tamanho de cada classe 34xn
size_each_class1=size(separate_class{1});
size_each_class2=size(separate_class{2});
size_each_class3=size(separate_class{3});
size_each_class4=size(separate_class{4});
size_each_class5=size(separate_class{5});
size_each_class6=size(separate_class{6});

%tabela com resultados
name={'TAMANHO - CLASSE'};
T = table(size_each_class1,size_each_class2,size_each_class3,size_each_class4,size_each_class5,size_each_class6,...
    'RowNames',name)

%======================================
    find_number_rcondit1=rcond(Matrix_cov_class{1});
    find_number_rcondit2=rcond(Matrix_cov_class{2});
    find_number_rcondit3=rcond(Matrix_cov_class{3});
    find_number_rcondit4=rcond(Matrix_cov_class{4});
    find_number_rcondit5=rcond(Matrix_cov_class{5});
    find_number_rcondit6=rcond(Matrix_cov_class{6});

    name={'RCOND - CLASSE'};
T = table(find_number_rcondit1,find_number_rcondit2,find_number_rcondit3,find_number_rcondit4,find_number_rcondit5,find_number_rcondit6,...
    'RowNames',name)
%======================================

    find_number_condit1=cond(Matrix_cov_class{1});
    find_number_condit2=cond(Matrix_cov_class{2});
    find_number_condit3=cond(Matrix_cov_class{3});
    find_number_condit4=cond(Matrix_cov_class{4});
    find_number_condit5=cond(Matrix_cov_class{5});
    find_number_condit6=cond(Matrix_cov_class{6});
    
    name={'RCOND - CLASSE'};
T = table(find_number_condit1,find_number_condit2,find_number_condit3,find_number_condit4,find_number_condit5,find_number_condit6,...
    'RowNames',name)
