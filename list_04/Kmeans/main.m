
%==========================================================================
%escolher conjunto de dados
clear; clc;
%IRIS -> VALIDACAO
% load 'iris.txt'
% load 'iris_labels.txt'
% dataset.dados=iris';
% dataset.dados=zscore(iris');
%
% dataset.dados_d=dataset.dados;
% dataset.alvos=iris_labels';
% [dataset.p,dataset.all_instance]=size(dataset.dados);

%DERMATOLOGIA -> Meu conjunto
load 'derm_input.txt'
load 'derm_target.txt'
dataset.dados=derm_input;
dataset.dados=zscore(derm_input);
dataset.alvos=derm_target;
[all_labels_class,all_instance]=size(dataset.alvos);
labels=zeros(1,all_instance);
for i=1:all_instance
    labels(i)=find(dataset.alvos(:,i)==max(dataset.alvos(:,i)));
end
dataset.dados_d=dataset.dados;

dataset.alvos=labels;
[dataset.p,dataset.all_instance]=size(dataset.dados);
%========================================================================
%inicializando as definicoes da funcao inicialization
[VAR,CLUSTER,separate,Hint] = inicialization(dataset.all_instance);
%========================================================================

for i=1:VAR.K_hint
    VAR.k = i;
    i,
    for rep=1:VAR.all_repeat
        %kmeans_batch ->funcionando
        %kmeans_sequencial-> comenta o que tá funcionando e descomenta o
        %resto em kmeans_switch_coment
        [result_1,distance] = kmeans_switch_coment(dataset,i);
        p{i,rep} = result_1.index;
        c{i,rep} = result_1.C;
        
        %divide os dados em tantos CLUSTER
        for l=1:i,
            J=find(result_1.index==l);
            VJ=dataset.dados(:,J);%particao
            VJ_d=dataset.dados_d(:,J);
            VD=dataset.alvos(:,J);
            CLUSTER.clusters{i,l}=VJ;
            CLUSTER.clusters_d{i,l}=VJ_d;
            CLUSTER.target_cluster{i,l}=VD;
        end
        
        [result_2] = ssd(dataset,result_1);
        separate.SSD(i,rep)=result_2.SSD;
        separate.SSD_instance(i,rep)=result_2.SSD_instance;
        
        if separate.SSD_instance(i,rep)<separate.best_SSD_instance(i)
            separate.best_SSD_instance(i)=separate.SSD_instance(i,rep);
            separate.best_SSD(i)=separate.SSD(i,rep);
            for l=1:i
                separate.best{i,l}=CLUSTER.clusters{i,l};
                separate.best_d{i,l}=CLUSTER.clusters_d{i,l};
                separate.best_labels{i,l}=CLUSTER.target_cluster{i,l};
            end
            separate.best_p(i,:)=result_1.index;
            separate.best_c{i}=result_1.C;
        end
    end
    %metricas de validacao
    VAR_vi.index = separate.best_p(VAR.k,:); % Labels vector [1xN]
    VAR_vi.C = separate.best_c{VAR.k}; %Centroids matrix [pxk]
    VAR_vi.SSD = separate.best_SSD(VAR.k); %SSD
    %DUNN index
    [DUNN] = DUNN_index(dataset,VAR_vi);
    Hint.DUNN_index(VAR.k) = DUNN;
    % DB
    [DB] = DB_index(dataset,VAR_vi);
    Hint.DB_index(VAR.k) = DB;
    
end

% P
figure (1);
plot(Hint.DB_index,'rh-','LineWidth',2)
xlabel('Quantidade de CLUSTER')
ylabel('Índice')
grid on
title('Índice DB ')

figure (2)
plot(Hint.DUNN_index,'bs-','LineWidth',2)
xlabel('Quantidade de CLUSTER')
ylabel('Índice')
grid on
title('Índice DUNN ')

figure(3)
hold on,
ylabel('SSD')
title('SSD pelo número de K')
boxplot(separate.SSD','Labels',{'K=1','K=2','K=3','K=4','K=5'})
grid on
hold off

figure(4)
hold on,
ylabel('MSQE')
title('MSQE pelo número de K')
boxplot(separate.SSD_instance','Labels',{'K=1','K=2','K=3','K=4','K=5'})
grid on
hold off
figure(5)
hold on,
ylabel('SSD - dermatologia')
xlabel('Qtd. de CLUSTER (K)')
title('SSD pelo número de K')
plot(separate.best_SSD,'go-','LineWidth',2)
grid on
hold off

figure(6)
hold on,
ylabel('MSQE - dermatologia')
xlabel('Qtd. de CLUSTER (K)')
title('MSQE pelo número de K')
plot(separate.best_SSD_instance,'go-','LineWidth',2)
grid on
hold off
