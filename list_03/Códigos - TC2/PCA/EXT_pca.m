clear all;
clc;
%=================================================
dataset = importdata ('dermatologia2.txt');
%=================================================
 
[instance atrb_label]=size(dataset);
%================================================= 
%Zscore no dataset
data_set1=(dataset);
data_set1=zscore(data_set1);
%================================================= 
%Aplicando PCA usando a funcao nativa
[coeff, score, latent, tsquared] = princomp(data_set1(:,1:34));
matrix_cov = cov(data_set1(:,1:atrb_label-1));
%================================================= 

[vector value]=eig(matrix_cov);
auto_vet(1,:)=latent;
auto_vet(2:atrb_label,:)=vector;
eigvalue_decr = sort(auto_vet,2,'descend');
%================================================= 
%Ver variancia explicafa
for i=1:atrb_label-1
    VE(i)=sum(eigvalue_decr(1,1:i))/sum(eigvalue_decr(1,:))
end
%=================================================
%embaralhando os dados
for q=1:5
    clear derm_train;
    clear derm_test;
    clear derm_NEW;
    %Embaralhando dados
    shuffle=randperm(instance);
    for i=1:instance
        derm_shuffle(i,:)=dataset(shuffle(i),:);
    end
 %================================================   
    Q = eigvalue_decr(2:atrb_label,1:q);
    %Combinação linear 
     linear_newComb=derm_shuffle(:,1:atrb_label-1)*Q;        
    derm_NEW=linear_newComb;
    derm_NEW(:,q+1)=derm_shuffle(:,atrb_label);
 %================================================
    %Dados de treinamento
    for i=1:round(0.8*instance)
        derm_train(i,:)=derm_NEW(i,:);
    end
%=================================================    
    %dados de teste
    for i=1:round(0.2*instance)
        derm_test(i,:)=derm_NEW(i+round(0.8*instance),:);
    end
    
    [set_test new_atrb]=size(derm_test);
%=================================================    
    %classificador Gaussiano
    labels=derm_train(:,new_atrb);
 
    naiveBayes(:,q) = classify (derm_test(:,1:new_atrb-1),derm_train(:,1:new_atrb-1),labels,'linear');
%=================================================    
    %Calculando taxa de acerto
    rate=0;
    for i=1:set_test
        if naiveBayes(i,q) == derm_test(i,new_atrb)
            rate=rate+1;
        end
    end
    ratef(q)=rate/set_test
end
ratef;
%================================================= 
hold on
plot(VE,'o-b')
title ('Variância explicada')
legend('VE')
grid on
xlabel ('Componentes')
ylabel ('Porcentagem de VE (%)')