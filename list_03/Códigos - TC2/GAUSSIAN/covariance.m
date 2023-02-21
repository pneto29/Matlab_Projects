function [COV] = covariance(DATA)
[p,N]=size(DATA);
%media do transposto dos dados
m=mean(DATA')';
%estima matriz de correlação geral
Rx_est=(1/N)*DATA*DATA';
% " covariancia
COV.C_est=Rx_est-(m*m');
%teste com pinv
COV.inv=pinv(COV.C_est);
end

