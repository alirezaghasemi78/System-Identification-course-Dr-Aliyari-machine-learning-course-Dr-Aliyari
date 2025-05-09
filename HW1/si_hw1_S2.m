clc
clear all
close all
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
load ('data')
u=data(:,5);
u_test=u;
u_train=0.8*u;

noise_Low=normrnd(0,0.001,1000,1);
noise_Medium=normrnd(0,0.01,1000,1);
noise_High=normrnd(0,0.1,1000,1);

%%
y_without_noise_train= -1.5 - 0.8*u_train + 0.1*u_train.^3 - 0.65*u_train.^5+ 2.25*u_train.^6 - 1.7*u_train.^8 ;

ytrain_High=y_without_noise_train+noise_High; %noise2 ba variance 0.1
ytrain_Medium=y_without_noise_train+noise_Medium;%noise3 ba variance 0.01
ytrain_Low=y_without_noise_train+noise_Low;%noise4 ba variance 0.001
y_train=[y_without_noise_train ytrain_Low ytrain_Medium ytrain_High];

y_without_noise_test= -1.5 - 0.8*u_test + 0.1*u_test.^3 - 0.65*u_test.^5+ 2.25*u_test.^6 - 1.7*u_test.^8 ;

ytest_High=y_without_noise_test+noise_High;
ytest_Medium=y_without_noise_test+noise_Medium;
ytest_Low=y_without_noise_test+noise_Low;

y_test=[y_without_noise_test ytest_Low ytest_Medium ytest_High];

X_test=[u_test.^0 u_test.^1 u_test.^2 u_test.^3 u_test.^4 u_test.^5 u_test.^6 u_test.^7 u_test.^8 u_test.^9];
X_train=[u_train.^0 u_train.^1 u_train.^2 u_train.^3 u_train.^4 u_train.^5 u_train.^6 u_train.^7 u_train.^8 u_train.^9];
%%
%% Regularization
Lambda=0.000001;
%% LS
ytrain=y_train(:,nn);
ytest=y_test(:,nn);
for k=0:1:9
x_train=X_train(100*k+1:100*k+75,1:10);
y_train1=ytrain(100*k+1:100*k+75);
teta(k+1,1:10)=(inv((x_train)'*(x_train)+Lambda*eye(10)))*(x_train)'*(y_train1);
end
tetahat=(mean(teta))';

for i=0:9
    u_test1(25*i+1:25*(i+1),1)=u_test(100*i+76:100*(i+1));
    ytest1(25*i+1:25*(i+1),1)=ytest(100*i+76:100*(i+1));
    x_test(25*i+1:25*(i+1),1:10)= X_test(100*i+76:100*(i+1),1:10);
end
yhat=x_test*tetahat;
e=ytest1-yhat;
%% figure
figure();
plot(u_test1,yhat,'r*');
hold on
plot(u_test1,ytest1,'bo');

legend('Estimated','Real');
% title()
grid on;
xlabel('input');
ylabel('output');
saveas(gcf,'Estimated_AND_Real.png')

figure();
plot(u_test1,e,'ko');
legend('Error on test data');
title(sprintf('e %1$s ',noise))

%% error bar
display(mse(e),'Mean squared normalized error ')

sigma2=((e'*e)/(250-10));                     %%N-n
cov_tetahat=(sigma2)*(inv(x_test'*x_test));
covyhat=x_test*cov_tetahat*x_test';
error_band_pos=yhat+sqrt(diag(covyhat));
error_band_neg=yhat-sqrt(diag(covyhat));

figure();
plot(u_test1,error_band_pos,'ko',u_test1,error_band_neg,'ko',u_test1,yhat,'g*');
legend();
grid on;
xlabel('input');
title(sprintf('Error Bar= %1$s',noise))
saveas(gcf,'Error Bar.png')

tetareal=[-1.5 -0.8 0 0.1 0 -0.65 2.25 0 -1.7 0]';

figure()
for i=1:10
    subplot(2,5,i)
    plot(tetahat(i,:)*ones(1,100),'linewidth',2);
    hold on
    plot(tetareal(i)*ones(1,100),'linewidth',2);
    a=strcat('teta hat',num2str(i));
    legend('estimated','real')
    ylabel(a)
    grid on
end
% Set the desired figure size
figure_width = 8;  % Width in inches
figure_height = 6; % Height in inches

% Set the figure's 'PaperPosition' property
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [figure_width figure_height]);
set(gcf, 'PaperPosition', [0 0 figure_width figure_height]);
saveas(gcf,'Theta_hat_and_tetareal.png')