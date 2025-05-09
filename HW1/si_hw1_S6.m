clc
clear all
close all
load ('data')
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
%% load data
y=data(:,nn);
u=data(:,5);
len_train=750;

Y_Train=y(1:len_train,1);
Y_Test=y(len_train+1:end,1);

X=[u.^0 u.^1 u.^2 u.^3 u.^4 u.^5 u.^6 u.^7 u.^8 u.^9];
%%
X_train=X(1:len_train,:);
X_test=X(len_train+1:end,:);

X_train_main=X(1:len_train,:);
X_test_main=X(len_train+1:end,:);

for j=1:size(X,2)
    J=[];    
    for i=1:size(X_train,2)
        temp_train=X_train;
        temp_test=X_test;
        temp_train(:,i)=[];
        temp_test(:,i)=[];
        teta_hat=inv(((temp_train)')*temp_train)*((temp_train)')*Y_Train;
        y_hat=temp_test*teta_hat;
        e=Y_Test-y_hat;
        J(i)=mse(e);
    end
    
    [m,r]=min(J);
    Error(j)=m;
    
    for k=1:size(X,2)
        if X_train(:,r)==X(1:len_train,k)
            num(j)=k;
        end
    end
    X_train(:,r)=[];
    X_test(:,r)=[];
end
disp(strcat('Order of delete Regressors in Backward Elimination =  ',num2str(num)));
figure
plot(Error,'LineWidth',1.5)
xlabel('Number of Regressors')
grid on
title('Cost Function')

%%
se=5;
X_train=X_train_main(:,num(se+1:end));
X_test=X_test_main(:,num(se+1:end));
teta_hat=inv(((X_train)')*X_train)*((X_train)')*Y_Train;
y_hat=X_test*teta_hat;

figure
plot(y_hat);
hold on;
plot(Y_Test);
legend('Estimated','Real')

e_new=Y_Test-y_hat;

figure
plot(e_new)
title('Error')
display(mse(e_new),'MSE of Error in Test Data');