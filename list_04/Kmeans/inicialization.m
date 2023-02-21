function [VAR,CLUSTER,Evaluation,Hint] = inicialization(all_instance)

%numero de clusters
VAR.K_hint=5;
%qtd de repeticoes
VAR.all_repeat = 100;            
%inicializando o clsuter
VAR.start = 1;

CLUSTER.clusters=cell(VAR.K_hint);
CLUSTER.clusters_d=cell(VAR.K_hint);
CLUSTER.target_cluster=cell(VAR.K_hint);

%ssd de cada cluster por repeticao
Evaluation.SSD=zeros(VAR.K_hint,VAR.all_repeat);     
Evaluation.best_SSD=VAR.all_repeat*ones(1,VAR.K_hint); 
%msqe
Evaluation.SSD_instance=zeros(VAR.K_hint,VAR.all_repeat);   
Evaluation.best_SSD_instance=100*ones(1,VAR.K_hint);   
%melhor cluster
Evaluation.best=cell(VAR.K_hint);              
Evaluation.best_labels=cell(VAR.K_hint);
Evaluation.best_d=cell(VAR.K_hint); 
%melhor indice dos clusters
Evaluation.best_p=zeros(VAR.K_hint,all_instance); 
%melhor centroide
Evaluation.best_c=cell(VAR.K_hint,1);       
%% indices que sugestionam melhores K_opt
Hint.DB_index = zeros(1,VAR.K_hint);
Hint.DUNN_index = zeros(1,VAR.K_hint);
end

