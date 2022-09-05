clear all;clc;close all;
delta=1e-6;
eplison=0.1:0.1:10;
m=length(eplison);
names={'analytic Gauss Mechanism','classical Gaussian Mechanism','RDP Gaussian Mechanism','Enhanced RDP Gaussian Mechanism','f-DP Gaussian Mechanism'};
n=length(names);
sigma=zeros(m,n);
h=5;
for i=1:m
    sigma(i,1)=anaGaussSigma(eplison(i),delta,sqrt(h));
    sigma(i,2)=classicalGaussSigma(eplison(i),delta,sqrt(h));
    sigma(i,3)=RDPGaussSigma(eplison(i),delta,sqrt(h));
    sigma(i,4)=enhancedRDPSigma(eplison(i),delta,h);
    sigma(i,5)=fDPGaussSigma(eplison(i),delta,h);
end
figure;
for i=1:n
    semilogx(eplison,sigma(:,i));
    hold on
end
legend(names)