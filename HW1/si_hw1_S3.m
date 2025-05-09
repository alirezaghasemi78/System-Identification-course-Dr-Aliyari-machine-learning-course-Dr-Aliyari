clc
clear all
close all
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
%% load data
load ('data')
y=data(:,nn);
u=data(:,5);

Ntrain=750;
SlidingWindow=100;

X=[u.^0 u.^1 u.^2 u.^3 u.^4 u.^5 u.^6 u.^7 u.^8 u.^9];
%% Regularization
Lambda=0.000001;
%% Sliding window
ctr=Ntrain-SlidingWindow;
R=zeros(10,ctr);
for k=1:ctr
    X1=X(k:k+SlidingWindow-1,:);
    Y1=y(k:k+SlidingWindow-1);                
    R(:,k)=(inv(X1'*X1+Lambda*eye(10)))*(X1')*Y1; 
end

teta_hat=mean(R,2);
yhat=X(751:1000,:)*teta_hat;

%% figure

figure;
plot(u(751:1000,:),yhat,'r*');
hold on
plot(u(751:1000,:),y(751:1000,:),'bo');   

legend('Estimated','Real','Location','best');
title('Estimation');
grid on;
xlabel('input');
ylabel('output');
saveas(gcf,'Estimated_and_Real.png')

%% error
e=y(751:1000,:)-yhat;         
display(mse(e),'Mean squared normalized error ')

figure;
plot(u(751:1000,:),e,'ko')
legend('Error','Location','best');
grid on;
xlabel('input');
title('Estimation Error');
%% errorbar
sigma2=((e'*e)/(250-10));
covtetahat=sigma2*(inv((X(751:1000,:)')*X(751:1000,:)));
covyhat=X(751:1000,:)*covtetahat*X(751:1000,:)';
error_band_pos=yhat+sqrt(diag(covyhat));
error_band_neg=yhat-sqrt(diag(covyhat));
figure();
plot(u(751:1000,:),error_band_pos,'ko',u(751:1000,:),error_band_neg,'ko',u(751:1000,:),yhat,'g*');
legend('Error Bar');
grid on;
xlabel('input');
ylabel('Error Bar');
saveas(gcf,'Error_Bar.png')
%%
tetareal=[-1.5 -0.8 0 0.1 0 -0.65 2.25 0 -1.7 0]
figure();
for i=1:10
    subplot(2,5,i)
    plot(1:ctr,R(i,:),'color','k','linewidth',2);
    hold on
    plot(1:ctr,tetareal(i)*ones(1,ctr),'color','r','linewidth',2)
    xlabel('Iteration')
    title(' \Theta');
    legend('\Theta hat','\Theta','Location','best');
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

