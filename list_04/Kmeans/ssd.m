function [exit] = ssd(dataset,VAR)
dados = dataset.dados;
[nC,N] = size(dados);

%obtencao dos valores de centroide
%
%clusters
Center = VAR.C;
%indices para indicar o que pertence ao dado cluster
index = VAR.index;  

SSD = 0;
for i = 1:N,
    SSD = SSD + sum((Center(:,index(i)) - dados(:,i)).^2);
end
SSD;
SSD_instance = SSD/N;
exit.SSD = SSD;
exit.SSD_instance = SSD_instance;

