function [eplison] = enhancedRDP(sigma, delta,h)
%% An Enhanced privacy guarantees implementation refer to Lemma 1 in [1], which gives a better for RDP.
% [1] Asoodeh S, Liao J, Calmon F P, et al. A better bound gives a hundred rounds: Enhanced privacy guarantees via f-divergences[C]//2020 IEEE International Symposium on Information Theory (ISIT). IEEE, 2020: 920-925.
func=@(alpha)(eplisonWithAlpha(alpha,sigma, delta,h));
z=golden(func,1,1/delta);
eplison=func(z);
end

function [eplison] = eplisonWithAlpha(alpha,sigma, delta,h)
    gamma=h*alpha/(2*sigma^2);
    if alpha*delta<1
        etaA=1/alpha*((1-1/alpha)^(alpha-1));
        kexi=(exp((alpha-1)*gamma)-1)/(alpha-1);
        f1=(alpha-1)*gamma-log(delta/etaA);
        f2=log((alpha-1)*kexi/(alpha*delta)+1);
        eplison=min(max(f1,0),f2)/(alpha-1);
    else
        eplison=max(gamma+log(1-delta),0);
    end
end