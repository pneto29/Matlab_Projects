
clear;
clc;
tic
%================================================
dermatologia = importdata ('dermatologia2.txt');
% dermatologia=zscore(dermatologia);
[instance atrb_label]=size(dermatologia);
%================================================

for q=1:5
    clear derm_train;
    clear derm_test;
    clear derm_shuffle;
%================================================    

%Sai embaralhando os dados
    shuffle=randperm(instance);
    for i=1:instance
        derm_shuffle(i,:)=dermatologia(shuffle(i),:);
    end
%================================================    
    var_atrb=var(derm_shuffle(:,1:5));
    %Encontrando os atributos com maior variancia
    %Mesma coisa de pegar os atributos mais relevantes
    for i=1:q
        best_atrb(i)=find(var_atrb==max(var_atrb));   
        var_atrb(best_atrb(i))=0;
    end
    dermat=derm_shuffle(:,best_atrb);
    dermat(:,q+1)=derm_shuffle(:,atrb_label);
%================================================    
    [instance2 new_atrb]=size(dermat);
    
    %Dados de treinamento
    for i=1:round(0.8*instance2)
        derm_train(i,:)=dermat(i,:);
    end
%================================================    
    %escolhendo os dados de teste
    for i=1:instance2 -round(0.8*instance2)
        derm_test(i,:)=dermat(i+round(0.8*instance2),:);
    end
%================================================    
    [test_set new_atrb2]=size(derm_test);
    %Classificador usando a funcao nativa
    labels=derm_train(:,new_atrb2);
    class(:,q) = classify (derm_test(:,1:new_atrb2-1),derm_train(:,1:new_atrb2-1),...
        labels,'diaglinear');
    %Calculando taxa de acerto
    rate=0;
    for i=1:test_set
        if class(i,q) == derm_test(i,new_atrb2)
            rate=rate+1;
        end
    end
    ratef(q)=rate/test_set;
end

ratef
med=mean(ratef)
maxx=max(ratef)
medd=median(ratef)
minn=min(ratef)
figure(2)
hold on
title('Acerto com 5 do conjunto original')
boxplot(ratef, 'Labels',{'Naive'})
grid on
hold off
%=====================================================
% hold on
% grid on
% plot(ratef,'h-k')
% title ('Reconstrução')
% ylabel ('Acerto')
toc
% figure(1)
% hold on
% plot(var_atrb,'r-o')
% grid on
% title('Variância dos atributos')
% ylabel('Variância')
% xlabel('Atributos')
% hold off
% hold on
% plot(ratef)
% 
% grid on
% hold off