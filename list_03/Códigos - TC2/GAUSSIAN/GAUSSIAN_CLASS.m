clear; clc;
load 'derm_input.txt'
load 'derm_target.txt'

%=====================================================
dataset.dados=derm_input;
% corrplot(derm_input)
%Q=22;
% Y=MYpca(dataset.dados,22)
%normalizando dados 
%media 0 e variancia 1
% dataset.dados=zscore(dataset.dados);
%rotulos
dataset.target=derm_target;
all_repeat=100;
train=0.8;
%=====================================================
%tamanho do conjunto
%p-> classes
%N->instancias
[p,N]=size(dataset.target);
%=====================================================
%matriz com os rótulos de todo mundo
labels=zeros(1,N);
%for para buscar de acordo com a instancia o seu rotulo
for i=1:N
    labels(i)=find(dataset.target(:,i)==max(dataset.target(:,i)));
end
%=====================================================
dataset.target=labels;
%=====================================================
%chamando funcao para calcular a matriz de covariancia por classe
%sobre o dataset original
[c_mat_cov]=Matrix_cov_class(dataset);
%=====================================================

[~,N]=size(dataset.dados);
%=====================================================
%arredonda os elementos de X para os inteiros mais próximos
train_all=floor(train*N);
test_all=N-floor(train*N);
%=====================================================
%inicializando  variaveis para poder fazer a matriz de confusao
out.rate=zeros(all_repeat,4);
%pior caso começa com infinito
%melhor em zero
out.worse=inf*ones(1,4);
out.better=zeros(1,4);
%matriz pra melhor e pior caso respectivamente
out.confusaobetter=cell(1,4);
out.confusaoworse=cell(1,4);

%=====================================================
for n_repeat=1:all_repeat
    %embaralha os dados
    emb_datasetset=randperm(N);
    %retorna um vetor que contém uma permutação aleatória de
    %=====================================================
    dataset_train.dados=dataset.dados(:,emb_datasetset(1:train_all));
    test_dataset=dataset.dados(:,emb_datasetset((train_all+1):N));
    dataset_train.target=dataset.target(:,emb_datasetset(1:train_all));
    test_labels=dataset.target(:,emb_datasetset((train_all+1):N));
    %
    [matrix_cov_datasetTRAIN]=Matrix_cov_class(dataset_train);
    [Cx]=covariance(dataset_train.dados);
    % Teste
    %=====================================================
    case_gaussCLASS=cell(1,4);
    for j=1:4
        case_gaussCLASS{1,j}=zeros(matrix_cov_datasetTRAIN.qtd_labels,test_all);
    end
    find_out=zeros(4,test_all);
    for i=1:test_all
        %=============================================================
        % LDA
        ass_label=zeros(matrix_cov_datasetTRAIN.p,matrix_cov_datasetTRAIN.qtd_labels);
        for j=1:matrix_cov_datasetTRAIN.qtd_labels
            ass_label(:,j)=test_dataset(:,i)-matrix_cov_datasetTRAIN.meanClass(:,j);
            %Euclidiano
            case_gaussCLASS{1,1}(j,i)=(ass_label(:,j))'*eye(matrix_cov_datasetTRAIN.p)*ass_label(:,j);
            %Mahalanobis
            case_gaussCLASS{1,2}(j,i)=(ass_label(:,j))'*Cx.inv*ass_label(:,j);
            %Geral
            case_gaussCLASS{1,3}(j,i)=(ass_label(:,j))'*matrix_cov_datasetTRAIN.invMatrix_cov_class{1,j}*ass_label(:,j)-log(det(c_mat_cov.Matrix_cov_class{1,j}));
            %Naive Bayes
            
            case_gaussCLASS{1,4}(j,i)=(ass_label(:,j))'*inv(diag(diag(matrix_cov_datasetTRAIN.Matrix_cov_class{1,j})))*ass_label(:,j);
        
        end
        
        % 
        find_out(1,i)=find(case_gaussCLASS{1,1}(:,i)==min(case_gaussCLASS{1,1}(:,i)));
        find_out(2,i)=find(case_gaussCLASS{1,2}(:,i)==min(case_gaussCLASS{1,2}(:,i)));
        find_out(3,i)=find(case_gaussCLASS{1,3}(:,i)==min(case_gaussCLASS{1,3}(:,i)));
        find_out(4,i)=find(case_gaussCLASS{1,4}(:,i)==min(case_gaussCLASS{1,4}(:,i)));
    end
    %=============================================================
    %matriz de confusao do melhor caso
    for i=1:4
        out.rate(n_repeat,i)=100*(length(find(find_out(i,:)==test_labels))/test_all);
        if(out.rate(n_repeat,i)>out.better(i))
            out.maior(i)=out.rate(n_repeat,i);
            [out.confusaobetter{1,i}]=confusionmat(test_labels,find_out(i,:));
            
        end
    end
    %============================================================
    %matriz de confusao do pior caso
        for i=1:4
        out.rate(n_repeat,i)=100*(length(find(find_out(i,:)==test_labels))/test_all);
        if(out.rate(n_repeat,i)<out.worse(i))
            out.worse(i)=out.rate(n_repeat,i);
            [out.confusaoworse{1,i}]=confusionmat(test_labels,find_out(i,:));
        end
        end
