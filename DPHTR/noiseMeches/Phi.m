function res = Phi(t)
% res =0.5*(1.0 + erf(t/sqrt(2.0)));
res= normcdf(t,0,1);
end