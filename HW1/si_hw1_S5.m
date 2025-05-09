clc,clear all,close all;
rng(40)
%% noise choosing 
nn=3;
if nn==1
    noise='without noise'
    elseif nn==2
        noise='Low noise'
    elseif nn==3
        noise='Medium noise'
    elseif nn==4
        noise='High noise'
end
%% Load data
load('data');
len_train=750;
u=data(:,5);
utest=u(len_train+1:end,1);
%%
y=data(:,nn);
y_train=y(1:len_train,1);
y_test=y(len_train+1:end,1);

X=[u.^0 u.^1 u.^3 u.^5 u.^6 u.^8];
x_train=X(1:len_train,:);
x_test=X(len_train+1:end,:);

%% initialize
n=size(X,2);
a=1e2;
P=a*eye(n);
tetta(:,1)=zeros(n,1);
%% RLS algorithm
for k=1:size(x_train,1)
    gama=(P*x_train(k,:)')/(1+x_train(k,:)*P*x_train(k,:)');
    P_new=P-(gama*x_train(k,:)*P);

    tetta(:,k+1)=tetta(:,k)+gama*(y_train(k,:)-x_train(k,:)*tetta(:,k));
    P=P_new;
    P_eig(:,k)=eig(P_new);
end
%% Test
y_hat_test=x_test*tetta(:,end);
e=y_test-y_hat_test;
display(mse(e),'Mean squared normalized error ')
%% Plot Estimation & Real
figure();
plot(utest,y_hat_test,'r*');
hold on
plot(utest,y_test,'bo');
legend('Estimated','Real');
grid on;
xlabel('input');
ylabel('output');
saveas(gcf,'estimated_and_real.png')

%%  Plots for tetta & P

tetareal=[-1.5 -0.8 0.1 -0.65 2.25 -1.7]';

figure();
for i=1:6
    subplot(2,3,i)
    plot(tetta(i,:),'linewidth',2);
    hold on
    plot(tetareal(i)*ones(1,size(tetta,2)),'linewidth',2);
    a=strcat('teta hat',num2str(i));
    legend('estimated','real')
    ylabel(a)
    grid on
end
saveas(gcf,'estimated_and_real_teta_hat.png')
figure();
for i=1:6
    subplot(2,3,i)
    plot(P_eig(i,:),'linewidth',2);
    a=strcat('Peig',num2str(i));
    legend('estimated')
    ylabel(a)
    grid on
end
saveas(gcf,'P_eig.png')