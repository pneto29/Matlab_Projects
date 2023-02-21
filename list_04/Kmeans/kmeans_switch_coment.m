function [result,distance] = kmeans_switch_coment(dataset,i)
%sequencial
% k=i;
% if k==1
%     result.index=ones(dataset.all_instance,1);
%     m=mean(dataset.dados');
%     result.C=m';
%     distance=0;
% else
%    
%     %inicializa protótios
%     shuffle=randperm(dataset.all_instance);
%     m=dataset.dados(:,shuffle(1:k));
%     m_past=inf*ones(dataset.p,k);
%     index=zeros(dataset.all_instance,1);
%     C_better=zeros(1,k);
%batch
k=i;
shuffle=randperm(dataset.all_instance);
m=dataset.dados(:,shuffle(1:k));
m_past=inf*ones(dataset.p,k);
index=zeros(dataset.all_instance,1);
while m~=m_past
   %atualiza particoes
    for n=1:dataset.all_instance
       distance=zeros(1,k);
        for j=1:k
           distance(j)=(m(:,j)-dataset.dados(:,n))'*(m(:,j)-dataset.dados(:,n));
        end
       [~,index(n)]=min(distance);
       %C_better(index(n))=C_better(index(n))+1;
    end 
 %atualiza prototipos
    m_past=m;
    %alpha=1/C_better(index(n));
%      m(:,index(n))=((1-alpha)*m_past(:,index(n)))+(alpha*dataset.dados(:,n));
%           %vê se converge
%             if(m==m_past)
%                 n=dataset.all_instance;
%             end
%         end           
    for cluster=1:k
        locus=find(index==cluster);
        clusters=dataset.dados(:,locus);
        m(:,cluster)=mean(clusters');
    end
end
result.index=index;
result.C=m;
