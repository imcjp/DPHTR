function [sigma] = fDPGaussSigma(eplison, delta,h)
%% Solve sigma by given privacy budgets for f-DP Gauss Mechanism
% [1] Dong J, Roth A, Su W J. Gaussian differential privacy[J]. Journal of the Royal Statistical Society Series B, 2022, 84(1): 3-37.
func=@(sigma)(fDPGauss(h, sigma, 1, 1, delta));
sigma=binary_search(func, 0, 100,eplison);
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