end
%=============================================================
% mean_results1=median(out.rate(:,1))
% median_results1=median(out.rate(:,1))
% dev_stn1=std(out.rate(:,1))
% better_result1=max(out.rate(:,1))
% worse_result1=min(out.rate(:,1))
%=============================================================

% m2=median(out.rate(:,2));m3=median(out.rate(:,3));m4=median(out.rate(:,4));
% b2=max(out.rate(:,2));b3=max(out.rate(:,3));b4=max(out.rate(:,4));
% w2=min(out.rate(:,2));w3=min(out.rate(:,3));w4=min(out.rate(:,4));
% m1=median(out.rate(:,1));b1=max(out.rate(:,1));w1=min(out.rate(:,1));
% [m2 m3 m4]
% [b2 b3 b4]
% [w2 w3 w4]
% [m1] 
% [b1]
% [w1]

% %=============================================================
% %Matrizes dos melhores casos
% out.confusaobetter{1,1}
% out.confusaobetter{1,2}
% out.confusaobetter{1,3}
% out.confusaobetter{1,4}
% 
% %=============================================================
% %Matrizes dos piores casos
% out.confusaoworse{1,1}
% out.confusaoworse{1,2}
% out.confusaoworse{1,3}
% out.confusaoworse{1,4}

%=============================================================
% figure(1)
% hold on
% grid on
% 
% plot(g1,'h-r')
% plot(g2,'s-k')
% plot(g3,'p-g')
% plot(g4,'o-b')
% title ('Variando treino/teste de 90/10:10/90 - Média')
% ylabel ('Acerto')
% % xlabel('Labels',{'90/10','80/20','70/30','60/40','50/50','40/60','30/70','20/80'})
% legend('Caso 1','Caso 2','Caso 3','Caso 4')
% hold off
% 
% figure(5)
% % figure(1)
% hold on
% grid on
% g1=[94.4 93 92.5 93.0 92.7 91.6 90.8 89.5];
% g2=[97.2 95.8 96.2 95.8 94.9 94.4 93 89.5];
% g3=[94.4 95.8 95.3 95.1 94.4 93.4 90.8 87.9];
% g4=[97.2 97.2 97.2 97.2 97.2 96.7 96.7 96.1];
% plot(g1,'h-r')
% plot(g2,'s-k')
% plot(g3,'p-g')
% plot(g4,'o-b')
% title ('Variando treino/teste de 90/10:10/90')
% ylabel ('Acerto')
% % xlabel('Labels',{'90/10','80/20','70/30','60/40','50/50','40/60','30/70','20/80'})
% legend('Caso 1','Caso 2','Caso 3','Caso 4')
% hold off
%
%==============================================================
figure(2)
hold on
grid on
title('Boxplot dos classificadores com os dados não normalizados')
boxplot([out.rate(:,1),out.rate(:,2),out.rate(:,3),out.rate(:,4)],...
    'Labels',{'Euclidiano','Mahalanobis','Geral','Naive Bayes'})
hold off
% %==============================================================
% figure(3)
% hold on
% grid on
% boxplot([out.rate(:,4)],...
%     'Labels',{'Naive Bayes'})
% hold off
% %==============================================================
% figure(4)
% hold on
% grid on
% boxplot([out.rate(:,1)],...
%     'Labels',{'Euclidiana'})
% hold off


