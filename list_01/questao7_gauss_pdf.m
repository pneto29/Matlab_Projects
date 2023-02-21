mu = [0 0];
Sigma = [9 -.5;-0.5 4];
x1 = -8:.2:8; x2 = -8:.2:8;
[X1,X2] = meshgrid(x1,x2);
F = mvnpdf([X1(:) X2(:)],mu,Sigma);
F = reshape(F,length(x2),length(x1));
surf(x1,x2,F);%superficie
caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
xlabel('X2'); ylabel('X3'); zlabel('Densidade de probabilidade');