clear all;clc;close all;
delta=1e-6;
eplison=0.1:0.1:10;
m=length(eplison);
sigma1=zeros(m,1);
sigma2=zeros(m,1);
sigma3=zeros(m,1);
sigma4=zeros(m,1);
names={'analytic Gauss Mechanism','classical Gaussian Mechanism','RDP Gaussian Mechanism','Enhanced RDP Gaussian Mechanism','f-DP Gaussian Mechanism'};
h=5;
for i=1:m
    sigma1(i)=anaGaussSigma(eplison(i),delta,sqrt(h));
    sigma2(i)=classicalGaussSigma(eplison(i),delta,sqrt(h));
    sigma3(i)=RDPGaussSigma(eplison(i),delta,sqrt(h));
    sigma4(i)=enhancedRDPSigma(eplison(i),delta,h);
    sigma5(i)=fDPGaussSigma(eplison(i),delta,h);
end
figure;
semilogx(eplison,sigma1);
hold on
semilogx(eplison,sigma2);
hold on
semilogx(eplison,sigma3);
hold on
semilogx(eplison,sigma4);
hold on
semilogx(eplison,sigma5);
legend(names)