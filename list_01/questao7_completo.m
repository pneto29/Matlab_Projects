%POLYCARPO SOUZA NETO
%MESTRADO EM ENGENHARIA DE TELEINFORMÁTICA
%LISTA 1 - QUESTÃO 7
clear all;
close all;
%criando dados aleatorios
mu = [0,0];
sigma = [9 -.5;-0.5 4];
rng default  
dados = mvnrnd(mu,sigma,5000);

% calculando autovalores e autovetores
covariancia = cov(dados);
[eigenvec, eigenval ] = eig(covariancia);
% indice do maior autorvetor
[largest_eigenvec_ind_c, r] = find(eigenval == max(max(eigenval)));
maiorAutoVet = eigenvec(:, largest_eigenvec_ind_c);
% obtendo o maior autovalor
maiorAutoValor = max(max(eigenval));
% Obtenha o menor autovetor e autovalor
if(largest_eigenvec_ind_c == 1)
    menorAutoVAlor = max(eigenval(:,2));
    menorAutoVet = eigenvec(:,2);
else
    menorAutoVAlor = max(eigenval(:,1));
    menorAutoVet = eigenvec(1,:);
end
% Calcule o ângulo entre o eixo dos x e o maior autovetor
angulo = atan2(maiorAutoVet(2), maiorAutoVet(1));

% Vamos deslocá-lo de tal forma que o ângulo esteja entre 0 e 2pi
if(angulo < 0)
    angulo = angulo + 2*pi;
end

% obter as coordenadas dos dados
coord_dados = mean(dados);

%fazer variação do tamanho do X² 
%refazer para valores de porcentagem de aceitacao diferente
chisquare_val1 = sqrt(5.991);%99

theta_grid = linspace(0,2*pi);
phi = angulo;

X0=coord_dados(1);
Y0=coord_dados(2);
a1=chisquare_val1*sqrt(maiorAutoValor);
b1=chisquare_val1*sqrt(menorAutoVAlor);
% cordenadas em (x,y)
ellipse_x_r1  = a1*cos( theta_grid );
ellipse_y_r1  = b1*sin( theta_grid );
%definindo a matriz de rotacao
R = [ cos(phi) sin(phi); -sin(phi) cos(phi) ];
%Vamos rodar a elipse para algum ângulo phi
r_ellipse1 = [ellipse_x_r1;ellipse_y_r1]' * R;

% erro do elipse
plot(r_ellipse1(:,1) + X0,r_ellipse1(:,2) + Y0,'g','LineWidth',3)
hold on;
%mostrar conjunto de dados
plot(dados(:,1), dados(:,2),'.b');
mindata = min(min(dados));
maxdata = max(max(dados));
xlim([mindata-3, maxdata+3]);
grid on;
hold on;
% % mostrar autovetores
% quiver(X0, Y0, maiorAutoVet(1)*sqrt(maiorAutoValor), maiorAutoVet(2)*sqrt(maiorAutoValor), '-r', 'LineWidth',3);
% quiver(X0, Y0, menorAutoVet(1)*sqrt(menorAutoVAlor), menorAutoVet(2)*sqrt(menorAutoVAlor), '-y', 'LineWidth',3);
hold on;

% eixos do grafico
hXLabel = xlabel('X2');
hYLabel = ylabel('X3');
grid on;
coef = covariancia(1,2)/(covariancia(1,1)*covariancia(2,2));
a=covariancia(2,2)*coef/covariancia(1,1);
b=mean(dados(:,2))-a*mean(dados(:,1));
abscissa=-15:15;
ordenada=a*abscissa+b;
plot(abscissa,ordenada,'m','LineWidth',2)
title('Reta de tendência ajustada sobre conjunto de dados')
% 
% h= histogram(dados)
% xlabel('Dados')
% ylabel('Frequência')
% title('Histograma com distribuição dos dados')
