%metodo usando alpha
x1=[1 2]'; %vetor 1
x2=[-1 3]'; %vetor 2
x3=[1 -1]'; %vetor 3
S=[x1 x2 x3]; %concatenacao dos vetores que formam a matriz
M=sum(S)/length(S);
CorE=M*M';
N=length(S);
tic
for n=2:N,
a=(n-1)/n;
CorE=a*CorE+(1-a)*S(:,n)*S(:,n)';
M=(1-a)*S(:,n)';
end
Cx4=CorE-M*M'
toc