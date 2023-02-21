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
[LinD ColD]=size('derm_input');
[LinT ColT]=size('derm_target');
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
%arquitetura
Ne = 200; % No. de epocas de treinamento
Nr = 100;   % No. de rodadas de treinamento/teste
Nh = 10; % No. de neuronios na camada oculta
No = 6;   % No. de neuronios na camada de saida

etai=0.1;   % Passo de aprendizagem inicial
etaf=0.01;  % Passo de aprendizagem final
moment=0.0;    % Fator de momento

tam_conj_treinamento = floor(ptrn*ColD)*Ne;% tam comjunto treianmento

eta=etai;   % Passo de aprendizagem inical a ser rodado

melhor_caso = 0;
pior_caso = 100;
%==================================================================================
for r=1:Nr,  % LOOP de rodadas de treinamento/teste
    
    rodada=r,
    
    I=randperm(ColD); 
    Dn=Dn(:,I); 
    alvos=alvos(:,I);   % Embaralha pares entrada/saida 
        
    % Vetores para treinamento e saidas desejadas correspondentes
    J=floor(ptrn*ColD);
    P = Dn(:,1:J); T1 = alvos(:,1:J);
    [lP cP]=size(P);   % Tamanho da matriz de vetores de treinamento
    
    % Vetores para teste e saidas desejadas correspondentes
    Q = Dn(:,J+1:end); T2 = alvos(:,J+1:end);
    [lQ cQ]=size(Q);   % Tamanho da matriz de vetores de teste
     
    % Inicia matrizes de pesos
    WW=0.01*rand(Nh,lP+1);   % Pesos entrada -> camada oculta
    WW_old=WW;              % Necessario para termo de momento
    
    MM=0.01*rand(No,Nh+1);   % Pesos camada oculta -> camada de saida
    MM_old = MM;            % Necessario para termo de momento
    
 %============================================================================
    for t=1:Ne,
        
        Epoca=t;
        
        I=randperm(cP); P=P(:,I); T1=T1(:,I);   % Embaralha vetores de treinamento e saidas desejadas
        
        EQ=0;
        for tt=1:cP,   % Inicia LOOP de epocas de treinamento
            % CAMADA OCULTA
            X=[-1; P(:,tt)];      % Constroi vetor de entrada com adicao da entrada x0=-1
            Ui = WW * X;          % Ativacao (net) dos neuronios da camada oculta
            Yi = 1./(1+exp(-Ui)); % Saida entre [0,1] (funcao logistica)
            
            % CAMADA DE SAIDA
            Y=[-1; Yi];           % Constroi vetor de entrada DESTA CAMADA com adicao da entrada y0=-1
            Uk = MM * Y;          % Ativacao (net) dos neuronios da camada de saida
            Ok = 1./(1+exp(-Uk)); % Saida entre [0,1] (funcao logistica)
            
            % CALCULO DO ERRO
            Ek = T1(:,tt) - Ok;           % erro entre a saida desejada e a saida da rede
            EQ = EQ + 0.5*sum(Ek.^2);     % soma do erro quadratico de todos os neuronios p/ VETOR DE ENTRADA
            
            %%% CALCULO DOS GRADIENTES LOCAIS
            Dk = Ok.*(1 - Ok) + 0.05;  % derivada da sicmoide logistica (camada de saida)
            DDk = Ek.*Dk;       % gradiente local (camada de saida)
            
            Di = Yi.*(1 - Yi) + 0.05; % derivada da sicmoide logistica (camada oculta)
            DDi = Di.*(MM(:,2:end)'*DDk);    % gradiente local (camada oculta)
            
            % AJUSTE DOS PESOS - CAMADA DE SAIDA
            MM_aux=MM;
            MM = MM + eta*DDk*Y' + moment*(MM - MM_old);
            MM_old=MM_aux;
            
            % AJUSTE DOS PESOS - CAMADA OCULTA
            WW_aux=WW;
            WW = WW + eta*DDi*X' + moment*(WW - WW_old);
            WW_old=WW_aux;
        end   % Fim de uma epoca
        
        % MEDIA DO ERRO QUADRATICO P/ EPOCA
        EQM(t)=EQ/cP;
        
        % Passo de aprendizagem variavel
        eta = etai*(1-(t/tam_conj_treinamento));
        if eta < etaf
            eta = etaf;
        end
    end   % Fim do loop de treinamento
    %=============================================================================
  %generalizacao
    EQ2=0;
    OUT2=[];
    for tt=1:cQ,
        % CAMADA OCULTA
        X=[-1; Q(:,tt)];      % Constroi vetor de entrada com adicao da entrada x0=-1
        Ui = WW * X;          % Ativacao (net) dos neuronios da camada oculta
        Yi = 1./(1+exp(-Ui)); % Saida entre [0,1] (funcao logistica)
        
        % CAMADA DE SAIDA
        Y=[-1; Yi];           % Constroi vetor de entrada DESTA CAMADA com adicao da entrada y0=-1
        Uk = MM * Y;          % Ativacao (net) dos neuronios da camada de saida
        Ok = 1./(1+exp(-Uk)); % Saida entre [0,1] (funcao logistica)
        OUT2=[OUT2 Ok];       % Armazena saida da rede
        
        % Gradiente local da camada de saida
        Ek = T2(:,tt) - Ok;   % erro entre a saida desejada e a saida da rede
        Dk = Ok.*(1 - Ok);    % derivada da sicmoide logistica
        DDk = Ek.*Dk;         % gradiente local igual ao erro x derivada da funcao de ativacao
        
        % ERRO QUADRATICO GLOBAL (todos os neuronios) POR VETOR DE ENTRADA
        EQ2 = EQ2 + 0.5*sum(Ek.^2);
        
        % Gradiente local da camada oculta
        Di = Yi.*(1 - Yi); % derivada da sicmoide logistica
        DDi = Di.*(MM(:,2:end)'*DDk);
    end
    
    % MEDIA DO ERRO QUADRATICO COM REDE TREINADA (USANDO DADOS DE TREINAMENTO)
    MSE2(r)=EQ2/cQ;
   
    
 %=================================================================================   
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
          %%calcual acerto de c1 a c6
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
    
%=== ===========================================================================    
   
    % Taxa de acerto global
    Tx_OK(r)=100*(count_OK/cQ);
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
    
    %calcula pra depois plotar
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
        
end
%=========================================================================
% Estatisticas Descritivas
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

%=========================================================================
%plot dos resultados
%matriz de confusao ajeitaar
%para ver a matriz resultaante tem que usar a variavel Cm e Cp no console e
% da ENTER
% rodadas = 1:Nr;
% figure (1);
% stem(rodadas, Tx_OK, 'm', 'linewidth', 2);
% xlabel('Nº de rodadas');
% ylabel('Acerto');
% title('Percepton multicamadas')
% %axis('tight');


[Cm,orderm] = confusionmat(cm1,cm2); % Melhor caso
[Cp,orderp] = confusionmat(cp1,cp2); % Pior caso
% figure(3)
% plotconfusion(cm2,cm1)
% figure(4)
% plotconfusion(cp2,cp1)
% 
% figure (5); 
% plot(EQM,'g', 'linewidth', 4)
% xlabel('Epocas')
% ylabel('Erro')
% title('Aprendizagem da MLP');

figure(6)
hold on
boxplot(Tx_OK, 'Labels',{'MLP - RNA'})
grid on
title('Taxa de Acerto do MLP')
ylabel('Acerto')
hold off
