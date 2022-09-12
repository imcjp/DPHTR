clear all;clc;close all;
delta=1/(3*10^8);
epsilon=0.1:0.1:10;
% epsilon=1:1:10;
m=length(epsilon);
names={'classical Gaussian Mechanism','RDP Gaussian Mechanism','analytic Gauss Mechanism','Enhanced RDP Gaussian Mechanism','f-DP Gaussian Mechanism'};
n=length(names);
sigma=zeros(m,n);
h=8;
for i=1:m
    fprintf('Run %i-th sample, epsilon = %g ...\n',i,epsilon(i));
    sigma(i,1)=classicalGaussSigma(epsilon(i),delta,sqrt(h));
    sigma(i,2)=RDPGaussSigma(epsilon(i),delta,sqrt(h));
    sigma(i,3)=anaGaussSigma(epsilon(i),delta,sqrt(h));
    sigma(i,4)=enhancedRDPSigma(epsilon(i),delta,h);
    sigma(i,5)=fDPGaussSigma(epsilon(i),delta,sqrt(h));
end
figure;
for i=1:n
    semilogx(epsilon,sigma(:,i));
    hold on
end
legend(names)