clc
clear
close all
%% Input Data
T=800;                                                                     %T
U1 = binrand(1:T, 10, 40, 1, 'normal')';                                   %u
U2 = binrand(1:T, 30, 10, 1, 'normal')';
U3 = normrnd(0, 1, 1,T);
U4 = unifrnd(-1, 1, 1,T);

k =1
if k == 1
    U = U1;
elseif k == 2
    U = U2;
elseif k == 3
    U = U3;
else
    U = U4;
end
figure
plot(U)
title('Input Data')

%% system
Ts=0.1;                                                                    %ts
sys=filt([0 0.48 -0.48],[1 -1.72 0.9],Ts);                                 %digital systems
y_1=lsim(sys,U);

% s=tf('s');
% G3=exp(-0.2*s)/(s+1)^6
% sysd = c2d(sys,0.1)

%% iddata
data_1=iddata(y_1,U',Ts);

%% ARX
na=2;nb=2;nc=1;nk=1;
estimated_y_1_arx=arx(data_1,[na nb nk])
[est_num_1_arx,est_den_1_arx]=tfdata(estimated_y_1_arx,'v');
est_sys_1_arx=tf(est_num_1_arx,est_den_1_arx,Ts);
est_y_1_arx=lsim(est_sys_1_arx,U);

%% ARMAX
estimated_y_1_armax=armax(data_1,[na nb nc nk])
sys1_armax=filt(estimated_y_1_armax.b,estimated_y_1_armax.a,Ts);
est_y_1_armax=lsim(sys1_armax,U);

%% poles and zeros
disp('zeros_and_poles_sys')
zeros_sys=roots([0 0.48 -0.48])
poles_sys=roots([1 -1.72 0.9])
disp('zeros_and_poles_arx_1')
zeros_arx_1=roots([estimated_y_1_arx.b])
poles_arx_1=roots(estimated_y_1_arx.a)
disp('zeros_and_poles_armax_1')
zeros_armax_1=roots([estimated_y_1_armax.b])
poles_armax_1=roots(estimated_y_1_armax.a)

%% Errors
error_arx_1=(1/T)*sqrt(sum((est_y_1_arx - y_1).^2))

error_armax_1=(1/T)*sqrt(sum((est_y_1_armax-y_1).^2))

%% Plot
figure
plot(y_1,'--r','linewidth',2)
hold on
plot(est_y_1_arx,'b','linewidth',2)
plot(est_y_1_armax,'k','linewidth',2)
title('ARX and ARMAX Model (binrand Input)')
xlabel('Samples')
legend('y','ARX','ARMAX')

figure
plot(y_1-est_y_1_arx,'linewidth',2)
hold on
plot(y_1-est_y_1_armax,'k','linewidth',2)
title('Error ARX and ARMAX (binrand Input)')
legend('ARX','ARMAX')
xlabel('Samples')
%% plot 1
figure
compare(estimated_y_1_arx,data_1)
title('ARX Model')
%xlabel('Samples')
legend('y','ARX')
figure
resid(estimated_y_1_arx,data_1)
title('ARX Model')
%xlabel('Samples')
%legend('y','ARX','ARMAX')

figure
compare(estimated_y_1_armax,data_1)
title('ARMAX Model')
%xlabel('Samples')
legend('y','ARMAX')
figure
resid(estimated_y_1_armax,data_1)
title('ARMAX Model')
%xlabel('Samples')
%legend('y','ARX','ARMAX')

figure
crosscorr( y_1-est_y_1_armax , y_1 )
title('ARMAX crosscorr ')

figure
crosscorr( y_1-est_y_1_arx , y_1 )
title('ARX crosscorr ')
