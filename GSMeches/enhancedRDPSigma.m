function [sigma] = enhancedRDPSigma(eplison, delta,h)
%% Solve sigma by given privacy budgets for Enhanced RDP
% [1] Asoodeh S, Liao J, Calmon F P, et al. A better bound gives a hundred rounds: Enhanced privacy guarantees via f-divergences[C]//2020 IEEE International Symposium on Information Theory (ISIT). IEEE, 2020: 920-925.
func=@(sigma)(enhancedRDP(sigma, delta,h));
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
