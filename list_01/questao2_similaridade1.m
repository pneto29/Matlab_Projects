x=[50]; y=[-50:x];
gama=0.5;
g=zeros(2,length(y));
for i=1:length(y)
g(1,i)=exp(-gama*((x-y(i))'*(x-y(i)))); % funcao 1
g(2,i)=1/(1+((x-y(i))'*(x-y(i)))); % funcao 2
end
% figure(1)
% subplot(1,2,1)
% plot(y,g(1,:),'-r', 'LineWidth',2);
% xlabel('Resposta da funcao');
% ylabel('Variacao de y');
% title('Função 1')
% grid on
% subplot(1,2,2)
% plot(y,g(2,:),'-r', 'LineWidth',2);
% xlabel('Resposta da funcao');
% ylabel('Variacao de y');
% title('Função 2')
% grid on
% figure(2), hold on, 
% plot(y,g(1,:),'-b', 'LineWidth',2);
% plot(y,g(2,:),'--r', 'LineWidth',2);
% xlabel('Resposta da funcao');
% ylabel('Variacao de y');
% title('Merged com as duas curvas')
% legend('g1(x,y) p/ \gamma=0.5','g2(x,y)')
% grid on
% hold off
