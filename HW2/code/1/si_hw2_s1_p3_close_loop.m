clc
clear all
close all
%% load data
T=800;
U = binrand(1:T, 10, 40, 1, 'normal')';
%% noise
sigma1 = 0.01;     
sigma2 = 0.05;     
sigma3 = 0.10;     

sigma = sigma3;
v=random('norm',0,sigma,length(U),1);

%% parameters
Ts=0.1;
sys=filt([0 0.48 -0.48],[1 -1.72 0.9],Ts);
csys = feedback(sys,1);
cnoise = feedback(1,sys);
y=lsim(csys,U)+lsim(cnoise,v);

%% iddata
data=iddata(y,U',Ts);
%% parameter
na=2;nb=2;nf=2;nc=1;nd=2;nk=1;
%% ARX
y_arx=arx(data,[na nb nk]);
sys_arx=filt(y_arx.b,y_arx.a,Ts);
est_y_arx=lsim(sys_arx,U);
zeros_sys_arx=roots(y_arx.b)
poles_sys_arx=roots(y_arx.a)
%% ARMAX
y_armax=armax(data,[na nb nc nk]);
sys_armax=filt(y_armax.b,y_armax.a,Ts);
est_y_armax=lsim(sys_armax,U);
zeros_sys_armax=roots(y_armax.b)
poles_sys_armax=roots(y_armax.a)
%% ARARX
y_ararx=pem(data,[na nb 0 nd 0 nk]);
sys_ararx=filt(y_ararx.b,y_ararx.a,Ts);
est_y_ararx=lsim(sys_ararx,U);
zeros_sys_ararx=roots(y_ararx.b)
poles_sys_ararx=roots(y_ararx.a)
%% OE
y_oe=oe(data,[nb nf nk]);
sys_oe=filt(y_oe.b,y_oe.f,Ts);
est_y_oe=lsim(sys_oe,U);
zeros_sys_oe=roots(y_oe.b)
poles_sys_oe=roots(y_oe.f)
%% BJ
y_bj=bj(data,[nb nc nd nf nk]);
sys_bj=filt(y_bj.b,y_bj.f,Ts);
est_y_bj=lsim(sys_bj,U);
zeros_sys_bj=roots(y_bj.b)
poles_sys_bj=roots(y_bj.f)
%% Errors
error_arx=(1/T)*sqrt(sum((est_y_arx-y).^2))
error_armax=(1/T)*sqrt(sum((est_y_armax-y).^2))
error_ararx=(1/T)*sqrt(sum((est_y_ararx-y).^2))
error_bj=(1/T)*sqrt(sum((est_y_bj-y).^2))
error_oe=(1/T)*sqrt(sum((est_y_oe-y).^2))

%% Figure and result
figure
plot(y,'--r','linewidth',2)
hold on
plot(est_y_arx,'-','linewidth',2)
plot(est_y_armax,'m-.','linewidth',2)
plot(est_y_ararx,'g-','linewidth',2)
plot(est_y_oe,'c-.','linewidth',2)
plot(est_y_bj,'k--','linewidth',2)
title(['Output of System and Models with Noise (\mu=0 \sigma^2=0.5'])
xlabel('Samples')
legend('y','ARX','ARMAX','ARARX','OE','BJ')

figure
plot(y-est_y_arx,'-','linewidth',2)
hold on
plot(y-est_y_armax,'m-','linewidth',2)
plot(y-est_y_ararx,'g-','linewidth',2)
plot(y-est_y_oe,'c-','linewidth',2)
plot(y-est_y_bj,'k-','linewidth',2)
title(['Error of Identification with Noise (\mu=0 \sigma^2=0.5'])
legend('ARX','ARMAX','ARARX','OE','BJ')
xlabel('Samples')

figure
compare(y_arx,data)
title('ARX Model')
%xlabel('Samples')
legend('ARX','y')
figure
resid(y_arx,data)
title('ARX Model')

figure
compare(y_armax,data)
title('ARMAX Model')
%xlabel('Samples')
legend('ARMAX','y')
figure
resid(y_armax,data)
title('ARMAX Model')

figure
compare(y_ararx,data)
title('ARARX Model')
%xlabel('Samples')
legend('ARARX','y')
figure
resid(y_ararx,data)
title('ARARX Model')

figure
compare(y_oe,data)
title('OE Model')
%xlabel('Samples')
legend('OE','y')
figure
resid(y_oe,data)
title('OE Model')

figure
compare(y_bj,data)
title('BJ Model')
%xlabel('Samples')
legend('BJ','y')
figure
resid(y_bj,data)
title('BJ Model')

%% AIC
arx_aic = aic( y_arx )
armax_aic = aic( y_armax ) 
ararx_aic = aic( y_ararx ) 
oe_aic = aic( y_oe ) 
bj_aic = aic( y_bj ) 

