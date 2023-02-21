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
%========================================================================================================
%define a rede->arq
Ne = 200; % No. de epocas de treinamento
Nr = 100;   % No. de rodadas de treinamento/teste
No = 6;   % No. de neuronios na camada de saida
eta=0.1;   % Passo de aprendizagem

melhor_caso = 0;
pior_caso = 100;
%=======================================================================================================
for r=1:Nr,  %laço treino e teste
    
    Rodada=r,
    
    I=randperm(ColD);
    Dn=Dn(:,I);
    alvos=alvos(:,I);   % Embaralha saidas desejadas tambem p/ manter correspondencia com vetor de entrada
    
    J=floor(ptrn*ColD);
    
    % Vetores para treinamento e saidas desejadas correspondentes
    P = Dn(:,1:J); T1 = alvos(:,1:J);
    [lP cP]=size(P);   % Tamanho da matriz de vetores de treinamento
    
    % Vetores para teste e saidas desejadas correspondentes
    Q = Dn(:,J+1:end); T2 = alvos(:,J+1:end);
    [lQ cQ]=size(Q);   % Tamanho da matriz de vetores de teste
    
    % Inicia matrizes de pesos
    WW=0.1*rand(No,lP+1);   % Pesos entrada -> camada saida
    
    %%% ETAPA DE TREINAMENTO
    for t=1:Ne,
        Epoca=t;
        I=randperm(cP); P=P(:,I); T1=T1(:,I);   % Embaralha vetores de treinamento
        EQ=0;
        for tt=1:cP,   % Inicia LOOP de epocas de treinamento
            % CAMADA DE SAIDA
            X  = [-1; P(:,tt)];   % Constroi vetor de entrada com adicao da entrada x0=-1
            Ui = WW * X;          % Ativacao (net) dos neuronios de saida
            Yi = (Ui > 0);        % Saida quantizada em (0 ou 1)
            
            % CALCULO DO ERRO
            Ei = T1(:,tt) - Yi;           % erro entre a saida desejada e a saida da rede
            EQ = EQ + 0.5*sum(Ei.^2);     % soma do erro quadratico de todos os neuronios p/ VETOR DE ENTRADA
            
            WW = WW + eta*Ei*X';  % AJUSTE DOS PESOS
            
        end   % Fim de uma epoca
        
        EQM(t)=EQ/cP;  % MEDIA DO ERRO QUADRATICO POR EPOCA
    end   % Fim do loop de treinamento
    
 %================================================================================================   
    %% ETAPA DE GENERALIZACAO  %%%
    MSE2=0; HID2=[]; OUT2=[];
    for tt=1:cQ,
        % CAMADA OCULTA
        X=[-1; Q(:,tt)];      % Constroi vetor de entrada com adicao da entrada x0=-1
        Ui = WW * X;          % Ativacao (net) dos neuronios da camada oculta
        Yi = (Ui>0);          % Saida quantizada em (0 ou 1)
        OUT2=[OUT2 Yi];       % Armazena saida da rede
        
        % CALCULO DO ERRO DE GENERALIZACAO
        Ei = T2(:,tt) - Yi;
        MSE2 = MSE2 + 0.5*sum(Ei.^2);
    end
