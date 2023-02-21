function [DUNN] = DUNN_index(dataset,VAR)

dataset = dataset.dados;
labels = VAR.index;
cent = VAR.C;
[~,k] = size(cent);

clusters = cell(1,k);
group_separate_QTF = zeros(1,k);
for l=1:k,
    J=find(labels==l);
    VJ=dataset(:,J);
    clusters{l}=VJ;
    group_separate_QTF(l) = length(J);
end

% if k==1,
%     DUNN = NaN;
% else
    %Find centroids combination
    centroidsCombination = combvec(1:k,1:k);
    comb_aux = centroidsCombination(1,:)-centroidsCombination(2,:);
    comb_aux = find(comb_aux~=0);
    comb_qtd = length(comb_aux);
    centroidsCombination_aux = zeros(2,comb_qtd);
     for i=1:comb_qtd
         centroidsCombination_aux(:,i) = centroidsCombination(:,comb_aux(i));
     end
    centroidsCombination = centroidsCombination_aux;
    
    num=inf; %pra pegar o min comeca em inf
    [~,comb_qtd] = size(centroidsCombination);
    for i=1:comb_qtd
        %encontrar o menor(Sigma(Si,Sj))
        %(Sigma(Si,Sj))->medida de dissimilaridade
        for j=1:group_separate_QTF(centroidsCombination(1,i))
            S_i = clusters{centroidsCombination(1,i)}(:,j);
            for l=1:group_separate_QTF(centroidsCombination(2,i))
                S_j = clusters{centroidsCombination(2,i)}(:,l);
                deltaSiSj = sqrt(sum((S_i-S_j).^2));
                if deltaSiSj<num
                    num = deltaSiSj;
                end
            end 
        end
    end
    
    den=0;
    for i=1:k
        for l=1:group_separate_QTF(i)
            x = clusters{i}(:,l);
            for m=1:group_separate_QTF(i)
                if m~=l
                    y = clusters{i}(:,m);
                    Sl = sqrt(sum((x-y).^2));
                    if Sl>den
                        den = Sl;
                    end
                end
            end
        end
    end
           
   %Find DUN index
    DUNN = num/den;
% end
