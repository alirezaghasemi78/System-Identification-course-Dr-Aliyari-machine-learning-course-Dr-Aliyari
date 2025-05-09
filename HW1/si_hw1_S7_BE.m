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
% y=data(:,nn);
% y_train=y(1:len_train,1);
% y_test=y(len_train+1:end,1);
% 
% X=[u.^0 u.^1 u.^2 u.^3 u.^4 u.^5 u.^6 u.^7 u.^8 u.^9];
% U_trn=X(1:len_train,:);
% U_tst=X(len_train+1:end,:);

N_trn = round(size(u,1)*0.75); %% size(u,1) = N_data_inpackage
N_tst = size(u,1) - N_trn;  
data_trn=u(1:N_trn,:);
data_tst=u(N_trn+1:end,:);
data_tst=sort(data_tst);

y_train=-1.5 -0.8*(data_trn) + 0.1 *(data_trn.^3) - 0.65*(data_trn.^5) + 2.25*(data_trn.^6) - 1.7*(data_trn.^8);
y_test=-1.5 -0.8*(data_tst ) + 0.1 *(data_tst .^3) - 0.65*(data_tst .^5) + 2.25*(data_tst .^6) - 1.7*(data_tst .^8);

U_trn=[data_trn.^0 data_trn data_trn.^2 data_trn.^3 data_trn.^4 data_trn.^5 data_trn.^6 data_trn.^7 data_trn.^8 data_trn.^9];
U_tst=[data_tst.^0 data_tst data_tst.^2 data_tst.^3 data_tst.^4 data_tst.^5 data_tst.^6 data_tst.^7 data_tst.^8 data_tst.^9];
%%
n=10;
v1=U_trn;
V=zeros(len_train,n);
for i=1:n
    v_eta(i,1)=v1(:,i)'*y_train/norm(v1(:,i),2)^2;
    error(i,1)=v_eta(i,1)^2*norm(v1(:,i),2)^2;
end
[C(1),index(1)]=max(error);
V(:,1)=U_trn(:,index(1));
%%
selectedReg_BE(1,1)=index(1);
for k=2:n
    clear v1 v_eta error
    for i=1:n
        p=0;
        for m=1:size(selectedReg_BE,1)
            if i==selectedReg_BE(m,1)
                p=1;
            end
        end
        if p==0
            for j=1:k-1
                alfa(j,k,i)=V(:,j)'*U_trn(:,i)/(V(:,j)'*V(:,j));
            end
            sum=0;
            for j=1:k-1
                sum=sum+alfa(j,k,i)*V(:,j);
            end
            v1(:,k,i)=U_trn(:,i)-sum;
            v_eta(k,1,i)=v1(:,k,i)'*y_train/(v1(:,k,i)'*v1(:,k,i));
            error(i,1)=(v_eta(k,1,i)^2*(v1(:,k,i)'*v1(:,k,i)));
        end
    end
    [C(k),index(k)]=max(error(:,1));
    selectedReg_BE(k,1)=index(k);
    V(:,k)=v1(:,k,index(k));
end
disp(selectedReg_BE-1)
%% Orthogonal
R=(V'*V)^(-1)*V'*U_trn;
Vtest=U_tst*R^(-1);
%%
for i=1:n
    clear V_Selected
    for j=1:i
        V_Selected(:,j)=V(:,j);
        V_SelectedTest(:,j)=Vtest(:,j);
    end
    %%
    v_etaHat=(V_Selected'*V_Selected)^(-1)*V_Selected'*y_train;
    y_Hat=V_Selected*v_etaHat;
    yHatTest=V_SelectedTest*v_etaHat;
    outputError(i,1)=(y_train-y_Hat)'*(y_train-y_Hat);
    outputErrorTest(i,1)=(y_test-yHatTest)'*(y_test-yHatTest);
end
reg=[1:n];
for k=1:n-1
    clear U_trn uSelected theta J_trn
    removeCounter=n-k+1;
    for i=1:n-k+1
        selectorCounter=1;
        for j=1:n-k+1
            if j~=removeCounter
                uSelected(i,selectorCounter)=reg(1,j);
                selectorCounter = selectorCounter + 1;
            end
        end
        removeCounter=removeCounter-1;
    end
    %% U_train
    for i=1:n-k+1
        for j=1:n-k
            U_trn(:,j,i)=V(:,uSelected(i,j));
        end
    end
    %% theta
    for i=1:n-k+1
        theta(:,1,i) = (U_trn(:,:,i)'*U_trn(:,:,i))^(-1)*U_trn(:,:,i)'*y_train;
    end
    %% Y_Hat
    for i=1:n-k+1
        y_Hat(:,i) = U_trn(:,:,i)*theta(:,i);
    end
    %% CostFunction train
    for i=1:n-k+1
        J_trn(i,1)=(y_train - y_Hat(:,i))'*(y_train - y_Hat(:,i));
    end
    [D(k),index(k)]=min(J_trn);
    p=0;
    for m=1:n-k
        if reg(1,m)~= uSelected(index(k),m)
            p=1;
            a=m;
            break;
        end
    end
    if p==0
        a=n-k+1;
    end
    reg(:,a)=[];
end
%% Plots
plot(1:n-1,D(n-1:-1:1),'*-','Linewidth',2.5),grid on,grid minor
saveas(gcf,'HW1_2_q3_OLS_BE.png');