%=================================================================================================    
    %MSE teste
    MSE2(r)=MSE2/cQ;
    
 % CALCULA TAXA DE ACERTO
    %variavel contadora em 0
    %inicia os contadores das classes em 0 -> todos
    count_OK=0;  % Contador de acertos
    count_c1=0;     cQ_c1 = 0;
    count_c2=0;     cQ_c2 = 0;
    count_c3=0;     cQ_c3 = 0;
    count_c4=0;     cQ_c4 = 0;
    count_c5=0;     cQ_c5 = 0;
    count_c6=0;     cQ_c6 = 0;
    for t=1:cQ,
        [T2max iT2max]=max(T2(:,t));  % Indice da saida desejada de maior valor
        [OUT2_max iOUT2_max]=max(OUT2(:,t)); % Indice do neuronio cuja saida eh a maior
        
        % Conta quantida de cada classe
        if iT2max == 1
            cQ_c1=cQ_c1+1;
        elseif iT2max == 2
            cQ_c2=cQ_c2+1;
        elseif iT2max == 3
            cQ_c3=cQ_c3+1;
        elseif iT2max == 4
            cQ_c4=cQ_c4+1;
        elseif iT2max == 5
            cQ_c5=cQ_c5+1;
        elseif iT2max == 6
            cQ_c6=cQ_c6+1;
        end
        if iT2max==iOUT2_max,   % Conta acerto se os dois indices coincidem
            count_OK=count_OK+1;
            
            %%Taxa de acerto por classe
            if iT2max == 1
                count_c1 = count_c1+1;
            elseif iT2max == 2
                count_c2 = count_c2+1;
            elseif iT2max == 3
                count_c3 = count_c3+1;
            elseif iT2max == 4
                count_c4 = count_c4+1;
            elseif iT2max == 5
                count_c5 = count_c5+1;
            elseif iT2max == 6
                count_c6 = count_c6+1;
            end
        end
    end
    
   %================================================================================================= 
    % Taxa de acerto global
    Tx_OK(r)=100*(count_OK/cQ);
    
    % Matriz
    if r ~= 1
        % melhor caso
        if  Tx_OK(r) >  melhor_caso
            melhor_caso = Tx_OK(r);
            for t=1:cQ,
                [T2max iT2max]=max(T2(:,t));  % Indice da saida desejada de maior valor
                [OUT2_max iOUT2_max]=max(OUT2(:,t)); % Indice do neuronio cuja saida eh a maior
                gm1(t) = iT2max;
                gm2(t) = iOUT2_max;
            end
        end
        % pior caso
        if  Tx_OK(r) <  pior_caso
            pior_caso = Tx_OK(r);
            for t=1:cQ,
                [T2max iT2max]=max(T2(:,t));  % Indice da saida desejada de maior valor
                [OUT2_max iOUT2_max]=max(OUT2(:,t)); % Indice do neuronio cuja saida eh a maior
                gp1(t) = iT2max;
                gp2(t) = iOUT2_max;
            end
        end
    end
    
    Tx_c1(r)=100*(count_c1/cQ_c1);
    Tx_c2(r)=100*(count_c2/cQ_c2);
    Tx_c3(r)=100*(count_c3/cQ_c3);
    Tx_c4(r)=100*(count_c4/cQ_c4);
    Tx_c5(r)=100*(count_c5/cQ_c5);
    Tx_c6(r)=100*(count_c6/cQ_c6);
    if (cQ_c1 == 0)
        Tx_c1(r) = 0;
    elseif(cQ_c2 == 0)
        Tx_c2(r) = 0;
    elseif(cQ_c3 == 0)
        Tx_c3(r) = 0;
    elseif(cQ_c4 == 0)
        Tx_c4(r) = 0;
    elseif(cQ_c5 == 0)
        Tx_c5(r) = 0;
    elseif(cQ_c6 == 0)
        Tx_c6(r) = 0;
    end
    
    
end % FIM DO LOOP DE RODADAS TREINO/TESTE

media=mean(Tx_OK),   % Taxa media de acerto global
minima=min(Tx_OK),   % Taxa de acerto minima
maxima=max(Tx_OK),   % Taxa de acerto maxima
desv_padrao=std(Tx_OK),      % Desvio padrao da taxa media de acerto
mediana=median(Tx_OK),   % Mediana
media_c1=mean(Tx_c1),   % Taxa media de acerto classe 1
media_c2=mean(Tx_c2),   % Taxa media de acerto classe 2
media_c3=mean(Tx_c3),   % Taxa media de acerto classe 3
media_c4=mean(Tx_c4),   % Taxa media de acerto classe 4
media_c5=mean(Tx_c5),   % Taxa media de acerto classe 5
media_c6=mean(Tx_c6),   % Taxa media de acerto classe 6
% 
% rodadas = 1:Nr;
% figure (1);
% stem(rodadas, Tx_OK, 'm', 'linewidth', 2);
% xlabel('Nº de rodadas');
% ylabel('Acerto');
% title('Percepton simples')
% 
% figure(2);
% stem(rodadas, MSE2, 'b', 'linewidth', 2);
% xlabel('Nº de rodadas');
% ylabel('MSE');
% title('Percepton simples')
% legend('DAdos teste')
% 
% 
% % Plota Curva de Aprendizagem
% figure(3)
% plot(EQM,'g', 'linewidth', 4)
% xlabel('Nº epocas')
% ylabel('Erro')
% title('Aprendizagem do Percepton simples');

[Cm,orderm] = confusionmat(gm1,gm2); % Melhor caso
[Cp,orderp] = confusionmat(gp1,gp2); % Pior caso

namec={'Classes'};
TC = table(media_c1,media_c2,media_c3,media_c4,media_c5,media_c6,...
    'RowNames',namec)
name={'Acertos'};
T = table(mediana,media,minima,maxima,desv_padrao,...
    'RowNames',name)
hold on
grid on
title('Taxa de Acerto do Perceton Simples')
ylabel('Acerto')
boxplot(Tx_OK, 'Labels',{'PS - RNA'})
hold off
