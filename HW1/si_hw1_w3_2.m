clc
clear all
close all

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

noise_Low=normrnd(0,0.01,1000,1);
noise_Medium=normrnd(0,0.1,1000,1);
noise_High=normrnd(0,1,1000,1);

noise=[noise_Low noise_Medium noise_High];

%% Generating Data
rng(40)
u1=randn(1000,1);
u1=(u1-min(u1))/(max(u1)-min(u1));

u2=randn(1000,1);
u2=(u2-min(u2))/(max(u2)-min(u2));

teta1=13;
teta2=2;
teta3=8;

y_without_noise=teta1*u1 +teta2*u2 ;
y= teta1*u1 +teta2*u2 +noise(:,nn-1);

X=[u1 u2 +noise(:,nn-1)];

%% LS 
len_train=750;
x_train=X(1:len_train,:);
x_test=X(len_train+1:end,:);
ytrain=y(1:len_train,:);
ytest=y(len_train+1:end,:);
ytest_without_noise=y_without_noise(len_train+1:end,:);
teta=(inv((x_train)'*(x_train)))*(x_train)'*(ytrain);

%%
yhat=x_test*teta;
e=ytest-yhat;
e2=ytest_without_noise-yhat;
%% figure
figure();
plot(yhat);
hold on
plot(ytest);
hold on
plot(ytest_without_noise);
legend('Estimated','Real','y without noise');
grid on;
xlabel('input');
ylabel('output');
saveas(gcf,'1.png')

%% error
figure();
plot(e);
legend('Error on test data');
title('Error1')
saveas(gcf,'2.png')

figure();
plot(e2);
title('Error2')
saveas(gcf,'3.png')

%% error bar
display(mse(e),'Mean squared normalized error1 ')

display(mse(e2),'Mean squared normalized error2 ')
%% Theta_hat_and_tetareal
tetareal=[teta1 teta2 teta3]';
figure()
for i=1:2
    subplot(1,3,i)
    plot(teta(i,:)*ones(1,100),'linewidth',2);
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
saveas(gcf,'4.png')