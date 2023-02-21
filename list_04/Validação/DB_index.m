function [DB] = DB_index(dataset,PAR)
dataset = dataset.dados;

labels = PAR.index;
centroids = PAR.C;
[~,k] = size(centroids);

clusters = cell(1,k);
for l=1:k,
    J=find(labels==l);
    VJ=dataset(:,J);
    clusters{l}=VJ;
end


%% ALGORITHM

if k==1,
    DB = NaN;
else
    DB = 0; %this value will accumalate
    %find standard deviation of each cluster
    sigma=zeros(1,k);
    for l=1:k
        %Find distance of objects at each cluster to its centroid
        [~,qtd] = size(clusters{l});
        centroid=centroids(:,l);
        dispersion=zeros(1,qtd);
        for samplePosition=1:qtd
            sample=clusters{l}(:,samplePosition);
            dispersion(samplePosition)=sum((centroid-sample).^2);
        end
        %Find sigma
        sigma(l) = sqrt(sum(dispersion)/qtd);       
    end
       
    %Find max((sigma_k+sigma_l/d_kl))
    for l=1:k
        aux_value = zeros(1,k);
        centroid_l=centroids(:,l);
        % aux_value = zeros(1,...);
        for m=1:k
            if m~=l
                centroid_m = centroids(:,m);
                d_kl =  sqrt(sum((centroid_l-centroid_m).^2));
                aux_value(m) = (sigma(l)+sigma(m))/d_kl;
                %aux_value = [aux_value ((sigma{l}+sigma{m})/d_kl)];
            end
        end
        %Find DB index
        DB = DB +(max(aux_value))/k;
    end
end
%% END