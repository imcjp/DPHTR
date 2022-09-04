function [res] = fDPGauss(epoch, noise_multi, n, batch_size, delta)
%% An Gauss Mechanism implementation by f-DP, the reference paper is as follows:
% [1] Dong J, Roth A, Su W J. Gaussian differential privacy[J]. Journal of the Royal Statistical Society Series B, 2022, 84(1): 3-37.
    mu1=compute_mu_uniform(epoch, noise_multi, n, batch_size);
    res=eps_from_mu(mu1, delta);
end

function res= compute_mu_uniform(epoch, noise_multi, n, batch_size)
    t = epoch * n / batch_size;
    c = batch_size * sqrt(t) / n;
    res= sqrt(2) * c * sqrt(exp(noise_multi^(-2)) * normcdf(1.5 / noise_multi) + 3 * normcdf(-0.5 / noise_multi) - 2);
end

function res=delta_eps_mu(eps, mu)
	res= normcdf(-eps / mu + mu /2) - exp(eps) * normcdf(-eps / mu - mu / 2);
end

function res = f(x,mu,delta)
    res = delta_eps_mu(x, mu) - delta;
end

function res = eps_from_mu(mu, delta)
    func=@(x)(f(x,mu,delta));
    res=binary_search(func, 0, 500,0);
end
  
function s_mid=binary_search(func, s_inf, s_sup,eplison)
    s_mid = s_inf + (s_sup-s_inf)/2.0;
    while s_sup-s_inf>1e-8
        if func(s_mid)<eplison
            s_sup = s_mid;
        else
            s_inf = s_mid;
        end
        s_mid = s_inf + (s_sup-s_inf)/2.0;
    end
end
