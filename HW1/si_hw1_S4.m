%%
clc
clear all
close all
rng(40)
%% noise choosing 
nn=4;
if nn==1
    noise='without noise'
    elseif nn==2
        noise='Low noise'
    elseif nn==3
        noise='Medium noise'
    elseif nn==4
        noise='High noise'
end
%% load data
load('data')
u=data(:,5);
X=[u.^0 u.^1 u.^2 u.^3 u.^4 u.^5 u.^6 u.^7 u.^8 u.^9];
y=data(:,nn);
%% Regularization
Lambda=0.000001;
%% ls
for k=0:1:9
xtrain=X(100*k+1:100*k+75,:);
ytrain=y(100*k+1:100*k+75);

%% 1
% xtrain(end-10:end)=xtrain(end-10:end)+5*rand(1,11);
% ytrain(end-10:end)=ytrain(end-10:end)+10*rand(1,11)';
% 
% teta(k+1,:)=(inv((xtrain)'*(xtrain)+Lambda*eye(10)))*(xtrain)'*(ytrain);
% meanX=mean(xtrain);
% 
% for i=1:75
%  P(i,i)=exp(-1*norm((xtrain(i,:)-meanX)));
% end
% 
% teta_new(k+1,1:10)=inv(xtrain'*P*xtrain+Lambda*eye(10))*xtrain'*P*ytrain;

%% 2
ytrain(end-10:end)=ytrain(end-10:end)+5*rand(1,11)';
teta(k+1,:)=(inv((xtrain)'*(xtrain)+Lambda*eye(10)))*(xtrain)'*(ytrain);
if k>0
tetahat2=(mean(teta))';
else
    tetahat2=teta';
end

yhat_train=xtrain*tetahat2;
e2=ytrain-yhat_train;
for r=1:size(e2,1)
    Q(r,r)=1/(1+10*e2(r,:));
end

teta_new(k+1,:)=inv(xtrain'*Q*xtrain+Lambda*eye(10))*xtrain'*Q*ytrain;
end
tetahat=(mean(teta))';

for i=0:9
    utest(25*i+1:25*(i+1))=u(100*i+76:100*(i+1));
    ytest(25*i+1:25*(i+1),:)=y(100*i+76:100*(i+1));
    xtest(25*i+1:25*(i+1),(1:10))= X(100*i+76:100*(i+1),(1:10));
end
yhat=xtest*tetahat;
e=ytest-yhat;

%%
tetahat_new=(mean(teta_new))';
yhat_new=xtest*tetahat_new;
e_new=ytest-yhat_new;
%% plot
figure();
plot(utest,yhat_new,'r*');
hold on
plot(utest,yhat,'k*');
hold on
plot(utest,ytest,'bO');
legend('Estimated (WLS)','Old Estimated (LS)','Real');
grid on;
xlabel('input');
ylabel('output');
saveas(gcf,'Estimated_and_Real.png')

% figure;
% plot(utest,e,'ko');
% legend('Error');
% grid on;
% xlabel('input');
% ylabel('Error');

%% Error Bar
sigma2=((e'*e)/(250-10));                   
cov_tetahat=(sigma2)*(inv(xtest'*xtest));
covyhat=xtest*cov_tetahat*xtest';
error_band_pos=yhat+sqrt(diag(covyhat));
error_band_neg=yhat-sqrt(diag(covyhat));

figure();
plot(utest,error_band_pos,'ko',utest,error_band_neg,'ko',utest,yhat,'g*');
legend('Error Bar');
grid on;
xlabel('input');
title('Error Bar on Old Estimated (LS)')
saveas(gcf,'Error_Bar_Old_Estimated.png')

sigma3=((e_new'*e_new)/(250-10));                  
cov_tetahat2=(sigma3)*(inv(xtest'*xtest));
covyhat2=xtest*cov_tetahat2*xtest';
error_band_pos2=yhat+sqrt(diag(covyhat2));
error_band_neg2=yhat-sqrt(diag(covyhat2));

figure();
plot(utest,error_band_pos2,'ko',utest,error_band_neg2,'ko',utest,yhat,'g*');
legend('Error Bar');
grid on;
xlabel('input');
title('Error Bar on New Estimated (WLS)')
saveas(gcf,'Error_Bar_New_Estimated.png')

display(mse(e),'Mean squared normalized old error (LS) ')
display(mse(e_new),'Mean squared normalized new error (WLS)')


