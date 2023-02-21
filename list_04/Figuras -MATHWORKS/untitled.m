
clc;
%Inicializando 
%load 'derm_input.txt'
load 'iris.txt'
dataset=iris;
[p N] =size(dataset);
%Selecionando três centroides ao acaso       
Selection=rand(1,3);
Selection=Selection*N(1,1);
Selection=ceil(Selection); %Selecting the row number.
Centre1=dataset(Selection(1),:);
Centre2=dataset(Selection(2),:);
Centre3=dataset(Selection(3),:);
n=100;
%Kmeans 
for j=1:1:n
count1=0;
Mean1=zeros(1,4);
count2=0;
group1=[];
Mean2=zeros(1,4);
group2=[];
count3=0;
group3=[];
Mean3=zeros(1,4);
%pegando a menor distancia
for i=1:1:N(1,1)
Pattern1(i)=sqrt((Centre1(1,1)-dataset(i,1))^2+(Centre1(1,2)-dataset(i,2))^2+(Centre1(1,3)-dataset(i,3))^2+(Centre1(1,4)-dataset(i,4))^2);
Pattern2(i)=sqrt((Centre2(1,1)-dataset(i,1))^2+(Centre2(1,2)-dataset(i,2))^2+(Centre2(1,3)-dataset(i,3))^2+(Centre1(1,4)-dataset(i,4))^2);
Pattern3(i)=sqrt((Centre3(1,1)-dataset(i,1))^2+(Centre3(1,2)-dataset(i,2))^2+(Centre3(1,3)-dataset(i,3))^2+(Centre1(1,4)-dataset(i,4))^2);
LessDist=[Pattern1(i) Pattern2(i) Pattern3(i)];
Minimum=min(LessDist);

%pegando um novo centro
if (Minimum==Pattern1(i))
    count1=count1+1;
    Mean1=Mean1+dataset(i,:);
    group1=[group1 i];
else if (Minimum==Pattern2(i))
        count2=count2+1;
        Mean2=Mean2+dataset(i,:);
        group2=[group2 i];
    else count3=count3+1;
        Mean3=Mean3+dataset(i,:);
        group3=[group3 i];  
    end
end

end
%novos centros
Centre1=Mean1/count1;
Centre2=Mean2/count2;
Centre3=Mean3/count3;
% plot(j,count1,'c');
% plot(j,count2,'m');
% plot(j,count3,'k');

end

% specify the indexed color for each point
icolor = ceil((dataset(:,4)/max(dataset(:,4)))*256);

% figure,
% scatter3(dataset(:,1),dataset(:,2),dataset(:,3),dataset(:,4),icolor,'filled');
hold on
figure,
scatter3(dataset(:,1),dataset(:,2),dataset(:,3),[],dataset(:,4),'filled');
title('Distribuicao das amostras do dataset IRIS')
hold off
