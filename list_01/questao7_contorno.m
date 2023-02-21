mu = [0 0];
Sigma = [9 -.5;-0.5 4];
rng default  
dados = mvnrnd(mu,Sigma,5000);%multivariada
x1 = -12:.5:12; x2 = -8:.5:8; %axis
[X1,X2] = meshgrid(x1,x2);
F = mvnpdf([X1(:) X2(:)],mu,Sigma);
F = reshape(F,length(x2),length(x1));
hold on
mvncdf([0 0],[1 1],mu,Sigma);
%curvas de contorno
contour(x1,x2,F,[.0001 .001 .01 .05:0.0001:.95 .99 .999 .9999],'LineWidth',3);
plot(dados(:,1), dados(:,2),'.c');%plot dos dads
mindata = min(min(dados));
maxdata = max(max(dados));
title('Curvas de contorno')
xlabel('x'); ylabel('y');
grid on