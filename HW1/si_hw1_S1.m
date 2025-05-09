clc
clear all
close all
%% noise choosing 
nn=1;
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
y=data(:,nn);
X=[u.^0 u.^1 u.^2 u.^3 u.^4 u.^5 u.^6 u.^7 u.^8 u.^9];
%% Regularization
Lambda=0.000001;
%% LS for 75 data train 25 test
% for k=0:1:9
% xtrain=X(100*k+1:100*k+75,:);
% ytrain=y(100*k+1:100*k+75);
% teta(k+1,:)=(inv((xtrain)'*(xtrain)+Lambda*eye(10)))*(xtrain)'*(ytrain);
% end
% 
% for i=0:1:9
%     utest(25*i+1:25*(i+1),1)=u(100*i+76:100*(i+1));
%     ytest(25*i+1:25*(i+1),1)=y(100*i+76:100*(i+1));
%     xtest(25*i+1:25*(i+1),1:10)= X(100*i+76:100*(i+1),1:10);
% end
%% LS for 150 data train 50 test
a1=[1 201 401 601 801];
a2=[150 350 550 750 950];
a3=[151 351 551 751 951];
a4=[200 400 600 800 1000];

for k=0:1:4
xtrain=X(a1(k+1):a2(k+1),:);
ytrain=y(a1(k+1):a2(k+1));
teta(k+1,:)=(inv((xtrain)'*(xtrain)+Lambda*eye(10)))*(xtrain)'*(ytrain);
end

for i=0:1:4
    utest(50*i+1:50*(i+1))=u(a3(i+1):a4(i+1));
    ytest(50*i+1:50*(i+1),1)=y(a3(i+1):a4(i+1));
    xtest(50*i+1:50*(i+1),:)= X(a3(i+1):a4(i+1),:);
end
%%
tetahat=(mean(teta))';
yhat=xtest*tetahat;
e=ytest-yhat;

%% figure
figure();
plot(utest,yhat,'r*');
hold on
plot(utest,ytest,'bo');
legend('Estimated','Real');
% title()
grid on;
xlabel('input');
ylabel('output');
saveas(gcf,'Estimated_and_Real.png')

%% error
figure();
plot(utest,e,'ko');
legend('Error on test data');
title(sprintf('e %1$s ',noise))
% saveas(gcf,'Error.png')

%% error bar
display(mse(e),'Mean squared normalized error ')

sigma2=((e'*e)/(250-10));                     %%N-n
cov_tetahat=(sigma2)*(inv(xtest'*xtest));
covyhat=xtest*cov_tetahat*xtest';
error_band_pos=yhat+sqrt(diag(covyhat));
error_band_neg=yhat-sqrt(diag(covyhat));

figure();
plot(utest,error_band_pos,'ko',utest,error_band_neg,'ko',utest,yhat,'g*');
legend('upper bound','lower bound','Estimated data');
grid on;
xlabel('input');
title(sprintf('Error Bar for %1$s data',noise))
saveas(gcf,'Error_Bar.png')

%% Theta_hat_and_tetareal
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