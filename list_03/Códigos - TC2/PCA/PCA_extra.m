clear; clc;
tic
load 'derm_input.txt'
load 'derm_target.txt'
dataset.dados=derm_input;
% dataset.dados=zscore(dataset.dados);
dataset.target=derm_target;
[p,N]=size(dataset.target);
labels=zeros(1,N);
for i=1:N
    labels(i)=find(dataset.target(:,i)==max(dataset.target(:,i)));
end
dataset.target=labels;
[c_mat_cov]=Matrix_cov_class(dataset);
[~,N]=size(dataset.dados);
all_repeat=100;
%a)
K=22;
W= PCA1((dataset.dados'),K);

train.W=0.8;

%arredonda os elementos de X para os inteiros mais próximos
%para menos infiNNto
train_all=floor(train.W*N);
test_all=N-floor(train.W*N);

out.rate=zeros(all_repeat,4);
out.worse=inf*ones(1,4);
out.better=zeros(1,4);
out.confusaobetter=cell(1,4);
out.confusaoworse=cell(1,4);
for n_repeat=1:all_repeat
    %Separa dados para treinamento e para teste
    emb_datasetset=randperm(N);
    %returns a vector contaiNNng a random permutation of the
    %integers 1:N.
    dataset_train.dados=dataset.dados(:,emb_datasetset(1:train_all));
    test_dataset=dataset.dados(:,emb_datasetset((train_all+1):N));
    dataset_train.target=dataset.target(:,emb_datasetset(1:train_all));
    test_labels=dataset.target(:,emb_datasetset((train_all+1):N));
    % Treinamento
    [matrix_cov_datasetTRAIN]=Matrix_cov_class(dataset_train);
    [Cx]=covariance(dataset_train.dados);
    % Teste
    
    case_gaussCLASS=cell(1,4);
    for j=1:4
        case_gaussCLASS{1,j}=zeros(matrix_cov_datasetTRAIN.qtd_labels,test_all);
    end
    find_out=zeros(4,test_all);
    for i=1:test_all
        % Calcular funcao discriminante
        aux=zeros(matrix_cov_datasetTRAIN.p,matrix_cov_datasetTRAIN.qtd_labels);
        for j=1:matrix_cov_datasetTRAIN.qtd_labels
            aux(:,j)=test_dataset(:,i)-matrix_cov_datasetTRAIN.meanClass(:,j);
           case_gaussCLASS{1,4}(j,i)=(aux(:,j))'*inv(diag(diag(matrix_cov_datasetTRAIN.Matrix_cov_class{1,j})))*aux(:,j);
        end
        % Associar rotulo
        find_out(4,i)=find(case_gaussCLASS{1,4}(:,i)==min(case_gaussCLASS{1,4}(:,i)));
    end
    % out
    for i=1:4
        out.rate(n_repeat,i)=100*(length(find(find_out(i,:)==test_labels))/test_all);
        if(out.rate(n_repeat,i)>out.better(i))
            out.maior(i)=out.rate(n_repeat,i);
            [out.confusaobetter{1,i}]=confusionmat(test_labels,find_out(i,:));
               end
    end
end

mean_results=mean(out.rate(:,4))
median_results=median(out.rate(:,4))
dev_stn=std(out.rate(:,4))
better_results=max(out.rate(:,4))
worse_result=min(out.rate(:,4))
hold on
title('Rendimento do Naive Bayes com q=22')
boxplot([out.rate(:,4)], 'Labels',{'Caso 4'})
grid on
hold off

toc