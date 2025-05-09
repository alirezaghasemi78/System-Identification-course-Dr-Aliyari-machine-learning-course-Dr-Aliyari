clc,clear all,close all;
%% noise choosing
nn=4;
if nn==1
    noise='without noise'
    elseif nn==2
        noise='Low_noise'
    elseif nn==3
        noise='Medium noise'
    elseif nn==4
        noise='Medium noise'
end
noise_Low=normrnd(0,0.001,1000,1);
noise_Medium=normrnd(0,0.01,1000,1);
noise_High=normrnd(0,0.1,1000,1);
%% Load data
load('data');
u=data(:,5);

% g=1;
g=0.01;
t=1:1:750;
teta4=0.5+tansig(g*(t-400));
plot(teta4)
tetareal=[-1.5 -0.8 0 0.1 0 -0.65 2.25 0 -1.7 0]'*ones(1,750);
tetareal(4,:)=teta4;

for i=1:1000
    y_without_noise(i,1)= -1.5 - 0.8*u(i) + (0.5+tansig(g*(i-400)))*u(i).^3 - 0.65*u(i).^5+ 2.25*u(i).^6 - 1.7*u(i).^8 ;
end
y_Low=(y_without_noise+noise_Low);
y_Medium=(y_without_noise+noise_Medium);
y_High=(y_without_noise+noise_High);

data2=[y_without_noise y_Low y_Medium y_High u];

len_train=750;
utest=u(len_train+1:end,1);
utrain=u(1:len_train,1);

%%
y=data2(:,nn);
y_train=y(1:len_train,1);
y_test=y(len_train+1:end,1);

X=[u.^0 u.^1 u.^2 u.^3 u.^4 u.^5 u.^6 u.^7 u.^8 u.^9];
x_train=X(1:len_train,:);
x_test=X(len_train+1:end,:);

%% tetta RLS
%initialize
n=size(X,2);
a=1e4;
P=a*eye(n);
tetta(:,1)=zeros(n,1);
% RLS algorithm
for k=1:size(x_train,1)
    gama=(P*x_train(k,:)')/(1+x_train(k,:)*P*x_train(k,:)');
    P_new=P-(gama*x_train(k,:)*P);

    tetta(:,k+1)=tetta(:,k)+gama*(y_train(k,:)-x_train(k,:)*tetta(:,k));
    P=P_new;
    P_eig(:,k)=eig(P_new);
    y_hat_train(k,:)=x_train(k,:)*tetta(:,k);
end
%% Test
% y_hat_test=x_test*tetta(:,end);
% e=y_test-y_hat_test;

%% Plot Estimation & Real
%% figure
figure();
plot(utrain,y_hat_train,'r*');
hold on
plot(utrain,y_train,'bo');
legend('Estimated','Real');
grid on;
xlabel('input');
ylabel('output');
saveas(gcf,'estimated_and_real2.png')

figure();
for i=1:10
    subplot(2,5,i)
    plot(tetta(i,:),'linewidth',2);
    hold on
    plot(tetareal(i,:),'linewidth',2);
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
figure();
for i=1:10
    subplot(2,5,i)
    plot(P_eig(i,:),'linewidth',2);
    a=strcat('Peig',num2str(i));
    legend('estimated')
    ylabel(a)
    grid on
end
saveas(gcf,'P_eig.png')

figure();
plot(y_hat_train)
hold on
plot(y_train)
xlabel('iteration');
ylabel('output');
legend('Estimated','Real');
saveas(gcf,'estimated_and_real.png')