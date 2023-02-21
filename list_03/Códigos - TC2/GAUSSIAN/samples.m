function [separate_class,all_labels] = samples(DATA,LABEL)
labels=LABEL;
%retorna os mesmos dados que em DATA, 
%mas sem repetições. 
v_labels=unique(labels);
all_labels=length(v_labels);
%separa pr classe
separate_class=cell(1,all_labels);

for i=1:all_labels
    index=find(labels==v_labels(i));
    separate_class{i}=DATA(:,index);
end
end

