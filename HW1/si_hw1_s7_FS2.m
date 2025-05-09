clc;clear all;close all;
%% noise choosing
nn=1;
if nn==1
    noise='without noise'
    elseif nn==2
        noise='Low_noise'
    elseif nn==3
        noise='Medium noise'
    elseif nn==4
        noise='Medium noise'
end
%% Load data
load ('data')
len_train=750;
u=data(:,5);
y=data(:,nn);
y_train=y(1:len_train,1);
y_test=y(len_train+1:end,1);

X=[u.^0 u.^1 u.^2 u.^3 u.^4 u.^5 u.^6 u.^7 u.^8 u.^9];
U_trn=X(1:len_train,:);
U_tst=X(len_train+1:end,:);

%% algorithm
n=10;
v1=U_trn;
V=zeros(len_train,n);
for i=1:n
    veta(i,1)=v1(:,i)'*y_train/norm(v1(:,i),2)^2;
    error(i,1)=(veta(i,1)^2)*norm(v1(:,i),2)^2;
end
error;
[C(1),index(1)]=max(error);
V(:,1)=U_trn(:,index(1));
selectedReg_FS(1,1)=index(1);
%%
for k=2:n
    clear v1 veta error
    for i=1:n
        p=0;
        for m=1:size(selectedReg_FS,1)
            if i==selectedReg_FS(m,1)
                p=1;
            end
        end
        if p==0
            for j=1:k-1
                r(j,k,i)=V(:,j)'*U_trn(:,i)/norm(V(:,j),2)^2;
            end
            sum=0;
            for j=1:k-1
                sum=sum+r(j,k,i)*V(:,j);
            end
            v1(:,k,i)=U_trn(:,i)-sum;
            veta(k,1,i)=v1(:,k,i)'*y_train/norm(v1(:,k,i),2)^2;
            error(i,1)=(veta(k,1,i)^2)*norm(v1(:,k,i),2)^2;
        end
    end
    error;
    [C(k),index(k)]=max(error(:,1));
    selectedReg_FS(k,1)=index(k);
    V(:,k)=v1(:,k,index(k));
end
display(selectedReg_FS-1)
%% Orthogonal
R=(V'*V)^(-1)*V'*U_trn;
Vtest=U_tst*R^(-1);
%% 
for i=1:n
    clear vSelected
    for j=1:i
        v_Selected(:,j)=V(:,j);
        vSelectedTest(:,j)=Vtest(:,j);
    end
    %%
    v_eta_Hat=(v_Selected'*v_Selected)^(-1)*v_Selected'*y_train;
    yHat=v_Selected*v_eta_Hat;
    yHat_Test=vSelectedTest*v_eta_Hat;
    outputError(i,1)=norm((y_train-yHat),2)^2;
    outputErrorTest(i,1)=norm((y_test-yHat_Test),2)^2;
end
run=1;
index=zeros(n,1);
J_tst=zeros(n,1,n);
J_trn=zeros(n,1,n);
clear yHatTest
for j=1:n
    clear uSelected U_trn theta U_tst
    reg=zeros(1,n-j+1);
    indexes=1;
    for k=1:n
        p=0;
        for m=1:j
            if k==index(m)
                p=1;
            end
        end
        if p==0
            reg(1,indexes)=k;
            indexes=indexes+1;
        end
    end
    indexes=indexes-1;
    theta=zeros(j,1,n-j+1);
    yHat_Test=zeros(250,1,n-j+1);
    yHatTrain=zeros(750,1,n-j+1);
    %%
    for k=1:indexes
        for m=1:j
            if run
                uSelected(k,:)=sort(reg(k));
            else
                uSelected(k,:)=sort([index(1:j-1)' reg(k)]);
            end
        end
    end
    for k=1:size(uSelected,1)
        for m=1:size(uSelected,2)
            U_trn(:,m,k) =  V(:,uSelected(k,m));
            U_tst(:,m,k) = Vtest(:,uSelected(k,m));
        end
    end
    %% theta
    for i=1:n-j+1
        theta(:,1,i)=(U_trn(:,:,i)'*U_trn(:,:,i))^(-1)*U_trn(:,:,i)'*y_train;
    end
    %% CostFuncton test
    for i=1:n-j+1
        yHat_Test(:,1,i)=U_tst(:,:,i)*theta(:,1,i);
    end
    for i=1:n-j+1
        J_tst(i,1,j)=0.5*norm((y_test - yHat_Test(:,1,i)),2)^2;
    end
    %% CostFuncton train
    for i=1:n-j+1
        yHatTrain(:,1,i)=U_trn(:,:,i)*theta(:,1,i);
    end
    for i=1:n-j+1
        J_trn(i,1,j)=0.5*norm((y_train - yHatTrain(:,1,i)),2)^2;
    end
    [D(j),index(j)]=min(J_trn(1:n-j+1,j));
    D_test_min(j)=min(J_tst(1:n-j+1,j));
    index(j)=reg(index(j));
    run=0;
end
disp(index-1)
%% Plots
plot(1:n,D_test_min,'*-','Linewidth',2.5),grid on,grid minor