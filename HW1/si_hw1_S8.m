clc
clear all
close all
%%
load ('data')
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
u=data(:,5);
len_train=750;
%%
y=data(:,nn);
y_train=y(1:len_train,1);
y_test=y(len_train+1:end,1);

X=[u.^0 u.^1 u.^2 u.^3 u.^4 u.^5 u.^6 u.^7 u.^8 u.^9];
x_train=X(1:len_train,:);
x_test=X(len_train+1:end,:);

%% Least Square
i=1;
for k=0:1e-8:1e-6
    alpha(i)=k;
    %alpha(i)=exp(-(k));
    Tetha(:,i)=inv(x_train'*x_train+  alpha(i)*eye(10)  )*x_train'*y_train;
    TrainYhat=x_train*Tetha(:,i);
    E=y_train-TrainYhat;
    e(i+1)=norm(E,2)+alpha(i)*norm(Tetha,2);
    i=i+1;
end

cov1=cov(Tetha(1,:)');
cov2=cov(Tetha(2,:)');
cov3=cov(Tetha(3,:)');
cov4=cov(Tetha(4,:)');
cov5=cov(Tetha(5,:)');
cov6=cov(Tetha(6,:)');
cov7=cov(Tetha(7,:)');
cov8=cov(Tetha(8,:)');
cov9=cov(Tetha(9,:)');
cov10=cov(Tetha(10,:)');

COV=[cov1;cov2;cov3;cov4;cov5;cov6;cov7;cov8;cov9;cov10];
figure(1)
bar(COV)
title('cov of \theta s')
xlabel('number of \theta ')
grid on
hold on
%%
tetareal=[-1.5 -0.8 0 0.1 0 -0.65 2.25 0 -1.7 0]';

figure;
for i=1:10
    subplot(2,5,i)
    plot(alpha,Tetha(i,:),'linewidth',2);
    hold on
    plot(alpha,tetareal(i)*ones(1,size(alpha,2)),'linewidth',2);
    a=strcat('teta hat',num2str(i));
    xlabel('alpha')
    legend('estimated','real')
    ylabel(a)
    grid on
end
%%
[Ba,Ia] = sort(COV,'ascend');
Xtrain_new=[x_train(:,Ia(1)) x_train(:,Ia(2)) x_train(:,Ia(3)) x_train(:,Ia(4)) x_train(:,Ia(5))];
Xtest_new=[x_test(:,Ia(1)) x_test(:,Ia(2)) x_test(:,Ia(3)) x_test(:,Ia(4)) x_test(:,Ia(5))];
teta_hat=inv(((Xtrain_new)')*Xtrain_new)*((Xtrain_new)')*y_train;
y_hat=Xtest_new*teta_hat;

figure
plot(y_hat);
hold on;
plot(y_test);
grid on
legend('Estimated','Real')

e_new=y_test-y_hat;
figure
plot(e_new)
grid on
title('Error on test data')
J_new=sum(e_new.^2);
display(mse(e_new),'MSE of Error in Test Data');