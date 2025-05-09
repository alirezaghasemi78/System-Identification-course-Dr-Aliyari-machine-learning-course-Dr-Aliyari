clc
clear all
close all
%% Generating Data
rng(40)
u=randn(1000,1);
u=(u-min(u))/(max(u)-min(u));

figure()
qqplot(u)

figure()
plot(u)

figure()
hist(u)

u8=u.^8;

figure()
hist(u8)
title('histogram of u^8')

noise_Low=normrnd(0,0.001,1000,1);
noise_Medium=normrnd(0,0.01,1000,1);
noise_High=normrnd(0,0.1,1000,1);

figure()
normplot(noise_Low)
plot(noise_Low)

figure()
hist(noise_Low)
title('histogram of noise Low')

figure()
hist(noise_Medium)
title('histogram of noise Medium')

figure()
hist(noise_High)
title('histogram of noise High')

y_without_noise= -1.5 - 0.8*u + 0.1*u.^3 - 0.65*u.^5+ 2.25*u.^6 - 1.7*u.^8 ;
y_Low=(y_without_noise+noise_Low);
y_Medium=(y_without_noise+noise_Medium);
y_High=(y_without_noise+noise_High);

data=[y_without_noise y_Low y_Medium y_High u];

Num=randperm(1000);
% Num
save data data