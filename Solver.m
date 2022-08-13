clc
clear
% % Read the network file
[Rs, text, everything] = xlsread('Connections.xlsx','R');
PQC = xlsread('Connections.xlsx','PQC');
H=90;
n=size(unique(Rs(:,[1 2])),1);

nodes=1:n;
R=zeros(n);
p=nan*(1:n);
q=nan*(1:n);
c=nan*(1:n);

for ic1=1:size(Rs,1)
    if isnan(Rs(ic1,3))
        st=text{ic1+1,4};
        L=str2double(st(1:end-2))*654.7;
        R(Rs(ic1,1),Rs(ic1,2))=resist(L,40,H); %write a function that calculates the resistence!!
    else
        L=Rs(ic1,3);
        W=Rs(ic1,4);
        R(Rs(ic1,1),Rs(ic1,2))=resist(L,W,H);
    end
end
for ic2=1:size(PQC,1)
    p(PQC(ic2,1))=PQC(ic2,2);
    q(PQC(ic2,1))=PQC(ic2,3);
    c(PQC(ic2,1))=PQC(ic2,4);
end

% q(45)=11*35;

connections= R>0;
connections=triu(connections)+triu(connections,1)';
eqns=nchoosek(n,2);
coefs=zeros(eqns+n);
b=zeros(eqns+n,1);
tt=zeros(eqns,3);
ic=0;
for i=1:n
    for j=i+1:n
        ic=ic+1;
        tt(-1/2*i^2+(n+1/2)*i-n+j-i,1)=i*10+j;
        tt(-1/2*i^2+(n+1/2)*i-n+j-i,2)=i;
        tt(-1/2*i^2+(n+1/2)*i-n+j-i,3)=j;
        if R(i,j)~=0
            coefs(ic,ic)=-R(i,j);
            coefs(ic,eqns+i)=1;
            coefs(ic,eqns+j)=-1;
        else
            coefs(ic,ic)=1;
        end
    end
end

for i=1:n
    if ~isnan(p(i))
        ic=ic+1;
        coefs(ic,eqns+i)=1;
        b(ic)=p(i);
    else        
        ic=ic+1;
        for j=(1:n).*connections(i,:)
            if j~=0
                ii=max(i,j);
                jj=min(i,j);
                coefs(ic,-1/2*jj^2+(n+1/2)*jj-n+ii-jj)=1*(i>j)-(i<j);
            end
        end
        if ~isnan(q(i))
            b(ic)=-q(i);
        end
    end
end
Ans=coefs\b;
Q=Ans(1:eqns);



C=nan*zeros(n,1);
for i=1:n
    if ~isnan(c(i))
        C(i)=c(i);
    end
end

while sum(isnan(C))>0
    sum(isnan(C))
for i=1:n
    J=find(connections(i,:));
    I=i*ones(size(J));
    II=I;JJ=J;
    II(I>J)=J(I>J);
    JJ(J<I)=I(J<I);
    ix=-1/2*II.^2+(n+1/2).*II-n+JJ-II;
    A=Q(ix)'.*sign(I-J).*C(J)';
    B=Q(ix)'.*sign(I-J);
    if size(A>=0,2)>1 && isnan(c(i))
        C(i)=sum(A(B>=0))./sum(B(B>=0));
    end
end
end

for i=1:n
    if ~isnan(c(i))
        C(i)=c(i);
    end
end

tt( ~any(Q,2), : ) = [];
Q( ~any(Q,2), : ) = [];
T1=table(Q,tt,'VariableNames',["flow rates","Branch"]);
disp(T1)

P=Ans(eqns+1:end);
T2=table((1:n)',P,C,'VariableNames',["Node","pressure","concentration"]);
disp(T2)
disp('Hello')