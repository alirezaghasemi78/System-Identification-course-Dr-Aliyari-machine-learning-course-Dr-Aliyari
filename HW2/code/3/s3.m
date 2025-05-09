clc
close all
clear all

%%
load data_Q3 
Ts = 0.1 ;
data_train = z_tr ;
data_test = z_ts ;

y_train = data_train.OutputData ;
u_train = data_train.InputData ;

y_test = data_test.OutputData ;
u_test = data_test.InputData ;
%% delay
nk = delayest(data_train);
%% FIR
nb = 16 ;
sysFIR21 = impulseest(data_train,nb)
sysFIR21_output = sim(sysFIR21,u_train);
n_FIR = nparams(sysFIR21);
disp(['Num of Parameters of FIR: ' num2str(n_FIR)]);
figure();
compare(data_test,sysFIR21);
y_fir21 = sim(sysFIR21,u_test);
err_fir = y_test - y_fir21;
SSE_FIR = sum(err_fir.^2);
disp(['Sum of Squared Errors (SSE)FIR: ' num2str(SSE_FIR)]);
figure();
resid(data_test, sysFIR21);
title('resid FIR');
[est_num_fir,est_den_fir] = tfdata(sysFIR21,'v');
% sysfir21_tf = filt(sysFIR21.b,sysFIR21.a,Ts);
zeros_fir=roots(est_num_fir)
poles_arx=roots(est_den_fir)

figure();
zplane(est_num_fir,est_den_fir);
title('PZPlane FIR ');
%% OE Model
nb = 1 ;
nf = 2 ;
sysoe221 = oe(data_train,[nb , nf , nk]);
oe221_output = sim(sysoe221,u_train);
n_oe = nparams(sysoe221);
disp(['Num of Parameters of OE: ' num2str(n_oe)]);
figure();
compare(data_test,sysoe221)
y_oe221 = sim(sysoe221,u_test);
err_oe = y_test - y_oe221;
SSE_OE = sum(err_oe.^2);
disp(['Sum of Squared Errors (SSE)OE: ' num2str(SSE_OE)]);
figure();
resid(data_test, sysoe221);
title('resid OE');
[est_num_oe,est_den_oe] = tfdata(sysoe221,'v');
sysoe221_tf = filt(sysoe221.b,sysoe221.f,Ts);
zeros_oe=roots(sysoe221.b)
poles_oe=roots(sysoe221.f)
figure();
zplane(sysoe221.b,sysoe221.f);
title('PZPlane OE ');
%% ARX Model
na = 4 ;
nb = 3 ;
sysarx221 = arx(data_train,[na , nb , nk]);
arx221_output = sim(sysarx221,u_train);
n_arx = nparams(sysarx221);
disp(['Num of Parameters of ARX: ' num2str(n_arx)]);
figure();
compare(data_test,sysarx221);
y_arx221 = sim(sysarx221,u_test);
err_arx = y_test - y_arx221;
SSE_ARX = sum(err_arx.^2);
disp(['Sum of Squared Errors (SSE)ARX: ' num2str(SSE_ARX)]);
figure();
resid(data_test, sysarx221);
title('resid ARX');
[est_num_arx,est_den_arx] = tfdata(sysarx221,'v');
sysarx221_tf = filt(sysarx221.b,sysarx221.a,Ts);
zeros_arx=roots(sysarx221.b)
poles_arx=roots(sysarx221.a)
figure();
zplane(sysarx221.b,sysarx221.a);
title('PZPlane ARX ');

%% ARMAX Model
na = 2 ;
nb = 2 ;
nc = 1 ;
sysarmax2211 = armax(data_train,[na , nb , nc , nk]);
n_armax = nparams(sysarmax2211);
disp(['Num of Parameters of ARMAX: ' num2str(n_armax)]);
figure();
compare(data_test,sysarmax2211);
y_armax2211 = sim(sysarmax2211,u_test);
err_armax = y_test - y_armax2211;
SSE_ARMAX = sum(err_armax.^2);
disp(['Sum of Squared Errors (SSE)ARMAX: ' num2str(SSE_ARMAX)]);
figure();
resid(data_test, sysarmax2211);
title('resid ARMAX');
[est_num_armax,est_den_armax] = tfdata(sysarmax2211,'v');
sysarmax2211_tf = filt(sysarmax2211.b,sysarmax2211.a,Ts);
zeros_armax=roots(sysarmax2211.b)
poles_armax=roots(sysarmax2211.a)
figure();
zplane(sysarmax2211.b,sysarmax2211.a);
title('PZPlane ARMAX ');
%% ARARX
na = 2 ;
nb = 1 ;
nd = 2 ;
sysararx2221 = polyest(data_train,[na , nb , 0 , nd , 0 , nk]);
n_ararx = nparams(sysararx2221);
disp(['Num of Parameters of ARARX: ' num2str(n_ararx)]);
figure();
compare(data_test,sysararx2221);
y_ararx2211 = sim(sysararx2221,u_test);
err_ararx = y_test - y_ararx2211;
SSE_ARARX = sum(err_ararx.^2);
disp(['Sum of Squared Errors (SSE)ARARX: ' num2str(SSE_ARARX)]);
figure();
resid(data_test, sysararx2221);
title('resid ARARX');
[est_num_ararx,est_den_ararx] = tfdata(sysararx2221,'v');
sysararx2211_tf = filt(sysararx2221.b,sysararx2221.a,Ts);
zeros_ararx=roots(sysararx2221.b)
poles_ararx=roots(sysararx2221.a)
figure();
zplane(sysararx2221.b,sysararx2221.a);
title('PZPlane ARARX ');
%% BJ
nb = 1 ;
nf = 2 ;
nc = 1 ;
nd = 1 ;
sysbj = bj(data_train,[nb nc nd nf nk]);
n_bj = nparams(sysbj);
disp(['Num of Parameters of BJ: ' num2str(n_bj)]);
figure();
compare(data_test,sysbj);
y_bj = sim(sysbj,u_test);
err_bj = y_test - y_bj;
SSE_BJ = sum(err_bj.^2);
disp(['Sum of Squared Errors (SSE)BJ: ' num2str(SSE_BJ)]);
figure();
resid(data_test, sysbj);
title('resid BJ');
[est_num_bj,est_den_bj] = tfdata(sysbj,'v');
sysbj_tf = filt(sysbj.b,sysbj.f,Ts);
zeros_bj=roots(sysbj.b)
poles_bj=roots(sysbj.f)
figure();
zplane(sysbj.b,sysbj.f);
title('PZPlane BJ ');
%%
figure();
compare(data_test,sysFIR21,sysoe221,sysarx221,sysarmax2211,sysararx2221,sysbj);

%%
% feedback(G_ol_d,1)
