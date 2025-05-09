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
y=data(:,nn);
u=data(:,5);
len_train=750;
Y_Train=y(1:len_train,1);
Y_Test=y(len_train+1:end,1);

X=[u.^0 u.^1 u.^2 u.^3 u.^4 u.^5 u.^6 u.^7 u.^8 u.^9];
%% 
X_train=X(1:len_train,:);
X_test=X(len_train+1:end,:);

%%
Xtrain_new=[];
Xtest_new=[];
Xtrain_base=X(1:len_train,:);
Xtest_base=X(len_train+1:end,:);

for j=1:size(X,2)
    
    for i=1:size(X_train,2)
        tp_train=[Xtrain_new X_train(:,i)];
        tp_test=[Xtest_new X_test(:,i)];
        teta_hat=inv(((tp_train)')*tp_train)*((tp_train)')*Y_Train;
        y_hat=tp_test*teta_hat;
        er=Y_Test-y_hat;
        J(i)=sum(er.^2);
    end
    
    [m,r]=min(J);
    Error(j)=m;
    J(r)=[];
    for k=1:size(X(1:len_train,:),2)
        if X_train(:,r)==X(1:len_train,k)
            num(j)=k;
        end
    end
    Xtrain_new=[Xtrain_new X_train(:,r)];
    Xtest_new=[Xtest_new X_test(:,r)];
    X_train(:,r)=[];
    X_test(:,r)=[];
end
disp(strcat('Order Of Important Regressors Forward Selection =  ',num2str(num)));
figure
plot(Error,'LineWidth',1.5)
xlabel('Number of Regressors')
title('Cost Function')
grid on
%%
se=4;
Xtrain_new=Xtrain_base(:,num(1:se));
Xtest_new=Xtest_base(:,num(1:se));
teta_hat=inv(((Xtrain_new)')*Xtrain_new)*((Xtrain_new)')*Y_Train;
y_hat=Xtest_new*teta_hat;

figure
plot(y_hat);
hold on;
plot(Y_Test);
grid on
legend('Estimated','Real')


e_new=Y_Test-y_hat;
E=(Y_Test-y_hat)'*(Y_Test-y_hat);
figure
plot(e_new)
grid on
title('Error on test data')

display(mse(e_new),'MSE of Error in Test Data');




