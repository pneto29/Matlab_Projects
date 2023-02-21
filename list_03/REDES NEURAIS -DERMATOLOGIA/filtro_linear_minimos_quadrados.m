%%POLYCARPO SOUZA NETO
%%3º trabalho de ICA
%%REDES NEURAIS
%% CODIGOS ORIGINAIS: PROF GUILHERME

clear; clc; close all

%====================================================================
%ler dados
load derm_input.txt;
load derm_target.txt;
%====================================================================
%entrada e saidas 
dados=derm_input;  % Vetores (padroes) de entrada
alvos=derm_target; % Saidas desejadas correspondentes
%====================================================================
%desaloca espaço na memória 
clear derm_input;  % Libera espaco em memoria
clear derm_target;
%===================================================================
% embaralha entradas e saidas
[LinD ColD]=size(dados);
[LinT ColT]=size(alvos);
%===================================================================
% Normaliza componetes para media zero e variancia unitaria
for i=1:LinD,
	mi=mean(dados(i,:));  % Media das linhas
    di=std(dados(i,:));   % desvio-padrao das linhas 
	dados(i,:)= (dados(i,:) - mi)./di;
end 
Dn=dados;
%==================================================================
% Define tamanho dos conjuntos de treinamento/teste (hold out)
ptrn=0.8;    % Porcentagem usada para treino
ptst=1-ptrn; % Porcentagem usada para teste

%====================================================================
% arquitetura da rede
Nr = 200;   % No. de rodadas de treinamento/teste
%==========================================================================
%laço com as rodadas

for r=1:Nr,     
    rodada=r,
    % Embaralha pares entrada/saida ->contem permutacoes aleatorias segundo
    % o for
    I=randperm(ColD); Dn=Dn(:,I); alvos=alvos(:,I);   
        
    % Vetores para treinamento e saidas desejadas correspondentes
    J=floor(ptrn*ColD);
    P = Dn(:,1:J); T1 = alvos(:,1:J);
    [lP cP]=size(P);   % Tamanho da matriz de vetores de treinamento
    
    % Vetores para teste e saidas desejadas correspondentes
    Q = Dn(:,J+1:end); T2 = alvos(:,J+1:end);
    [lQ cQ]=size(Q);   % Tamanho da matriz de vetores de teste
%==========================================================================
%implementa minimos quadrados
%pesos=alvo pinv
    W=T1*pinv(P);
    %W=T1\P;
    
    %% ETAPA DE GENERALIZACAO  %%%
    OUT2=W*Q;
    
    % CALCULA TAXA DE ACERTO
    count_OK=0;  % Contador de acertos
   
    for t=1:cQ,
        [T2max iT2max]=max(T2(:,t));  % Indice da saida desejada de maior valor
        [OUT2_max iOUT2_max]=max(OUT2(:,t)); % Indice do neuronio cuja saida eh a maior
        
        if iT2max==iOUT2_max,   % Conta acerto se os dois indices coincidem
            count_OK=count_OK+1;
        end
    end
    
    % Taxa de acerto global
    Tx_OK(r)=100*(count_OK/cQ)
        
end
%===========================================================================
melhor_caso = 0;
pior_caso = inf;
%calcula matriz de confusao
if r ~= 1
        % melhor caso
        if  Tx_OK(r) >  melhor_caso
            melhor_caso = Tx_OK(r);
            for t=1:cQ,
                [T2max iT2max]=max(T2(:,t));  % Indice da saida desejada de maior valor
                [OUT2_max iOUT2_max]=max(OUT2(:,t)); % Indice do neuronio cuja saida eh a maior
                cm1(t) = iT2max;
                cm2(t) = iOUT2_max;
            end
        end
        % pior caso
        if  Tx_OK(r) <  pior_caso
            pior_caso = Tx_OK(r);
            for t=1:cQ,
                [T2max iT2max]=max(T2(:,t));  % Indice da saida desejada de maior valor
                [OUT2_max iOUT2_max]=max(OUT2(:,t)); % Indice do neuronio cuja saida eh a maior
                cp1(t) = iT2max;
                cp2(t) = iOUT2_max;
            end
        end
end
%==========================================================================    
% medidas estatisticas
media=mean(Tx_OK)
mediana=median(Tx_OK)
maxima=max(Tx_OK)
minima=min(Tx_OK)
desv_padrao=std(Tx_OK)

[Cm,orderm] = confusionmat(cm1,cm2); % Melhor caso
[Cp,orderp] = confusionmat(cp1,cp2); % Pior caso
%==========================================================================
boxplot([Tx_OK], 'Labels',{'LMS Filter'})
grid on;
%tabela com resultados
name={'Acertos'};
T = table(mediana,media,minima,maxima,desv_padrao,...
    'RowNames',name)

hold on
grid on
title('Taxa de Acerto do Mínimos Quadrados')
ylabel('Acerto')
boxplot(Tx_OK, 'Labels',{'LMS'})
hold off
